//
//  YMAnalytics.h
//  YMFramework
//
//  Created by 涛 陈 on 4/21/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMAnalytics : NSObject

+ (void)startByUMengAppKey:(NSString *)appKey
                 channelID:(NSString *)channelID;

+ (void)setDebugMode:(BOOL)debugMode;

+ (void)startReport;

+ (void)event:(NSString *)eventId;

+ (NSString *)macString;
+ (NSString *)idfaString;
+ (NSString *)idfvString;

@end
