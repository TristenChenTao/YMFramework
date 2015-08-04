//
//  UIColor+YMAdditions.h
//  YMFramework
//
//  Created by 涛 陈 on 4/13/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kYMColor(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define kColor(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

@interface UIColor (YMAdditions)

//只接受6位十六进制
+ (UIColor *)ym_colorWithHexString:(NSString *)hexString;

+ (UIColor *)ym_colorWithHexString:(NSString *)hexString
							 alpha:(CGFloat)alpha;

@end