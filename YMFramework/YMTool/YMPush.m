//
//  YMPush.m
//  YMFramework
//
//  Created by 涛 陈 on 5/14/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YMPush.h"
#import "APService.h"

@implementation YMPush

+ (void)setupWithOption:(NSDictionary *)launchingOption
{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PushConfig" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    if (data) {
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
        
        [APService setupWithOption:launchingOption];
        [APService setLogOFF];
    }
}

+ (void)registerForRemoteNotificationTypes:(NSUInteger)types
                                categories:(NSSet *)categories
{
    [APService registerForRemoteNotificationTypes:types
                                       categories:categories];
}

+ (void)registerDeviceToken:(NSData *)deviceToken
{
    [APService registerDeviceToken:deviceToken];
}

+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo
{
    [APService handleRemoteNotification:remoteInfo];
}

+ (NSString *)registrationID
{
    return [APService registrationID];
}

@end
