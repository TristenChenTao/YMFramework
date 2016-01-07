//
//  YMAnalytics.m
//  YMFramework
//
//  Created by 涛 陈 on 4/21/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import "YMAnalytics.h"
#import "YMAnalyticsModel.h"
#import "YMHTTPRequestManager.h"

#import "NSString+YMAdditions.h"
#import "YMFrameworkConfig.h"
#import "YMDeviceInfo.h"

#import "MobClick.h"

@implementation YMAnalytics

static NSString *URL_Domain = @"http://statistics.cornapp.com";

static NSString *URL_Domain_IP = @"http://112.74.105.46:8892";

static NSString *URL_Report_Action = @"/Interface/IosActive";

static NSString *URL_Init_Info = @"/Interface/Init";

static NSString *URL_Report_Launch = @"/Interface/IosLaunch";

static NSString *KAnalyticsModelArrayKey = @"KAnalyticsModelArray";

static NSString *KSessionIDKey = @"KSessionID";

static NSMutableArray *kAnalyticsModelArray = nil;

static double  kCurrentUTCTime;

static BOOL  kDebugMode;

static NSString  *kCurrentSessionId;

static NSInteger kSendInterval = 60;

static NSTimer *kTimer = nil;

#pragma mark - public method

+ (void)setUMengAppKey:(NSString *)appKey
             channelID:(NSString *)channelID
{
    //友盟
    if ([NSString ym_isContainString:appKey]) {
        [MobClick startWithAppkey:appKey
                     reportPolicy:SEND_INTERVAL
                        channelId:channelID];
        
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [MobClick setAppVersion:version];
        
        //umtrack
        NSString * deviceName = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString * mac = [YMDeviceInfo macString];
        NSString * idfa = [YMDeviceInfo idfaString];
        NSString * idfv = [YMDeviceInfo idfvString];
        NSString * urlString = [NSString stringWithFormat:@"http://log.umtrack.com/ping/%@/?devicename=%@&mac=%@&idfa=%@&idfv=%@", appKey, deviceName, mac, idfa, idfv];
        [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] delegate:nil];
    }
}

+ (void)startReport
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    kAnalyticsModelArray = [NSMutableArray array];
    [self applicationWillEnterForeground];
    [self reportLaunch];
}

+ (void)setDebugMode:(BOOL)isDebugMode
{
    kDebugMode = isDebugMode;
    
    if (kDebugMode) {
        kSendInterval = 10;
    }
}

+ (void)event:(NSString *)eventId
{
    YMAnalyticsModel *model = [[YMAnalyticsModel alloc] init];
    model.actionId = eventId;
    model.actionTimestamp = [NSString stringWithFormat:@"%.f",kCurrentUTCTime];
    [kAnalyticsModelArray addObject:model];
}

#pragma mark - event response

+ (void)applicationDidEnterBackground
{
    YM_BgTaskBegin();
    [self requestReportActions:kAnalyticsModelArray
                     sessionId:kCurrentSessionId];
    YM_BgTaskEnd();

    [self stopTimer];
}

+ (void)applicationWillEnterForeground
{
    [self reportActionsIfLastEnterBackgroundReportFail];
    [self requestInitInfo];
    [self startTimer];
}

#pragma mark - private method

+ (void)startTimer
{
    kTimer = [NSTimer scheduledTimerWithTimeInterval:kSendInterval
                                             target:self
                                           selector:@selector(requestReportActions)
                                           userInfo:nil
                                            repeats:YES];
}

+ (void)stopTimer
{
    if (kTimer != nil) {
        [kTimer invalidate];
    }
}

+ (void)requestReportActions
{
    [self requestReportActions:kAnalyticsModelArray
                     sessionId:kCurrentSessionId];
}


+ (void)setCurrentTimer
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timerSource, dispatch_walltime(DISPATCH_TIME_NOW, 0), 1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timerSource, ^{
        kCurrentUTCTime += 1;
    });
    dispatch_resume(timerSource);
}

