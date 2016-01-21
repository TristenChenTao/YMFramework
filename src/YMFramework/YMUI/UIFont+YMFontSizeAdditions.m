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
            if(kYm_iPhone6Plus_standard) {
                size = 20;
            }
            else if (kYm_iPhone6Plus_zoomed) {
                size = 20;
            }
            else if(kYm_iPhone6_standard) {
                size = 18;
            }
            else {
                size = 18;
            }
            break;
        case 2:
            if(kYm_iPhone6Plus_standard) {
                size = 18;
            }
            else if (kYm_iPhone6Plus_zoomed) {
                size = 18;
            }
            else if(kYm_iPhone6_standard) {
                size = 16;
            }
            else {
                size = 16;
            }
            break;
        case 3:
            if(kYm_iPhone6Plus_standard) {
                size = 15.3;
            }
            else if (kYm_iPhone6Plus_zoomed) {
                size = 15.3;
            }
            else if(kYm_iPhone6_standard) {
                size = 14;
            }
            else {
                size = 14;
            }
            break;
        case 4:
            if(kYm_iPhone6Plus_standard) {
                size = 13.3;
            }
            else if (kYm_iPhone6Plus_zoomed) {
                size = 13.3;
            }
            else if(kYm_iPhone6_standard) {
                size = 12;
            }
            else {
                size = 12;
            }
            break;
        case 5:
            if(kYm_iPhone6Plus_standard) {
                size = 11;
            }
            else if (kYm_iPhone6Plus_zoomed) {
                size = 11;
            }
            else if(kYm_iPhone6_standard) {
                size = 10;
            }
            else {
                size = 10;
            }
            break;
        case 6:
            if(kYm_iPhone6Plus_standard) {
                size = 11;
            }
            else if (kYm_iPhone6Plus_zoomed) {
                size = 11;
            }
            else if(kYm_iPhone6_standard) {
                size = 10;
            }
            else {
                size = 10;
            }
            break;
        default:
            size = 10;
            break;
    }
    
    UIFont *font = [UIFont systemFontOfSize:size];
    
    return font;
}

@end