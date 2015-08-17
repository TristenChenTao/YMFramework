//
//  YMFrameworkConfig.m
//  YMFramework
//
//  Created by 涛 陈 on 6/4/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YMFrameworkConfig.h"
#import "YMTool.h"
#import "NSString+YMAdditions.h"

#import "YMPush.h"
#import "YMAnalytics.h"
#import "YMThirdPlatformTool.h"
#import "YMURLProtocol.h"

@implementation YMFrameworkConfig

+ (instancetype)sharedInstance
{
    YM_DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[self alloc] init];
    })
}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"YMFrameworkConfig" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    if (data == nil) {
        YMLog(@"YMFrameworkConfig.plsi is nil");
        return nil;
    }
    
    _productID = data[@"PRODUCT_ID"];
    if ([NSString ym_isEmptyString:_productID]) {
        YMLog(@"_productID is nil");
        _productID = @"";
    }
    
    _productVersion = data[@"PRODUCT_VERSION"];
    if ([NSString ym_isEmptyString:_productVersion]) {
        YMLog(@"_productVersion is nil");
        _productVersion = @"";
    }
    
    _productChannel = data[@"PRODUCT_CHANNEL"];
    if ([NSString ym_isEmptyString:_productChannel]) {
        YMLog(@"_productChannel is nil");
        _productChannel = @"";
    }
    
    _appstoreID = data[@"APPSTORE_ID"];
    if ([NSString ym_isEmptyString:_appstoreID]) {
        YMLog(@"_appstoreID is nil");
        _appstoreID = @"";
    }
    
    _umengAppKey = data[@"UMENG_AppKey"];
    if ([NSString ym_isEmptyString:_umengAppKey]) {
        YMLog(@"_umengAppKey is nil");
        _umengAppKey = @"";
    }
    
    _analyticsChannelID = data[@"Analytics_ChannelID"];
    if ([NSString ym_isEmptyString:_analyticsChannelID]) {
        YMLog(@"_analyticsChannelID is nil");
        _analyticsChannelID = @"";
    }
    
    _mobAppKey = data[@"MOB_AppKey"];
    if ([NSString ym_isEmptyString:_mobAppKey]) {
        YMLog(@"_mobAppKey is nil");
        _mobAppKey = @"";
    }
    
    _weiboAppKey = data[@"WeiBo_AppKey"];
    if ([NSString ym_isEmptyString:_weiboAppKey]) {
        YMLog(@"_weiboAppKey is nil");
        _weiboAppKey = @"";
    }
    
    _weiboAppSecret = data[@"WeiBo_AppSecret"];
    if ([NSString ym_isEmptyString:_weiboAppSecret]) {
        YMLog(@"_weiboAppSecret is nil");
        _weiboAppSecret = @"";
    }
    
    _weiboRedirectURL = data[@"WeiBo_RedirectUrl"];
    if ([NSString ym_isEmptyString:_weiboRedirectURL]) {
        YMLog(@"_weiboRedirectURL is nil");
        _weiboRedirectURL = @"";
    }
    
    _qqAppKey = data[@"QQ_AppKey"];
    if ([NSString ym_isEmptyString:_qqAppKey]) {
        YMLog(@"_qqAppKey is nil");
        _qqAppKey = @"";
    }
    
    _qqAppID = data[@"QQ_AppID"];
    if ([NSString ym_isEmptyString:_qqAppID]) {
        YMLog(@"_qqAppSecret is nil");
        _qqAppID = @"";
    }
    
    _wechatAppID = data[@"WeChat_AppID"];
    if ([NSString ym_isEmptyString:_wechatAppID]) {
        YMLog(@"_wechatAppID is nil");
        _wechatAppID = @"";
    }
    
    _wechatAppSecret = data[@"WeChat_AppSecret"];
    if ([NSString ym_isEmptyString:_wechatAppSecret]) {
        YMLog(@"_wechatAppSecret is nil");
        _wechatAppSecret = @"";
    }
    
    return self;
}

//需要使用Aspects待定

//+ (void)load
//{
//		[super load];
//
//		Class appDelegate = NSClassFromString(@"AppDelegate");
//
//		[appDelegate aspect_hookSelector:@selector(application:didFinishLaunchingWithOptions:)
//																							 withOptions:AspectPositionBefore
//																								usingBlock:^(id<AspectInfo> info) {
//
//																										NSArray *args = [info arguments];
//																										NSDictionary *launchOptions = nil;
//																										if ([args[1] isKindOfClass:[NSDictionary class]]) {
//																												launchOptions = args[1];
//																										}
//																										[YMPush setupWithOption:launchOptions];
//
//																										[YMAnalytics start];
//																										[YMThirdPlatformTool registerInfo];
//																										[YMURLProtocol registerProtocol];
//																								}
//																										error:NULL];
//
//		[appDelegate aspect_hookSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)
//												 withOptions:AspectPositionBefore
//													usingBlock:^(id<AspectInfo> info) {
//															NSArray *args = [info arguments];
//															NSData *deviceToken = args[1];
//															[YMPush registerDeviceToken:deviceToken];
//
//															dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC));
//															dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
//																						 {
//																								 YMLog(@"APService registrationID is %@",[YMPush registrationID]);
//																						 });
//													}
//															 error:NULL];
//
//
//		[appDelegate aspect_hookSelector:@selector(application:didReceiveRemoteNotification:)
//												 withOptions:AspectPositionBefore
//													usingBlock:^(id<AspectInfo> info) {
//															NSArray *args = [info arguments];
//															NSDictionary *userInfo = args[1];
//															[YMPush handleRemoteNotification:userInfo];
//													}
//															 error:NULL];
//
//
//		[appDelegate aspect_hookSelector:@selector(application:handleOpenURL:)
//												 withOptions:AspectPositionInstead
//													usingBlock:^(id<AspectInfo> info) {
//
//																NSArray *args = [info arguments];
//															  NSInvocation *invocation = info.originalInvocation;
//																BOOL returnValue = [YMThirdPlatformTool handleOpenURL:args[1]
//																																					 wxDelegate:[info instance]];
//																[invocation setReturnValue:&returnValue];
//													}
//															 error:NULL];
//
//		[appDelegate aspect_hookSelector:@selector(application:openURL:sourceApplication:annotation:)
//												 withOptions:AspectPositionInstead
//													usingBlock:^(id<AspectInfo> info) {
//																NSArray *args = [info arguments];
//																NSInvocation *invocation = info.originalInvocation;
//																BOOL returnValue = [YMThirdPlatformTool handleOpenURL:args[1]
//																																		sourceApplication:args[2]
//																																					 annotation:args[3]
//																																					 wxDelegate:[info instance]];
//															[invocation setReturnValue:&returnValue];
//													}
//															 error:NULL];
//}

@end
