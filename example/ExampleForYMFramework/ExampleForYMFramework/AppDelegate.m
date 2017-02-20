//
//  AppDelegate.m
//  ExampleForYMFramework
//
//  Created by Tristen on 11/24/15.
//  Copyright © 2015 yumi. All rights reserved.
//

#import <YMFramework/YMFramework.h>

#import <Bugtags/Bugtags.h>

#import "AppDelegate.h"
#import "ViewController.h"
#import "TestThreePlatformViewController.h"
#import "YMConfig.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef DEBUG
    BOOL isDebug = YES;
#else
    BOOL isDebug = NO;
#endif
    
    [[YMFrameworkConfig sharedInstance] setupProductByID:kProductID
                                                 version:kProductVersion];
    //社交平台设置
    [YMThirdPlatformTool setupWeChatByAppId:kWechatAppID
                                  appSecret:kWechatAppSecret];
    
    [YMThirdPlatformTool setupQQByAppId:kQQAppID
                                 appKey:kQQAppKey];
    
    [YMThirdPlatformTool setupSinaWeiboByAppKey:kSinaWeiboAppKey
                                      appSecret:kSinaWeiboAppSecret
                                    redirectUri:kSinaWeiboAppRedirectURL];
    //统计设置
    [YMAnalytics setUMengAppKey:kUMengAppKey];
    
    
    //消息推送设置
    [YMPush setupWithOption:launchOptions
                     appKey:kPushAppKey
           apsForProduction:!isDebug];
    
    //开启支持Webp图片格式
    [YMURLProtocol registerProtocol];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];

    ViewController *vc1 = [[ViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    nav1.tabBarItem.title = @"基础框架";
    nav1.navigationBarHidden = YES;
    [tabBarController addChildViewController:nav1];
    
    
    TestThreePlatformViewController *vc2 = [[TestThreePlatformViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    nav2.tabBarItem.title = @"社交平台";
    nav2.navigationBarHidden = YES;
    [tabBarController addChildViewController:nav2];
    

    self.window.rootViewController = tabBarController;
    
    [self.window makeKeyAndVisible];
    
    [Bugtags startWithAppKey:@"d52480aa42ebf840bb397342bb5e3808"
             invocationEvent:BTGInvocationEventShake];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(nonnull NSURL *)url
  sourceApplication:(nullable NSString *)sourceApplication
         annotation:(nonnull id)annotation
{
    return [YMThirdPlatformTool handleURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(nonnull NSURL *)url
            options:(nonnull NSDictionary<NSString *,id> *)options
{
    return [YMThirdPlatformTool handleURL:url];
}

@end
