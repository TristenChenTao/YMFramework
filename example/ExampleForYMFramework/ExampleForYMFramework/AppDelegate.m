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
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[TestThreePlatformViewController alloc] init];
//    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}


- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *,id> *)options
{
    return [YMThirdPlatformTool handleURL:url];
}


@end