+ (void)reportActionsIfLastEnterBackgroundReportFail
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:KAnalyticsModelArrayKey];
    NSString *sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:KSessionIDKey];
    if (data.length > 0) {
        NSMutableArray *actions = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (actions != nil && actions.count > 0) {
            [self requestReportActions:actions
                             sessionId:sessionId];
        }
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:KAnalyticsModelArrayKey];
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:KSessionIDKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)requestInitInfo
{
    static int repeatRequestInitInfoCountIfFail = 0;
    
    [YMHTTPRequestManager requestWithMethodType:YMHttpMethodTypeForGet
                                    relativeURL:URL_Init_Info
                                        baseURL:URL_Domain
                                         baseIP:URL_Domain_IP
                                    headerField:nil
                                     parameters:nil
                                        timeout:5
                                        success:^(NSURLRequest *request, NSInteger ResultCode, NSString *ResultMessage, id data){
                                            NSDictionary *result = data;
                                            kCurrentSessionId = [[result objectForKey:@"SessionId"] stringValue];
                                            kCurrentUTCTime = [[result objectForKey:@"UtcTime"] doubleValue];
                                            [self setCurrentTimer];
                                            
                                            repeatRequestInitInfoCountIfFail = 0;
                                        }
                                        failure:^(NSURLRequest *request, NSError *error){
                                            if (repeatRequestInitInfoCountIfFail < 3) {
                                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC));
                                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                                                               {
                                                                   [YMAnalytics requestInitInfo];
                                                               });
                                                
                                                repeatRequestInitInfoCountIfFail++;
                                            }
                                        }];
}

+ (void)requestReportActions:(NSMutableArray *)actions
                   sessionId:(NSString *)sessionId
{
    if (actions == nil || actions.count == 0 || [NSString ym_isEmptyString:sessionId]) {
        return;
    }
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (YMAnalyticsModel *model in actions) {
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
        [temp setValue:model.actionId forKey:@"actionid"];
        [temp setValue:model.actionTimestamp forKey:@"time"];
        [array addObject:temp];
    }
    [dictionary setObject:array
                   forKey:@"records"];
    [dictionary setValue:sessionId
                  forKey:@"sessionId"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:kNilOptions
                                                     error:nil];
    
    if (kDebugMode) {
        NSString *jsonString = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
        NSLog(@"Analytics report Actions is %@",jsonString);
    }
    
    [YMHTTPRequestManager uploadJSONData:data
                             relativeURL:URL_Report_Action
                                 baseURL:URL_Domain
                                  baseIP:URL_Domain_IP
                             headerField:nil
                              parameters:nil
                                 timeout:3
                                 success:^(NSURLRequest *request, NSInteger ResultCode, NSString *ResultMessage, id data){
                                     [actions removeAllObjects];
                                 }
                                 failure:^(NSURLRequest *request, NSError *error){
                                     if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
                                         [self saveActionsIfEnterBackgroundReportFail];
                                     }
                                 }];
}

+ (void)saveActionsIfEnterBackgroundReportFail
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:kAnalyticsModelArray];
    [[NSUserDefaults standardUserDefaults] setObject:kCurrentSessionId
                                              forKey:KSessionIDKey];
    [[NSUserDefaults standardUserDefaults] setObject:data
                                              forKey:KAnalyticsModelArrayKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [kAnalyticsModelArray removeAllObjects];
    kCurrentSessionId = @"";
}

+ (void)reportLaunch
{
    static int repeatReportLaunchCountIfFail = 0;
    [YMHTTPRequestManager requestWithMethodType:YMHttpMethodTypeForGet
                                    relativeURL:URL_Report_Launch
                                        baseURL:URL_Domain
                                         baseIP:URL_Domain_IP
                                    headerField:nil
                                     parameters:nil
                                        timeout:5
                                        success:^(NSURLRequest *request, NSInteger ResultCode, NSString *ResultMessage, id data) {
                                            repeatReportLaunchCountIfFail = 0;
                                        } failure:^(NSURLRequest *request, NSError *error) {
                                            if (repeatReportLaunchCountIfFail < 3) {
                                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC));
                                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                                                {
                                                    [YMAnalytics reportLaunch];
                                                });
                                                repeatReportLaunchCountIfFail++;
                                            }
                                        }];
}

@end
