//
//  UIButton+YMHitAdditions.h
//  YMFramework
//
//  Created by 涛 陈 on 7/22/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YMHitAdditions)

@property (readonly, nonatomic, assign) UIEdgeInsets ym_HitFrameEdgeInsets;//设置点击区域

//@property (nonatomic, assign) NSTimeInterval ym_AcceptEventInterval; //设置重复点击时间间隔（默认1.5秒）

- (void)ym_changeHitFrameEdgeInsets:(UIEdgeInsets)edgeInsets;

@end
