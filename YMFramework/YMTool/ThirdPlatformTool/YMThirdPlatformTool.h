//
//  YMThirdPlatformTool.h
//  YMFramework
//
//  Created by Tristen-MacBook on 8/15/14.
//
//

#import <UIKit/UIKit.h>

@class YMThirdPlatformUserInfo;
@class YMThirdPlatformShareEntity;

typedef enum
{
    YMThirdPlatformForWeibo = 1,
    YMThirdPlatformForQQ = 2,
    YMThirdPlatformForWechat =  3,
}YMThirdPlatformType;

@interface YMThirdPlatformTool : NSObject

+ (void)setupWeChatByAppId:(NSString *)appId
                 appSecret:(NSString *)appSecret;

+ (void)setupQQByAppId:(NSString *)appId
                appKey:(NSString *)appKey;

+ (void)setupSinaWeiboByAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret
                   redirectUri:(NSString *)redirectUri;

+ (void)registerByAppKey:(NSString *)appKey;

//登录
+ (void)loginForPlatformType:(YMThirdPlatformType)platformType
                     success:(void (^)(YMThirdPlatformUserInfo *platformUserInfo))success
                     failure:(void (^)(NSString *errorDescription))failure;

//登出
+ (void)logoutForPlatformType:(YMThirdPlatformType)platformType;

//是否已经登录
+ (BOOL)hasLoginForPlatformType:(YMThirdPlatformType)platformType;

//分享
+ (void)shareWithEntity:(YMThirdPlatformShareEntity *)shareEntity
                success:(void (^)(YMThirdPlatformShareEntity *shareEntity))success
                failure:(void (^)(NSString *errorDescription))failure
                 cancel:(void (^)(void))cancel;

@end
