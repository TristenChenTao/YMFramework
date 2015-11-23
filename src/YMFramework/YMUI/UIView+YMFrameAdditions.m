//
//  UIView+ym_Additions.m
//  YMFramework
//
//  Created by 涛 陈 on 4/13/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import "UIView+YMFrameAdditions.h"

@implementation UIView (YMFrameAdditions)

- (CGPoint)ym_Position
{
    return self.frame.origin;
}

- (void)setYm_Position:(CGPoint)ym_Position
{
    CGRect rect = self.frame;
    rect.origin = ym_Position;
    [self setFrame:rect];
}

- (CGFloat)ym_X
{
    return self.frame.origin.x;
}

- (void)setYm_X:(CGFloat)ym_X
{
    CGRect rect = self.frame;
    rect.origin.x = ym_X;
    [self setFrame:rect];
}

- (CGFloat)ym_Y
{
    return self.frame.origin.y;
}

- (void)setYm_Y:(CGFloat)ym_Y
{
    CGRect rect = self.frame;
    rect.origin.y = ym_Y;
    [self setFrame:rect];
}

- (CGFloat)ym_Left
{
    return self.frame.origin.x;
}

- (void)setYm_Left:(CGFloat)ym_Left
{
    CGRect frame = self.frame;
    frame.origin.x = ym_Left;
    self.frame = frame;
}

- (CGFloat)ym_Top
{
    return self.frame.origin.y;
}

- (void)setYm_Top:(CGFloat)ym_Top
{
    CGRect frame = self.frame;
    frame.origin.y = ym_Top;
    self.frame = frame;
}

- (CGFloat)ym_Right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setYm_Right:(CGFloat)ym_Right
{
    CGRect frame = self.frame;
    frame.origin.x = ym_Right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)ym_CenterX
{
    return self.center.x;
}

- (void)setYm_CenterX:(CGFloat)ym_CenterX
{
    self.center = CGPointMake(ym_CenterX, self.center.y);
}

- (CGFloat)ym_CenterY
{
    return self.center.y;
}

- (void)setYm_CenterY:(CGFloat)ym_CenterY
{
    self.center = CGPointMake(self.center.x, ym_CenterY);
}

- (CGFloat)ym_Bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setYm_Bottom:(CGFloat)ym_Bottom
{
    CGRect frame = self.frame;
    frame.origin.y = ym_Bottom - frame.size.height;
    self.frame = frame;
}

- (CGSize)ym_Size
{
    return self.frame.size;
}

- (void)setYm_Size:(CGSize)ym_Size
{
    CGRect rect = self.frame;
    rect.size = ym_Size;
    [self setFrame:rect];
}

- (CGFloat)ym_Width
{
    return self.frame.size.width;
}

- (void)setYm_Width:(CGFloat)ym_Width
{
    CGRect rect = self.frame;
    rect.size.width = ym_Width;
    [self setFrame:rect];
}

- (CGFloat)ym_Height
{
    return self.frame.size.height;
}

- (void)setYm_Height:(CGFloat)ym_Height
{
    CGRect rect = self.frame;
    rect.size.height = ym_Height;
    [self setFrame:rect];
}

@end
