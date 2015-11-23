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
- (void)ym_drawLineWithFrame:(CGRect)frame
                       color:(UIColor *)color;

- (UIView *)ym_addLineViewWithFrame:(CGRect)frame
                              color:(UIColor *)color;

///////虚线
- (void)ym_drawDashLineWithFrame:(CGRect)frame
                           color:(UIColor *)color;


- (UIView *)ym_addDashLineViewWithFrame:(CGRect)frame
                                  color:(UIColor *)color;

@end
