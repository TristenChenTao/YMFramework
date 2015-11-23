//
//  UIColor+YMAdditions.m
//  YMFramework
//
//  Created by 涛 陈 on 4/13/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import "UIColor+YMAdditions.h"

@implementation UIColor (YMAdditions)

+ (UIColor *)ym_colorWithHexString:(NSString *)hexString
{
	return [self ym_colorWithHexString:hexString alpha:1];
}

+ (UIColor *)ym_colorWithHexString:(NSString *)hexString
							 alpha:(CGFloat)alpha
{
	NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
	
	CGFloat red   = [self colorComponentFrom: colorString start: 0 length: 2];
	CGFloat blue  = [self colorComponentFrom: colorString start: 4 length: 2];
	CGFloat green = [self colorComponentFrom: colorString start: 2 length: 2];

	return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string
						start:(NSUInteger)start
					   length: (NSUInteger)length
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    
    return hexComponent / 255.0;
}

@end
