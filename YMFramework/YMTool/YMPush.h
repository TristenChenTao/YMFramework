//
//  YMPush.h
//  YMFramework
//
//  Created by 涛 陈 on 5/14/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMPush : NSObject

/**
 *  初始化
 */
+ (void)setupWithOption:(NSDictionary *)launchingOption;

/**
 *  注册APNS类型
 */
+ (void)registerForRemoteNotificationTypes:(NSUInteger)types
                                categories:(NSSet *)categories;

/**
 *  向服务器上报Device Token
 */
+ (void)registerDeviceToken:(NSData *)deviceToken;

/**
 *  获取注册ID,用于测试使用(需要在registerDeviceToken方法调用之后等几秒再调用,才会获取到注册ID)
 */
+ (NSString *)registrationID;

/**
 *  处理收到的APNS消息，向服务器上报收到APNS消息
 */
+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo;

@end
