//
//  YMFrameworkConfig.h
//  YMFramework
//
//  Created by 涛 陈 on 6/4/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMFrameworkConfig : NSObject

@property (readonly, nonatomic, copy) NSString *productID;
@property (readonly, nonatomic, copy) NSString *productVersion;
@property (readonly, nonatomic, copy) NSString *productChannel;
@property (readonly, nonatomic, copy) NSString *appstoreID;

@property (readonly, nonatomic, copy) NSString *umengAppKey;
@property (readonly, nonatomic, copy) NSString *analyticsChannelID;

@property (readonly, nonatomic, copy) NSString *mobAppKey;

@property (readonly, nonatomic, copy) NSString *weiboAppKey;
@property (readonly, nonatomic, copy) NSString *weiboAppSecret;
@property (readonly, nonatomic, copy) NSString *weiboRedirectURL;

@property (readonly, nonatomic, copy) NSString *qqAppID;
@property (readonly, nonatomic, copy) NSString *qqAppKey;

@property (readonly, nonatomic, copy) NSString *wechatAppID;
@property (readonly, nonatomic, copy) NSString *wechatAppSecret;


+ (instancetype)sharedInstance;

@end
