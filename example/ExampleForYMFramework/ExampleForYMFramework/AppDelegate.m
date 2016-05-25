//
//  AppDelegate.m
//  ExampleForYMFramework
//
//  Created by Tristen on 11/24/15.
//  Copyright © 2015 yumi. All rights reserved.
//

#import <YMFramework/YMFramework.h>

#import "AppDelegate.h"
#import "ViewController.h"
#import "TestThreePlatformViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[YMFrameworkConfig sharedInstance] setupProductByID:@"5679842990210161107"
                                                 version:@"0"
                                                 channel:@"0"];
    [YMAnalytics setUMengAppKey:@""
                      channelID:@""];
#ifdef DEBUG
    [YMAnalytics setDebugMode:YES];
#endif
    [YMAnalytics startReport];

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