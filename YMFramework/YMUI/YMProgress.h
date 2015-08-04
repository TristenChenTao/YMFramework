//
//  YMProgress.h
//  WoChao
//
//  Created by 陈涛 on 14-2-22.
//  Copyright (c) 2014年 tandy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMProgress : NSObject

+ (void)showWithStatus:(NSString *)status;

+ (void)dismiss;

+ (void)showSuccessStatusWithText:(NSString *)text;

+ (void)showFailStatusWithText:(NSString *)text;

+ (void)showProgress:(float)progress;

@end
