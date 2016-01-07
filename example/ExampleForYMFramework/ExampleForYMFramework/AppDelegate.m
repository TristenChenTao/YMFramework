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
    [YMAnalytics setDebugMode:YES];
    [YMAnalytics startReport];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[TestThreePlatformViewController alloc] init];
//    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [YMThirdPlatformTool handleURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [YMThirdPlatformTool handleURL:url];
}

@end
