//
//  AccountTool.m
//  YuMiAssistant
//
//  Created by Tristen-MacBook on 8/15/14.
//
//

//ShareSDK必要头文件
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

#import "SDImageCache.h"

#import "YMThirdPlatformTool.h"
#import "YMThirdPlatformUserInfo.h"
#import "YMThirdPlatformShareEntity.h"
#import "YMTool.h"
#import "NSString+YMAdditions.h"
#import "YMHTTPRequestManager.h"
#import "YMFrameworkConfig.h"



@interface YMThirdPlatformTool()

@end

@implementation YMThirdPlatformTool

+ (void)registerInfo
{
    YMFrameworkConfig *config = [YMFrameworkConfig sharedInstance];
    
    if([NSString ym_isEmptyString:config.mobAppKey]) {
        return;
    }
    
    NSMutableArray *platforms = [NSMutableArray array];
    
    //微信
    if ([NSString ym_isContainString:config.wechatAppID] && [NSString ym_isContainString:config.wechatAppSecret]) {
        [platforms addObject:@(SSDKPlatformTypeWechat)];
    }
    
    //QQ
    if ([NSString ym_isContainString:config.qqAppKey] && [NSString ym_isContainString:config.qqAppID]) {
        [platforms addObject:@(SSDKPlatformTypeQQ)];
    }
    
    //新浪微博
    if ([NSString ym_isContainString:config.weiboAppKey]) {
        [platforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    }
    
    [ShareSDK registerApp:config.mobAppKey
          activePlatforms:platforms
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              switch (platformType) {
                  case SSDKPlatformTypeWechat: {
                      [appInfo SSDKSetupWeChatByAppId:config.wechatAppID
                                            appSecret:config.wechatAppSecret];
                      break;
                  }
                  case SSDKPlatformTypeQQ: {
                      [appInfo SSDKSetupQQByAppId:config.qqAppID
                                           appKey:config.qqAppKey
                                         authType:SSDKAuthTypeSSO];
                      break;
                  }
                  case SSDKPlatformTypeSinaWeibo: {
                      [appInfo SSDKSetupSinaWeiboByAppKey:config.weiboAppKey
                                                appSecret:config.weiboAppSecret
                                              redirectUri:config.weiboRedirectURL
                                                 authType:SSDKAuthTypeSSO];
                      break;
                  }
                  default:
                      break;
              }
          }];
}

+ (SSDKPlatformType)SSDKPlatformTypeFromPlatformType:(YMThirdPlatformType)platformType;
{
    SSDKPlatformType type = 0;
    switch (platformType) {
        case YMThirdPlatformForWeibo:
            type = SSDKPlatformTypeSinaWeibo;
            break;
        case YMThirdPlatformForQQ:
            type = SSDKPlatformTypeQQ;
            break;
        case YMThirdPlatformForWechat:
            type = SSDKPlatformTypeWechat;
            break;
        default:
            type = SSDKPlatformTypeAny;
            break;
    }
    
    return type;
}

+ (YMThirdPlatformType)platformTypeFromSSDKPlatformType:(SSDKPlatformType)shareType
{
    YMThirdPlatformType type = 0;
    switch (shareType) {
        case SSDKPlatformTypeSinaWeibo:
            type = YMThirdPlatformForWeibo;
            break;
        case SSDKPlatformTypeQQ:
            type = YMThirdPlatformForQQ;
            break;
        case SSDKPlatformTypeWechat:
            type = YMThirdPlatformForWechat;
            break;
        default:
            type = YMThirdPlatformForWeibo;
            break;
    }
    
    return type;
}

+ (SSDKPlatformType)SSDKPlatformTypeFromPlatformShareType:(YMThirdPlatformShareType)platformShareType
{
    SSDKPlatformType type = 0;
    switch (platformShareType) {
        case YMThirdPlatformShareForWeibo:
            type = SSDKPlatformTypeSinaWeibo;
            break;
        case YMThirdPlatformShareForQQSpace:
            type = SSDKPlatformSubTypeQZone;
            break;
        case YMThirdPlatformShareForWechatTimeline:
            type = SSDKPlatformSubTypeWechatTimeline;
            break;
        case YMThirdPlatformShareForWechatSession:
            type = SSDKPlatformSubTypeWechatSession;
            break;
        case YMThirdPlatformShareForQQFriend:
            type = SSDKPlatformSubTypeQQFriend;
            break;
        default:
            type = SSDKPlatformTypeAny;
            break;
    }
    
    return type;
}

