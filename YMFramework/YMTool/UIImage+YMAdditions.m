//
//  UIImage+YMAdditions.m
//  YMFramework
//
//  Created by 涛 陈 on 6/5/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import "UIImage+YMAdditions.h"
#import "UIColor+YMAdditions.h"

@implementation UIImage (YMAdditions)

static inline CGFloat toRadians (CGFloat degrees) { return degrees * M_PI/180.0f; }

//images on iPhone should be no bigger than 1024, making images bigger than 1024 may cause crashes caused by not enough memory
#define maximumResultImageSize 1024

#pragma mark - Rotation

//clockwise when degrees < 0
+ (UIImage *)rotateImage:(UIImage *)image
                 degrees:(CGFloat)degrees
{
    CGSize newImageSize = [UIImage imageSizeForRect:CGRectMake(0.0f, 0.0f, image.size.width, image.size.height) rotatedByDegreees:degrees];
    //if the new ImageSize will be bigger than 1024 then we need to scale the image
    CGFloat maximum = MAX(newImageSize.width, newImageSize.height);
    CGFloat scaleFactor = 1.0f;
    if(maximum > maximumResultImageSize) {
        scaleFactor = maximumResultImageSize/maximum;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(newImageSize.width*scaleFactor, newImageSize.height*scaleFactor));
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGRect drawingRect = CGRectMake(0.0f, 0.0f, newImageSize.width*scaleFactor, newImageSize.height*scaleFactor);
    
    CGContextTranslateCTM(context, drawingRect.size.width/2, drawingRect.size.height/2);
    CGContextRotateCTM(context, toRadians(degrees));
    
    [image drawInRect:CGRectMake((-image.size.width*scaleFactor)/2, (-image.size.height*scaleFactor)/2, image.size.width*scaleFactor, image.size.height*scaleFactor)];
    UIGraphicsPopContext();
    UIImage *copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}

+ (UIImage *)rotateImage:(UIImage *)src
          andRotateAngle:(UIImageOrientation)orientation
{
    UIGraphicsBeginImageContext(src.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, toRadians(90));
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, toRadians(-90));
    } else if (orientation == UIImageOrientationDown) {
        // NOTHING
    } else if (orientation == UIImageOrientationUp) {
        CGContextTranslateCTM(context, src.size.width, 0.0f);
        CGContextRotateCTM (context, toRadians(90));
    }
    
    [src drawAtPoint:CGPointMake(0, 0)];
    UIGraphicsPopContext();
    
    return UIGraphicsGetImageFromCurrentImageContext();
}

+ (CGSize)imageSizeForRect:(CGRect)rect
         rotatedByDegreees:(CGFloat)degrees
{
    CGPoint rotationOrigin = CGPointMake(0.0f, 0.0f);
    CGFloat maxX = 0, minX = INT_MAX, maxY = 0, minY = INT_MAX;
    
    for(NSInteger i = 0; i < 4; ++i) {
        CGPoint toRotate = [UIImage getPointAtIndex:i ofRect:rect];
        CGPoint rotated = [UIImage rotatePoint:toRotate byDegrees:degrees aroundOriginPoint:rotationOrigin];
        minX = MIN(minX, rotated.x);
        minY = MIN(minY, rotated.y);
        maxX = MAX(maxX, rotated.x);
        maxY = MAX(maxY, rotated.y);
    }
    CGSize newSize = CGSizeMake(maxX - minX, maxY - minY);
    
    return newSize;
}

+ (CGPoint)getPointAtIndex:(NSUInteger)index
                    ofRect:(CGRect)rect
{
    //	NSAssert1(index >= 0 && index < 4, @"Rectangle has 4 corners, index should be between [0,3], u passed %d", index);
    CGPoint point = rect.origin;
    if(index == 1) {
        point.x += CGRectGetWidth(rect);
    }
    else if(index == 2) {
        point.y += CGRectGetHeight(rect);
    }
    else if(index == 3) {
        point.y += CGRectGetHeight(rect);
        point.x += CGRectGetWidth(rect);
    }
    
    return point;
}

+ (CGPoint)rotatePoint:(CGPoint)point
             byDegrees:(CGFloat)degrees
     aroundOriginPoint:(CGPoint)origin
{
    CGPoint rotated = CGPointMake(0.0f, 0.0f);
    CGFloat radians = toRadians(degrees);
    rotated.x = cos(radians) * (point.x-origin.x) - sin(radians) * (point.y-origin.y) + origin.x;
    rotated.y = sin(radians) * (point.x-origin.x) + cos(radians) * (point.y-origin.y) + origin.y;
    
    return rotated;
}

#pragma mark - Create Image

+ (UIImage *)imageWithColor:(UIColor *)color
                       size:(CGSize)imageSize
{
    CGRect rect=CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)placeHolderImageWithiconImage:(UIImage *)iconImage
                           backgroundColor:(UIColor *)backgroundColor
                                      size:(CGSize)imageSize
{
    CGRect rect=CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, rect);
    
    float iconImageLocationX = rect.size.width / 2 - iconImage.size.width / 2;
    float iconImageLocationY = rect.size.height / 2 - iconImage.size.height / 2;
    CGRect iconImageRect = CGRectMake(iconImageLocationX, iconImageLocationY, iconImage.size.width, iconImage.size.height);
    
    drawImage(context, [iconImage CGImage], iconImageRect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

void drawImage(CGContextRef context, CGImageRef image , CGRect rect)
{
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    CGContextDrawImage(context, rect, image);
    CGContextRestoreGState(context);
}

@end