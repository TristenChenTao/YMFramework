//
//  UIFont+YMFontSizeAdditions.m
//  YMFramework
//
//  Created by Tristen on 10/28/15.
//  Copyright © 2015 cornapp. All rights reserved.
//

#import "UIFont+YMFontSizeAdditions.h"

#import "YMDeviceInfo.h"

@implementation UIFont (YMFontSizeAdditions)

+ (UIFont *)level1Font
{
    CGFloat size = 16;
    if (kYm_iPhone6Plus) {
        size = 23;
    }
    
    return [UIFont systemFontOfSize:size];
}

+ (UIFont *)level2Font
{
    CGFloat size = 14;
    if (kYm_iPhone6Plus) {
        size = 21;
    }
    
    return [UIFont systemFontOfSize:size];
}

+ (UIFont *)level3Font
{
    CGFloat size = 12;
    if (kYm_iPhone6Plus) {
        size = 18;
    }
    
    return [UIFont systemFontOfSize:size];
}

+ (UIFont *)level4Font
{
    CGFloat size = 10;
    if (kYm_iPhone6Plus) {
        size = 14;
    }
    
    return [UIFont systemFontOfSize:size];
}

@end