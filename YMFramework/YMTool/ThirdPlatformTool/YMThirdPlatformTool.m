//
//  AccountTool.m
//  YuMiAssistant
//
//  Created by Tristen-MacBook on 8/15/14.
//
//

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#import "WXApi.h"
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
    
    [ShareSDK registerApp:config.mobAppKey];
    
    //微信应用
    if ([NSString ym_isContainString:config.wechatAppID] && [NSString ym_isContainString:config.wechatAppSecret]) {
        [ShareSDK connectWeChatWithAppId:config.wechatAppID
                               appSecret:config.wechatAppSecret
                               wechatCls:[WXApi class]];
    }
    
    //QQ空间应用
    if ([NSString ym_isContainString:config.qqAppKey] && [NSString ym_isContainString:config.qqAppSecret]) {
        [ShareSDK connectQZoneWithAppKey:config.qqAppKey
                               appSecret:config.qqAppSecret
                       qqApiInterfaceCls:[QQApiInterface class]
                         tencentOAuthCls:[TencentOAuth class]];
        
        [ShareSDK connectQQWithQZoneAppKey:config.qqAppKey
                         qqApiInterfaceCls:[QQApiInterface class]
                           tencentOAuthCls:[TencentOAuth class]];
        
        [ShareSDK importQQClass:[QQApiInterface class]
                tencentOAuthCls:[TencentOAuth class]];
    }
    
    //新浪微博
    if ([NSString ym_isContainString:config.weiboAppKey]
        && [NSString ym_isContainString:config.weiboAppSecret]
        && [NSString ym_isContainString:config.weiboRedirectURL]) {
        [ShareSDK  connectSinaWeiboWithAppKey:config.weiboAppKey
                                    appSecret:config.weiboAppSecret
                                  redirectUri:config.weiboRedirectURL
                                  weiboSDKCls:[WeiboSDK class]];
    }
}

+ (ShareType)shareTypeFromPlatformType:(YMThirdPlatformType)platformType;
{
    ShareType type = 0;
    switch (platformType) {
        case YMThirdPlatformForWeibo:
            type = ShareTypeSinaWeibo;
            break;
        case YMThirdPlatformForQQ:
            type = ShareTypeQQSpace;
            break;
        case YMThirdPlatformForWechat:
            type = ShareTypeWeixiSession;
            break;
        default:
            type = ShareTypeAny;
            break;
    }
    
    return type;
}

+ (YMThirdPlatformType)platformTypeFromShareType:(ShareType)shareType
{
    YMThirdPlatformType type = 0;
    switch (shareType) {
        case ShareTypeSinaWeibo:
            type = YMThirdPlatformForWeibo;
            break;
        case ShareTypeQQSpace:
            type = YMThirdPlatformForQQ;
            break;
        case ShareTypeWeixiSession:
            type = YMThirdPlatformForWechat;
            break;
        default:
            type = YMThirdPlatformForWeibo;
            break;
    }
    
    return type;
}

+ (ShareType)shareTypeFromPlatformShareType:(YMThirdPlatformShareType)platformShareType
{
    ShareType type = 0;
    switch (platformShareType) {
        case YMThirdPlatformShareForWeibo:
            type = ShareTypeSinaWeibo;
            break;
        case YMThirdPlatformShareForQQSpace:
            type = ShareTypeQQSpace;
            break;
        case YMThirdPlatformShareForWechatTimeline:
            type = ShareTypeWeixiTimeline;
            break;
        case YMThirdPlatformShareForWechatSession:
            type =ShareTypeWeixiSession;
            break;
        case YMThirdPlatformShareForQQFriend:
            type = ShareTypeQQ;
            break;
        default:
            type = ShareTypeAny;
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
    if (![WeiboSDK isWeiboAppInstalled]
        && platformType == YMThirdPlatformForWeibo) {
        if (failure) {
            failure(@"未安装该应用，请先下载微博！");
        }
        
        return;
    }
    
    ShareType type = [YMThirdPlatformTool shareTypeFromPlatformType:platformType];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    [ShareSDK getUserInfoWithType:type
                      authOptions:authOptions
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               if (result) {
                                   YMThirdPlatformUserInfo *platformUserInfo = [[YMThirdPlatformUserInfo alloc] init];
                                   platformUserInfo.userId = userInfo.uid;
                                   
                                   platformUserInfo.nickname = userInfo.nickname;
                                   platformUserInfo.profileImageUrl = userInfo.profileImage;
                                   platformUserInfo.accessToken = userInfo.credential.token;
                                   platformUserInfo.expired = userInfo.credential.expired;
                                   platformUserInfo.homepage = userInfo.url;
                                   platformUserInfo.platformType = platformType;
                                   
                                   if (success) {
                                       success(platformUserInfo);
                                   }
                               }
                               else {
                                   NSString *message = nil;
                                   
                                   if (error.errorCode == -22003) {
                                       message = @"未安装该应用，请先下载微信！";
                                   }
                                   else if (error.errorCode == -6004) {
                                       message = @"未安装该应用，请先下载QQ！";
                                   }
                                   else if (error.errorCode == 10014) {
                                       message = @"未安装该应用，请先下载微博！";
                                   }
                                   else {
                                       message = @"登录失败";
                                   }
                                   
                                   if (failure) {
                                       failure(message);
                                   }
                               }
                           }];
}

