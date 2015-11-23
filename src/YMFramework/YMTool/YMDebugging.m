//
//  YMDebugging.m
//  YMFramework
//
//  Created by 涛 陈 on 5/29/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import "FLEXManager.h"

#import "YMDebugging.h"

@implementation YMDebugging

+ (void)showExplorer
{
    [[FLEXManager sharedManager] showExplorer];
}

+ (void)setNetworkDebuggingEnabled:(BOOL)networkDebuggingEnabled
{
    [FLEXManager sharedManager].networkDebuggingEnabled = networkDebuggingEnabled;
}

+ (void)showCurrentVersionInfo
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"当前版本"
                                                    message:[NSString stringWithFormat:@"%@ V%@ B%@",bundleID, version, build]
                                                   delegate:nil
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil];
    
    [alert show];
}

@end
