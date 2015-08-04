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

+ (void)registerInfo;

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
                success:(void (^)(YMThirdPlatformType platformType))success
                failure:(void (^)(NSString *errorDescription))failure
                 cancel:(void (^)(void))cancel;


//微信回调处理
+ (BOOL)handleOpenURL:(NSURL *)url
           wxDelegate:(id)wxDelegate;

+ (BOOL)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation
           wxDelegate:(id)wxDelegate;

@end
