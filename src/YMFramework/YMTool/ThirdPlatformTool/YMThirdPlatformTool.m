//
//  QDThirdPlatformTool.m
//  TestThreePlatform2
//
//  Created by yumi_iOS on 12/11/15.
//  Copyright © 2015 yumi_iOS. All rights reserved.
//

#import "YMThirdPlatformTool.h"
#import "YMSDKCall.h"
#import "YMThirdPlatformUserInfo.h"
#import "YMThirdPlatformShareEntity.h"

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
    
    [[YMSDKCall singleton] registerWXAppId:kWechatAppID WXAppSecret:kWechatAppSecret];
    
}

+ (void)setupQQByAppId:(NSString *)appId
                appKey:(NSString *)appKey
{
    kQQAppID = appId;
    kQQAppKey = appKey;
    
    [[YMSDKCall singleton] registerQQAppId:kQQAppID];
}

+ (void)setupSinaWeiboByAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret
                   redirectUri:(NSString *)redirectUri
{
    kSinaWeiboAppKey = appKey;
    kSinaWeiboAppSecret = appSecret;
    kSinaWeiboAppRedirectURL = redirectUri;
    
    [[YMSDKCall singleton] registerWBAppKey:kSinaWeiboAppKey
                                   appScret:kSinaWeiboAppSecret
                                redirectURL:kSinaWeiboAppRedirectURL];
}

+ (void)loginForPlatformType:(YMThirdPlatformType)platformType
                     success:(void (^)(YMThirdPlatformUserInfo *platformUserInfo))success
                     failure:(void (^)(NSError *))failure
                      cancel:(void (^)(void))cancel
{
    switch (platformType) {
        case YMThirdPlatformForQQ:
        {
            [[YMSDKCall singleton] qqLoginWithSuccess:^(YMThirdPlatformUserInfo *userInfo) {
                success(userInfo);
            } failure:^(NSError *error) {
                failure(error);
            } cancel:^(NSError *error) {
                cancel();
            }];
        }
            break;
        case YMThirdPlatformForWechat:
        {
            [[YMSDKCall singleton] wxLoginWithSuccess:^(YMThirdPlatformUserInfo *userInfo) {
                success(userInfo);
            } failure:^(NSError *error) {
                failure(error);
            } cancel:^(NSError *error) {
                cancel();
            }];
        }
            break;
        case YMThirdPlatformForWeibo:
        {
            [[YMSDKCall singleton] wbLoginWithSuccess:^(YMThirdPlatformUserInfo *userInfo) {
                success(userInfo);
            } failure:^(NSError *error) {
               failure(error);
            } cancel:^(NSError *error) {
                cancel();
            }];
        }
        default:
            break;
    }
}

+ (void)logoutForPlatformType:(YMThirdPlatformType)platformType
{
    switch (platformType) {
        case YMThirdPlatformForQQ:
        {
            [[YMSDKCall singleton] qqLogout];
        }
            break;
        case YMThirdPlatformForWechat:
        {
            //未找到接口
        }
            break;
        case YMThirdPlatformForWeibo:
        {
            [[YMSDKCall singleton] wbLogout];
        }
        default:
            break;
    }
}

+ (void)shareWithEntity:(YMThirdPlatformShareEntity *)shareEntity
                success:(void (^)(YMThirdPlatformShareEntity *shareEntity))success
               failure:(void (^)(YMThirdPlatformShareEntity *entity, NSError *error))failure
                 cancel:(void (^)(YMThirdPlatformShareEntity *))cancel
{
    [[YMSDKCall singleton] shareWithEntity:shareEntity
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
    BOOL flag = NO;
    switch (platformType) {
        case YMThirdPlatformForQQ:
            flag = [YMSDKCall isQQInstall];
            break;
        case YMThirdPlatformForWechat:
            flag =  [YMSDKCall isWechatInstall];
            break;
        case YMThirdPlatformForWeibo:
            flag = [YMSDKCall isWbInstall];
        default:
            break;
    }
    
    return flag;
}

+ (BOOL)handleURL:(NSURL *)url
{
    return [YMSDKCall handleURL:url];
}



@end
