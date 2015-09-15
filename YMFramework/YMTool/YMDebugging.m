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

YM_MacrosSingletonImplemantion

- (void)showExplorer
{
    [[FLEXManager sharedManager] showExplorer];
}

#pragma mark - getters and setters

- (void)setNetworkDebuggingEnabled:(BOOL)networkDebuggingEnabled
{
    [FLEXManager sharedManager].networkDebuggingEnabled = networkDebuggingEnabled;
}

- (BOOL)networkDebuggingEnabled
{
    return [FLEXManager sharedManager].networkDebuggingEnabled;
}

@end
