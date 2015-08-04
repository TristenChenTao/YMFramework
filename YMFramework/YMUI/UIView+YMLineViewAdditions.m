//
//  UIView+YMLineViewAdditions.m
//  YMFramework
//
//  Created by 涛 陈 on 5/11/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import "UIView+YMLineViewAdditions.h"

@implementation UIView (YMLineViewAdditions)

- (void)drawLineWithFrame:(CGRect)frame
					color:(UIColor *)color
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetStrokeColorWithColor(context, color.CGColor);
	CGContextSetLineWidth(context, frame.size.height);
	CGContextMoveToPoint(context, frame.origin.x, frame.origin.y);
	CGContextAddLineToPoint(context, frame.origin.x + frame.size.width, frame.origin.y);
	CGContextStrokePath(context);
}

- (UIView *)addLineViewWithFrame:(CGRect)frame
						   color:(UIColor *)color
{
	UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
	lineView.backgroundColor = color;
	[self addSubview:lineView];
	
	return lineView;
}

- (void)drawDashLineWithFrame:(CGRect)frame
						color:(UIColor *)color
{
	UIGraphicsBeginImageContext(frame.size);   //开始画线
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
	CGFloat lengths[] = {3,3};
	CGContextRef line = UIGraphicsGetCurrentContext();
	CGContextSetStrokeColorWithColor(line, color.CGColor);
	CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
	CGContextMoveToPoint(line, 0.0, 0);    //开始画线
	CGContextAddLineToPoint(line, frame.size.width, frame.size.height);
	CGContextStrokePath(line);
}

- (UIView *)addDashLineViewWithFrame:(CGRect)frame
							   color:(UIColor *)color
{
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
	imageView.backgroundColor = [UIColor clearColor];
	[self addSubview:imageView];
	
	[self drawDashLineWithFrame:frame color:color];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	imageView.image = image;
	
	return imageView;
}

@end
