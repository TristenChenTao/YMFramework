//
//  YMAnalytics.m
//  YMFramework
//
//  Created by 涛 陈 on 4/21/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <UMMobClick/MobClick.h>

#import "YMAnalytics.h"
#import "NSString+YMAdditions.h"
#import "YMDeviceInfo.h"

@implementation YMAnalytics

#pragma mark - public method


+ (void)setUMengAppKey:(NSString *)appKey
{
    //友盟
    if ([NSString ym_isContainString:appKey]) {

        UMConfigInstance.appKey = appKey;
        
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

@end
