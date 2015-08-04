//
//  UIImage+YMAdditions.h
//  YMFramework
//
//  Created by 涛 陈 on 6/5/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YMAdditions)

+ (UIImage *)rotateImage:(UIImage *)image
                 degrees:(CGFloat)degrees;

+ (UIImage *)imageWithColor:(UIColor *)color
                       size:(CGSize)imageSize;

+ (UIImage *)placeHolderImageWithiconImage:(UIImage *)iconImage
                           backgroundColor:(UIColor *)backgroundColor
                                      size:(CGSize)imageSize;

@end
