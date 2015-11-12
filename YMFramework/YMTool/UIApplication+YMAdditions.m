//
//  UIApplication+YMAdditions.m
//  YMFramework
//
//  Created by Tristen on 11/12/15.
//  Copyright © 2015 cornapp. All rights reserved.
//

#import "UIApplication+YMAdditions.h"

@implementation UIApplication (YMAdditions)

- (UIImage *)ym_LaunchImage
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    NSString *orientation = nil;
    if (deviceOrientation == UIDeviceOrientationUnknown || deviceOrientation == UIDeviceOrientationPortrait || deviceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        orientation = @"Portrait";
    }
    else if(deviceOrientation == UIDeviceOrientationLandscapeLeft || deviceOrientation == UIDeviceOrientationLandscapeRight) {
        orientation = @"Landscape";
    }
    
    UIImage *launchImage = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        CGSize viewSize = [UIApplication sharedApplication].keyWindow.bounds.size;
        if (CGSizeEqualToSize(imageSize, viewSize) && [orientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            NSString *imageName = dict[@"UILaunchImageName"];
            launchImage = [UIImage imageNamed:imageName];
        }
    }
    
    return launchImage;
}

@end
