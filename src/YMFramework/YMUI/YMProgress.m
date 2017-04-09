//
//  YMProgress.m
//  YMFramework
//
//  Created by Tristen on 12/8/15.
//  Copyright © 2015 cornapp. All rights reserved.
//

#import "YMProgress.h"

#import "SVProgressHUD.h"
#import "YMUI.h"

#import "NSBundle+YMAdditions.h"

@implementation YMProgress

static UIImage *kFailTypeForNormal;
static UIImage *kFailTypeForNotReachable;
static UIImage *kFailTypeForLocation;

+ (void)load
{
    [super load];
    
    [SVProgressHUD setBackgroundColor: [UIColor colorWithRed:0.04 green:0.55 blue:0.94 alpha:1.00]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setRingThickness:5];

    
    [SVProgressHUD setMinimumSize:CGSizeMake(kYm_ScreenWidth * 0.456, kYm_ScreenHeight * 0.215)];
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    
    [SVProgressHUD setFont:[UIFont systemFontOfSize:18]];
    
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    
    kFailTypeForNormal = [UIImage imageWithContentsOfFile:[bundle ym_pathForResource:@"error@3x"
                                                                              ofType:@"png"
                                                                         inDirectory:@"/Progress"]];
    
    kFailTypeForNotReachable = [UIImage imageWithContentsOfFile:[bundle ym_pathForResource:@"failTypeForNotReachable@3x"
                                                                                    ofType:@"png"
                                                                               inDirectory:@"/Progress"]];
    
    kFailTypeForLocation = [UIImage imageWithContentsOfFile:[bundle ym_pathForResource:@"failTypeForLocation@3x"
                                                                                ofType:@"png"
                                                                           inDirectory:@"/Progress"]];
}

+ (void)showWithStatus:(NSString *)status
{
    [SVProgressHUD showWithStatus:status];
}

+ (void)dismiss
{
    [SVProgressHUD dismiss];
}

+ (void)showSuccessStatus:(NSString *)text
{
    [SVProgressHUD showSuccessWithStatus:text];
}

+ (void)showFailStatus:(NSString *)text
{
    [YMProgress showFailStatus:text
                  withFailType:YMProgrssFailTypeForNormal];
}

+ (void)showFailStatus:(NSString *)text
          withFailType:(YMProgrssFailType)failType
{
    switch (failType) {
        case YMProgrssFailTypeForNormal:
            [SVProgressHUD setErrorImage:kFailTypeForNormal];
            break;
        case YMProgrssFailTypeForNotReachable:
            [SVProgressHUD setErrorImage:kFailTypeForNotReachable];
            break;
        case YMProgrssFailTypeForLocation:
            [SVProgressHUD setErrorImage:kFailTypeForLocation];
            break;
        default:
            [SVProgressHUD setErrorImage:kFailTypeForNormal];
            break;
    }
    
    [SVProgressHUD showErrorWithStatus:text];
}

+ (void)showInfoWithStatus:(NSString *)text
{
    [SVProgressHUD showInfoWithStatus:text];
}

@end
