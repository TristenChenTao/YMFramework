//
//  QDThirdPlatformTool.h
//  TestThreePlatform2
//
//  Created by yumi_iOS on 12/11/15.
//  Copyright © 2015 yumi_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMThirdPlatformUserInfo;
@class YMThirdPlatformShareEntity;

typedef NS_ENUM(NSInteger, ErrorState)
{
    ErrorStateLoginNormalFailure = -1000,
    ErrorStateLoginNotNetWork,
    ErrorStateLoginAppNotInstall,
    ErrorStateGetUserInfoFailure,
    ErrorStateShareNormalFailure,
    ErrorStateShareAppNotRegister,
    ErrorStateSharePrameError,
    ErrorStateShareAppNotInstall,
    ErrorStateShareInterfaceNotSupport,
    ErrorStateShareSentFailure,
};

typedef NS_ENUM(NSUInteger, YMThirdPlatformType) {
    YMThirdPlatformForWeibo = 1,
    YMThirdPlatformForQQ = 2,
    YMThirdPlatformForWechat =  3,
};

@interface YMThirdPlatformTool : NSObject

+ (void)setupWeChatByAppId:(NSString *)appId
                 appSecret:(NSString *)appSecret;

+ (void)setupQQByAppId:(NSString *)appId
                appKey:(NSString *)appKey;

+ (void)setupSinaWeiboByAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret
                   redirectUri:(NSString *)redirectUri;

//登录
+ (void)loginForPlatformType:(YMThirdPlatformType)platformType
                     success:(void (^)(YMThirdPlatformUserInfo *platformUserInfo))success
                     failure:(void (^)(NSError *error))failure
                      cancel:(void (^)(void))cancel;
//登出
+ (void)logoutForPlatformType:(YMThirdPlatformType)platformType;

//分享
+ (void)shareWithEntity:(YMThirdPlatformShareEntity *)shareEntity
                success:(void (^)(YMThirdPlatformShareEntity *shareEntity))success
                failure:(void (^)(YMThirdPlatformShareEntity *shareEntity, NSError *error))failure
                 cancel:(void (^)(YMThirdPlatformShareEntity *shareEntity))cancel;

//判断第三方平台客户端是否安装
+ (BOOL)isThirdPlatformAppInstalled:(YMThirdPlatformType)platformType;

+ (BOOL)handleURL:(NSURL *)url;

@end
