//
//  YMDebugging.m
//  YMFramework
//
//  Created by 涛 陈 on 5/29/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <Bugtags/Bugtags.h>
#import "FLEXManager.h"

#import "YMDebugging.h"

@implementation YMDebugging

+ (void)startDebugWithAppKey:(NSString *)appKey
{
    [Bugtags startWithAppKey:appKey
             invocationEvent:BTGInvocationEventNone];
}

+ (void)showExplorer
{
    [[FLEXManager sharedManager] showExplorer];
    
    [Bugtags setInvocationEvent:BTGInvocationEventBubble];
}

+ (void)setNetworkDebuggingEnabled:(BOOL)networkDebuggingEnabled
{
    [FLEXManager sharedManager].networkDebuggingEnabled = networkDebuggingEnabled;
}

@end
