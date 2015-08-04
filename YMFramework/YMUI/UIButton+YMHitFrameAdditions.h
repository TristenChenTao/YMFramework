//
//  UIButton+YMHitFrameAdditions.h
//  YMFramework
//
//  Created by 涛 陈 on 7/22/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YMHitFrameAdditions)

@property (readonly, nonatomic, assign) UIEdgeInsets ym_HitFrameEdgeInsets;

- (void)ym_changeHitFrameEdgeInsets:(UIEdgeInsets)edgeInsets;

@end