#pragma mark - 登录

+ (void)loginForPlatformType:(YMThirdPlatformType)platformType
                     success:(void (^)(YMThirdPlatformUserInfo *platformUserInfo))success
                     failure:(void (^)(NSString *errorDescription))failure
{
    //特殊处理
    if (![WeiboSDK isWeiboAppInstalled] && platformType == YMThirdPlatformForWeibo) {
        if (failure) {
            failure(@"未安装该应用，请先下载微博！");
        }
        
        return;
    }
    
    SSDKPlatformType type = [YMThirdPlatformTool SSDKPlatformTypeFromPlatformType:platformType];
    
    [ShareSDK authorize:type
               settings:nil
         onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
             if (error) {
                 NSString *message = nil;
                 switch (error.code) {
                     case -22003:
                         message = @"未安装该应用，请先下载微信！";
                         break;
                     case -6004:
                         message = @"未安装该应用，请先下载QQ！";
                         break;
                     case 10014:
                         message = @"未安装该应用，请先下载微博！";
                         break;
                     default:
                         message = @"登录失败";
                         break;
                 }
                 
                 if (failure) {
                     failure(message);
                 }
             }
             else {
                 YMThirdPlatformUserInfo *platformUserInfo = [[YMThirdPlatformUserInfo alloc] init];
                 platformUserInfo.userId = user.uid;
                 platformUserInfo.nickname = user.nickname;
                 platformUserInfo.profileImageUrl = user.icon;
                 platformUserInfo.accessToken = user.credential.token;
                 platformUserInfo.expired = user.credential.expired;
                 platformUserInfo.homepage = user.url;
                 platformUserInfo.platformType = platformType;
                 
                 if (success) {
                     success(platformUserInfo);
                 }
             }
         }];
}

+ (void)logoutForPlatformType:(YMThirdPlatformType)platformType
{
    [ShareSDK cancelAuthorize:[YMThirdPlatformTool SSDKPlatformTypeFromPlatformType:platformType]];
}

+ (BOOL)hasLoginForPlatformType:(YMThirdPlatformType)platformType
{
    return [ShareSDK hasAuthorized:[YMThirdPlatformTool SSDKPlatformTypeFromPlatformType:platformType]];
}

#pragma mark - 分享

+ (void)shareWithEntity:(YMThirdPlatformShareEntity *)shareEntity
                success:(void (^)(YMThirdPlatformShareEntity *shareEntity))success
                failure:(void (^)(NSString *errorDescription))failure
                 cancel:(void (^)(void))cancel
{
    //特殊处理
    if (![WeiboSDK isWeiboAppInstalled]
        && shareEntity.shareType == YMThirdPlatformShareForWeibo) {
        if (failure) {
            failure(@"未安装该应用，请先下载微博！");
        }
        
        return;
    }
    
    [ShareSDK share:[self SSDKPlatformTypeFromPlatformShareType:shareEntity.shareType]
         parameters:[self publishContentFromShareEntity:shareEntity]
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         if (state == SSDKResponseStateSuccess) {
             if(success) {
                 success(shareEntity);
             }
         }
         else if (state == SSDKResponseStateFail) {
             NSString *errorMessage = nil;
             
             switch (error.code) {
                 case -22003:
                     errorMessage = @"未安装该应用，请先下载微信！";
                     break;
                 case -6004:
                     errorMessage = @"未安装该应用，请先下载QQ！";
                     break;
                 case 10014:
                     errorMessage = @"未安装该应用，请先下载微博！";
                     break;
                 default:
                     errorMessage = @"分享失败";
                     break;
             }
             if (failure) {
                 failure(errorMessage);
             }
         }
         else if(state == SSDKResponseStateCancel) {
             if (cancel) {
                 cancel();
             }
         }
     }];
}

+ (NSMutableDictionary *)publishContentFromShareEntity:(YMThirdPlatformShareEntity *)shareEntity
{
    //构造分享内容
    NSMutableDictionary *publishContent = [NSMutableDictionary dictionary];
    
    
    NSString *imageURL = [NSString ym_trim:shareEntity.imageURL];
    NSString *title = [NSString ym_trim:shareEntity.title];
    NSString *resourceUrl = [NSString ym_trim:shareEntity.resourceURL];
    
    [publishContent SSDKSetupShareParamsByText:shareEntity.contentText
                                        images:@[imageURL]
                                           url:[NSURL URLWithString:resourceUrl]
                                         title:title
                                          type:SSDKContentTypeAuto];
    
    return publishContent;
}

@end