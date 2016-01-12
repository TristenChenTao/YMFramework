//
//  YMAnalytics.h
//  YMFramework
//
//  Created by 涛 陈 on 4/21/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMAnalytics : NSObject

/**
 *  开始统计
 */
+ (void)startReport;

/**
 *  设置友盟信息
 *  @param appKey    AppKey
 *  @param channelID 渠道ID
 */
+ (void)setUMengAppKey:(NSString *)appKey
             channelID:(NSString *)channelID;

/**
 *  设置开发模式（默认是不开启）
 *
 *  @param debugMode
 */
+ (void)setDebugMode:(BOOL)debugMode;

/**
 *  统计事件ID
 *
 *  @param eventId 事件ID
 */
+ (void)event:(NSString *)eventId;

@end
