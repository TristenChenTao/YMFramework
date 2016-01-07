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

//for mac
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

//for idfa
#import <AdSupport/AdSupport.h>

#import "MobClick.h"

#import "NSString+YMAdditions.h"
#import "YMFrameworkConfig.h"

@implementation YMAnalytics

static NSString *URL_Domain_Temp = @"http://192.168.1.71:8091";

static NSString *URL_Report_Action = @"/Interface/IosActive";

static NSString *URL_Init_Info = @"/Interface/Init";

static NSString *URL_Report_Launch = @"/Interface/IosLaunch";

static NSString *KAnalyticsModelArray = @"KAnalyticsModelArray";

static NSString *KSessionID = @"KSessionID";

static NSMutableArray *analyticsModelArray = nil;

static double  currentUTCTime;

static BOOL  debugMode;

static NSString  *currentSessionId;

static NSInteger kSendInterval = 10;

static NSTimer *timer = nil;

dispatch_source_t timerSource;

+ (void)startByUMengAppKey:(NSString *)appKey
                 channelID:(NSString *)channelID
{
    //um
    if ([NSString ym_isContainString:appKey]) {
        [MobClick startWithAppkey:appKey
                     reportPolicy:SEND_INTERVAL
                        channelId:channelID];
        
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [MobClick setAppVersion:version];
        
        //umtrack
        NSString * deviceName = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString * mac = [YMAnalytics macString];
        NSString * idfa = [YMAnalytics idfaString];
        NSString * idfv = [YMAnalytics idfvString];
        NSString * urlString = [NSString stringWithFormat:@"http://log.umtrack.com/ping/%@/?devicename=%@&mac=%@&idfa=%@&idfv=%@", appKey, deviceName, mac, idfa, idfv];
        [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:urlString]] delegate:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [self startReport];
}


#pragma mark - public method

+ (void)setDebugMode:(BOOL)isDebugMode
{
    debugMode = isDebugMode;
}

+ (void)event:(NSString *)eventId
{
    YMAnalyticsModel *model = [[YMAnalyticsModel alloc] init];
    model.actionId = eventId;
    model.actionTimestamp = [NSString stringWithFormat:@"%.f",currentUTCTime];
    [analyticsModelArray addObject:model];
}

#pragma mark - event response

+ (void)applicationDidEnterBackground
{
    [self requestReportActions];
    [self stopTimer];
}

+ (void)applicationWillEnterForeground
{
    [self readAlyticsModelInfoFromDisk];
    [self startTimer];
    [self performSelector:@selector(requestInitInfo)
               withObject:nil
               afterDelay:0.5f];
}

#pragma mark - private method

+ (void)startReport
{
    [self applicationWillEnterForeground];
    analyticsModelArray = [[NSMutableArray alloc] init];
    [self performSelector:@selector(reportLaunchEvent)
               withObject:nil
               afterDelay:0.5f];
}

+ (void)startTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:kSendInterval
                                             target:self
                                           selector:@selector(requestReportActions)
                                           userInfo:nil
                                            repeats:YES];
}

+ (void)stopTimer
{
    if (timer != nil) {
        [timer invalidate];
    }
}

+ (void)reportLaunchEvent
{
    [self performSelector:@selector(requestReportLaunchEvent)
               withObject:nil
               afterDelay:0.5f];
}

+ (void)requestReportActions
{
    [self requestReportActions:analyticsModelArray
                     sessionId:currentSessionId];
}

+ (void)setCurrentTimer
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timerSource, dispatch_walltime(DISPATCH_TIME_NOW, 0), 1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timerSource, ^{
        currentUTCTime += 1;
    });
    dispatch_resume(timerSource);
}

+ (void)readAlyticsModelInfoFromDisk
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:KAnalyticsModelArray];
    NSString *sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:KSessionID];
    if (data.length > 0) {
        NSMutableArray *actions = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (actions != nil && actions.count > 0) {
            [self requestReportActions:actions
                             sessionId:sessionId];
        }
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:KAnalyticsModelArray];
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:KSessionID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)failWhenEnterBackground
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:analyticsModelArray];
    [[NSUserDefaults standardUserDefaults] setObject:currentSessionId
                                              forKey:KSessionID];
    [[NSUserDefaults standardUserDefaults] setObject:data
                                              forKey:KAnalyticsModelArray];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [analyticsModelArray removeAllObjects];
    currentSessionId = @"";
}

+ (void)requestInitInfo
{
    [YMHTTPRequestManager requestWithMethodType:YMHttpMethodTypeForGet
                                    relativeURL:URL_Init_Info
                                        baseURL:URL_Domain_Temp
                                         baseIP:URL_Domain_Temp
                                    headerField:nil
                                     parameters:nil
                                        timeout:5
                                        success:^(NSURLRequest *request, NSInteger ResultCode, NSString *ResultMessage, id data){
                                            NSDictionary *result = data;
                                            currentSessionId = [[result objectForKey:@"SessionId"] stringValue];
                                            currentUTCTime = [[result objectForKey:@"UtcTime"] doubleValue];
                                            [self setCurrentTimer];
                                        }
                                        failure:^(NSURLRequest *request, NSError *error){
                                            NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
                                            currentUTCTime = timeInterval;
                                            [self setCurrentTimer];
                                        }];
}

+ (void)requestReportActions:(NSMutableArray *)actions
                   sessionId:(NSString *)sessionId
{
    if (actions == nil || actions.count == 0 ) {
        return;
    }
    
    if ([NSString ym_isEmptyString:sessionId]) {
        [self requestInitInfo];
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
    
    if (debugMode) {
        NSString *jsonString = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
        NSLog(@"===%@===",jsonString);
    }
    
    [YMHTTPRequestManager uploadJSONData:data
                             relativeURL:URL_Report_Action
                                 baseURL:URL_Domain_Temp
                                  baseIP:URL_Domain_Temp
                             headerField:nil
                              parameters:nil
                                 timeout:0
                                 success:^(NSURLRequest *request, NSInteger ResultCode, NSString *ResultMessage, id data){
                                     [actions removeAllObjects];
                                 }
                                 failure:^(NSURLRequest *request, NSError *error){
                                     if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
                                         [self failWhenEnterBackground];
                                     }
                                 }];
}

+ (void)requestReportLaunchEvent
{
    [YMHTTPRequestManager requestWithMethodType:YMHttpMethodTypeForGet
                                    relativeURL:URL_Report_Launch
                                        baseURL:URL_Domain_Temp
                                         baseIP:URL_Domain_Temp
                                    headerField:nil
                                     parameters:nil
                                        timeout:0
                                        success:^(NSURLRequest *request, NSInteger ResultCode, NSString *ResultMessage, id data){
                                        }
                                        failure:^(NSURLRequest *request, NSError *error){
                                        }];
}

+ (NSString * )macString
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return macString;
}

+ (NSString *)idfaString
{
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil) {
        return @"";
    }
    else{
        
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        
        if(asIdentifierMClass == nil){
            return @"";
        }
        else{
            
            //for no arc
            //ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
            //for arc
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            
            if (asIM == nil) {
                return @"";
            }
            else{
                
                if(asIM.advertisingTrackingEnabled){
                    return [asIM.advertisingIdentifier UUIDString];
                }
                else{
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}

+ (NSString *)idfvString
{
    if([[UIDevice currentDevice] respondsToSelector:@selector( identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return @"";
}

@end