+ (void)logoutForPlatformType:(YMThirdPlatformType)platformType
{
    [ShareSDK cancelAuthWithType:[YMThirdPlatformTool shareTypeFromPlatformType:platformType]];
}

+ (BOOL)hasLoginForPlatformType:(YMThirdPlatformType)platformType
{
    return [ShareSDK hasAuthorizedWithType:[YMThirdPlatformTool shareTypeFromPlatformType:platformType]];
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
    
    [ShareSDK clientShareContent:[self publishContentFromShareEntity:shareEntity]//内容对象
                            type:[self shareTypeFromPlatformShareType:shareEntity.shareType]//平台类型
                   statusBarTips:YES
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
         if (state == SSPublishContentStateSuccess) {
             if(success) {
                 success(shareEntity);
             }
         }
         else if (state == SSPublishContentStateFail) {
             NSString *errorMessage = nil;
             if (error.errorCode == -22003) {
                 errorMessage = @"未安装该应用，请先下载微信！";
             }
             else if(error.errorCode == -6004) {
                 errorMessage = @"未安装该应用，请先下载QQ！";
             }
             else if(error.errorCode == 10014) {
                 errorMessage = @"未安装该应用，请先下载微博！";
             }
             else {
                 errorMessage = @"分享失败";
             }
             
             if (failure) {
                 failure(errorMessage);
             }
         }
         else if(state == SSPublishContentStateCancel) {
             if (cancel) {
                 cancel();
             }
         }
     }];
}

+ (id<ISSContent>)publishContentFromShareEntity:(YMThirdPlatformShareEntity *)shareEntity
{
    //构造分享内容
    id<ISSContent> publishContent = nil;
    
    SSPublishContentMediaType mediaType = [self meidaTypeFromShareEntity:shareEntity];
    
    
    NSString *imageURL = [NSString ym_trim:shareEntity.imageURL];
    NSString *title = [NSString ym_trim:shareEntity.title];
    NSString *resourceUrl = [NSString ym_trim:shareEntity.resourceURL];
    publishContent = [ShareSDK content:shareEntity.contentText
                        defaultContent:@""
                                 image:[ShareSDK imageWithUrl:imageURL]
                                 title:title
                                   url:resourceUrl
                           description:nil
                             mediaType:mediaType];
    
    if (mediaType == SSPublishContentMediaTypeGif) {
        
        NSData *imageData = [[SDImageCache sharedImageCache] diskImageDataBySearchingAllPathsForKey:shareEntity.imageURL];
								
        if (shareEntity.shareType == YMThirdPlatformShareForWechatTimeline) {
            [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
                                                  content:INHERIT_VALUE
                                                    title:INHERIT_VALUE
                                                      url:INHERIT_VALUE
                                                    image:INHERIT_VALUE
                                             musicFileUrl:nil
                                                  extInfo:nil
                                                 fileData:nil
                                             emoticonData:imageData];
        }
        else if(shareEntity.shareType == YMThirdPlatformShareForWechatSession) {
            [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                                 content:INHERIT_VALUE
                                                   title:INHERIT_VALUE
                                                     url:INHERIT_VALUE
                                                   image:INHERIT_VALUE
                                            musicFileUrl:nil
                                                 extInfo:nil
                                                fileData:nil
                                            emoticonData:imageData];
        }
    }
    
    return publishContent;
}

+ (SSPublishContentMediaType)meidaTypeFromShareEntity:(YMThirdPlatformShareEntity *)entity
{
    SSPublishContentMediaType type = SSPublishContentMediaTypeNews;
    switch (entity.contentType) {
        case YMThirdPlatformContentForApp: {
            if (entity.shareType == YMThirdPlatformShareForWechatTimeline
                || entity.shareType == YMThirdPlatformShareForWechatSession) {
                type = SSPublishContentMediaTypeApp;
            }
            else {
                type = SSPublishContentMediaTypeNews;
            }
            break;
        }
        case YMThirdPlatformContentForNews:
            type = SSPublishContentMediaTypeNews;
            break;
        case YMThirdPlatformContentForImage: {
            if (entity.shareType == YMThirdPlatformShareForWechatTimeline
                || entity.shareType == YMThirdPlatformShareForWechatSession) {
                
                if ([entity.imageURL rangeOfString:@".gif"].length > 0) {
                    type = SSPublishContentMediaTypeGif;
                }
                else {
                    type = SSPublishContentMediaTypeImage;
                }
            }
            else {
                type = SSPublishContentMediaTypeImage;
            }
            break;
        }
        default:
            type = SSPublishContentMediaTypeNews;
            break;
    }
    
    return type;
}

#pragma mark - 微信回调处理

+ (BOOL)handleOpenURL:(NSURL *)url
           wxDelegate:(id)wxDelegate
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:wxDelegate];
}

+ (BOOL)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation
           wxDelegate:(id)wxDelegate
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:wxDelegate];
}

@end
