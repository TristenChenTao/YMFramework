//
//  QDThirdPlatformTool.m
//  TestThreePlatform2
//
//  Created by yumi_iOS on 12/11/15.
//  Copyright © 2015 yumi_iOS. All rights reserved.
//

#import "YMThirdPlatformTool.h"
#import "YMThirdPlatformSDKCenter.h"
#import "YMThirdPlatformUserInfo.h"
#import "YMThirdPlatformShareEntity.h"
#import "YMTool.h"
#import "NSString+YMAdditions.h"

@implementation YMThirdPlatformTool

static NSString *kWechatAppID = nil;
static NSString *kWechatAppSecret;

static NSString *kQQAppID = nil;
static NSString *kQQAppKey = nil;

static NSString *kSinaWeiboAppKey = nil;
static NSString *kSinaWeiboAppSecret = nil;
static NSString *kSinaWeiboAppRedirectURL = nil;

+ (void)setupWeChatByAppId:(NSString *)appId
                 appSecret:(NSString *)appSecret
{
    kWechatAppID = appId;
    kWechatAppSecret = appSecret;
    
    [[YMThirdPlatformSDKCenter sharedInstance] registerWXAppId:kWechatAppID WXAppSecret:kWechatAppSecret];
    
}

+ (void)setupQQByAppId:(NSString *)appId
                appKey:(NSString *)appKey
{
    kQQAppID = appId;
    kQQAppKey = appKey;
    
    [[YMThirdPlatformSDKCenter sharedInstance] registerQQAppId:kQQAppID];
}

+ (void)setupSinaWeiboByAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret
                   redirectUri:(NSString *)redirectUri
{
    kSinaWeiboAppKey = appKey;
    kSinaWeiboAppSecret = appSecret;
    kSinaWeiboAppRedirectURL = redirectUri;
    
    [[YMThirdPlatformSDKCenter sharedInstance] registerWBAppKey:kSinaWeiboAppKey
                                   appScret:kSinaWeiboAppSecret
                                redirectURL:kSinaWeiboAppRedirectURL];
}

+ (void)loginForPlatformType:(YMThirdPlatformType)platformType
                     success:(void (^)(YMThirdPlatformUserInfo *platformUserInfo))success
                     failure:(void (^)(NSError *))failure
                      cancel:(void (^)(void))cancel
{
    [[YMThirdPlatformSDKCenter sharedInstance] loginWithThirdPlatformType:platformType
                                              success:^(YMThirdPlatformUserInfo *userInfo) {
                                                  success(userInfo);
                                              } failure:^(NSError *error) {
                                                  failure(error);
                                              } cancel:^{
                                                  cancel();
                                              }];
}

+ (void)logoutForPlatformType:(YMThirdPlatformType)platformType
{
    [[YMThirdPlatformSDKCenter sharedInstance] logoutWithThirdPlatformType:platformType];
}

+ (void)shareWithEntity:(YMThirdPlatformShareEntity *)shareEntity
                success:(void (^)(YMThirdPlatformShareEntity *shareEntity))success
                failure:(void (^)(YMThirdPlatformShareEntity *shareEntity, NSError *error))failure
                 cancel:(void (^)(YMThirdPlatformShareEntity *))cancel
{
    [[YMThirdPlatformSDKCenter sharedInstance] shareWithEntity:shareEntity
                                   success:^(YMThirdPlatformShareEntity *entity){
                                       success(shareEntity);
                                   } failure:^(YMThirdPlatformShareEntity *entiy, NSError *error) {
                                       failure(entiy ,error);
                                   } cancel:^(YMThirdPlatformShareEntity *entity){
                                       cancel(entity);
                                   }];
}

+ (BOOL)isThirdPlatformAppInstalled:(YMThirdPlatformType)platformType
{
    return [YMThirdPlatformSDKCenter isAPPInstalledForThirdPlatformType:platformType];
}

+ (BOOL)handleURL:(NSURL *)url
{
    return [YMThirdPlatformSDKCenter handleURL:url];
}

@end
