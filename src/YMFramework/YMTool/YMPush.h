//
//  YMPush.h
//  YMFramework
//
//  Created by 涛 陈 on 5/14/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMPush : NSObject

/*
 * 推送启动配置
 *
 * @param launchingOption 启动参数.
 * @param appKey
 * @param channel 发布渠道
 * @param isProduction 是否生产环境. 如果为开发状态,设置为 NO; 如果为生产状态,应改为 YES.
 * 此接口必须在 App 启动时调用
 */

+ (void)setupWithOption:(NSDictionary *)launchingOption
                 appKey:(NSString *)appKey
       apsForProduction:(BOOL)isProduction;

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


/**
 *  设置别名，用于精确推送
 */
+ (void)setAlias:(NSString *)alias
callbackSelector:(SEL)cbSelector
          object:(id)theTarget;

/**
 *  设置标签，用于精确推送
 */
+ (void)setTags:(NSSet *)tags
callbackSelector:(SEL)cbSelector
         object:(id)theTarget;

@end
