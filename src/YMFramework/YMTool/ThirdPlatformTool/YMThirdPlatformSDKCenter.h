//
//  sdkCall.h
//  TestThreePlatformSDK
//
//  Created by yumi_iOS on 12/9/15.
//  Copyright © 2015 yumi_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YMThirdPlatformShareEntity.h"
#import "YMThirdPlatformUserInfo.h"

typedef void (^LoginSuccessBlock)(YMThirdPlatformUserInfo *userInfo);
typedef void (^LoginFailureBlock)(NSError **error);
typedef void (^LoginCancelBlock)(NSError **error);
typedef void (^ShareFailureBlock)(YMThirdPlatformShareEntity *entity,NSError **error);
typedef void (^ShareSuccessBlock)(YMThirdPlatformShareEntity *shareEntity);
typedef void (^ShareCancelBlock)(YMThirdPlatformShareEntity *shareEntity);

@interface YMThirdPlatformSDKCenter : NSObject

@property (nonatomic, assign) BOOL isLogin;

+ (instancetype)sharedInstance;

- (void)logoutWithThirdPlatformType:(YMThirdPlatformType)platformType;

- (void)loginWithThirdPlatformType:(YMThirdPlatformType)platformType
                           success:(LoginSuccessBlock)success failure:(LoginFailureBlock)failure
                            cancel:(LoginCancelBlock)cancel;

- (void)registerQQAppId:(NSString *)appId;

- (void)registerWXAppId:(NSString *)appId
            WXAppSecret:(NSString *)secret;

- (void)registerWBAppKey:(NSString *)appKey
                appScret:(NSString *)secret
             redirectURL:(NSString *)redirectURL;

- (void)shareWithEntity:(YMThirdPlatformShareEntity *)shareEntity
                success:(ShareSuccessBlock)success
                failure:(ShareFailureBlock)failure
                 cancel:(ShareCancelBlock)cancel;

+ (BOOL)isTheAPPInstalledWithThirdPlatformType:(YMThirdPlatformType)platformType;

+ (BOOL)handleURL:(NSURL *)url;

@end
