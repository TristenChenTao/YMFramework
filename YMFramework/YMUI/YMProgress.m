//
//  YMProgress.m
//  WoChao
//
//  Created by llw on 14-2-22.
//  Copyright (c) 2014年 tandy. All rights reserved.
//

#import "SVProgressHUD.h"

#import "YMProgress.h"

@implementation YMProgress

+ (void)showWithStatus:(NSString *)status
{
    [SVProgressHUD setRingThickness:4];
    [SVProgressHUD showWithStatus:status];
}

+ (void)dismiss
{
    [SVProgressHUD dismiss];
}

+ (void)showSuccessStatusWithText:(NSString *)text
{
    [SVProgressHUD showSuccessWithStatus:text];
}

+ (void)showFailStatusWithText:(NSString *)text
{
    [SVProgressHUD showErrorWithStatus:text];
}

+ (void)showProgress:(float)progress
{
    [SVProgressHUD showProgress:progress];
}


@end
