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

@interface YMFrameworkConfig()

@property (readwrite, nonatomic, copy) NSString *productID;
@property (readwrite, nonatomic, copy) NSString *productVersion;
@property (readwrite, nonatomic, copy) NSString *productChannel;

@end

@implementation YMFrameworkConfig

+ (instancetype)sharedInstance
{
    YM_DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[self alloc] init];
    })
}

- (void)setupProductByID:(NSString *)ID
                 version:(NSString *)version
                 channel:(NSString *)channel
{
    self.productID = ID;
    self.productVersion = version;
    self.productChannel = channel;
}

- (void)setProductID:(NSString *)productID
{
    if ([NSString ym_isContainString:productID]) {
        _productID = productID;
    }
    else {
        _productID = @"";
    }
}

- (void)setProductVersion:(NSString *)productVersion
{
    if ([NSString ym_isContainString:productVersion]) {
        _productVersion = productVersion;
    }
    else {
        _productVersion = @"";
    }
}

- (void)setProductChannel:(NSString *)productChannel
{
    if ([NSString ym_isContainString:productChannel]) {
        _productChannel = productChannel;
    }
    else {
        _productChannel = @"";
    }
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
