//
//  YMPush.m
//  YMFramework
//
//  Created by 涛 陈 on 5/14/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YMPush.h"
#import "JPUSHService.h"

@implementation YMPush

+ (void)setupWithOption:(NSDictionary *)launchingOption
                 appKey:(NSString *)appKey
                channel:(NSString *)channel
       apsForProduction:(BOOL)isProduction
{
    [JPUSHService setupWithOption:launchingOption
                           appKey:appKey
                          channel:channel
                 apsForProduction:isProduction];
    
    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                      UIRemoteNotificationTypeSound |
                                                      UIRemoteNotificationTypeAlert)
                                          categories:nil];
    if (isProduction) {
        [JPUSHService setLogOFF];
    }
    else {
        [JPUSHService setDebugMode];
    }
}

+ (void)registerForRemoteNotificationTypes:(NSUInteger)types
                                categories:(NSSet *)categories
{
    [JPUSHService registerForRemoteNotificationTypes:types
                                       categories:categories];
}

+ (void)registerDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo
{
    [JPUSHService handleRemoteNotification:remoteInfo];
}

+ (NSString *)registrationID
{
    return [JPUSHService registrationID];
}

+ (void)setAlias:(NSString *)alias
callbackSelector:(SEL)cbSelector
          object:(id)theTarget;
{
    [JPUSHService setAlias:alias
       callbackSelector:cbSelector
                 object:theTarget];
}

+ (void)setTags:(NSSet *)tags
callbackSelector:(SEL)cbSelector
         object:(id)theTarget
{
    [JPUSHService setTags:tags
      callbackSelector:cbSelector
                object:theTarget];
}

@end