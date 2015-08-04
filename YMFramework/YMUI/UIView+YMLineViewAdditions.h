//
//  UIView+YMLineViewAdditions.h
//  YMFramework
//
//  Created by 涛 陈 on 5/11/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YMLineViewAdditions)

///////实线
- (void)drawLineWithFrame:(CGRect)frame
                    color:(UIColor *)color;

- (UIView *)addLineViewWithFrame:(CGRect)frame
                           color:(UIColor *)color;

///////虚线
- (void)drawDashLineWithFrame:(CGRect)frame
                        color:(UIColor *)color;


- (UIView *)addDashLineViewWithFrame:(CGRect)frame
                               color:(UIColor *)color;

@end
