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

+ (UIFont *)ym_standFontOfLevel:(NSInteger)level
{
    CGFloat size = 0;
    switch (level) {
        case 1:
            if (kYm_iPhone6Plus) {
                size = 23;
            }
            else {
                size = 16;
            }
            break;
        case 2:
            if (kYm_iPhone6Plus) {
                size = 21;
            }
            else {
                size = 14;
            }
        case 3:
            if (kYm_iPhone6Plus) {
                size = 18;
            }
            else {
                size = 12;
            }
        case 4:
            if (kYm_iPhone6Plus) {
                size = 14;
            }
            else {
                size = 10;
            }
        default:
            break;
    }
    
    UIFont *font = [UIFont systemFontOfSize:size];

    return font;
}

@end