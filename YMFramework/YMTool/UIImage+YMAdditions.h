//
//  UIImage+YMAdditions.h
//  YMFramework
//
//  Created by 涛 陈 on 6/5/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YMAdditions)

+ (UIImage *)ym_rotateImage:(UIImage *)image
                    degrees:(CGFloat)degrees;

+ (UIImage *)ym_imageWithColor:(UIColor *)color
                          size:(CGSize)imageSize;

+ (UIImage *)ym_placeHolderImageWithiconImage:(UIImage *)iconImage
                              backgroundColor:(UIColor *)backgroundColor
                                         size:(CGSize)imageSize;

@end
