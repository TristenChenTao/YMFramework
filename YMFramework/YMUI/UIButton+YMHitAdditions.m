//
//  UIButton+YMHitAdditions.m
//  YMFramework
//
//  Created by 涛 陈 on 7/22/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <objc/runtime.h>

#import "UIButton+YMHitAdditions.h"

@implementation UIButton (YMHitAdditions)

@dynamic ym_HitFrameEdgeInsets;

const static NSString *kYM_HitFrameAdditionsKey = @"kYMHitFrameAdditionsKey";

#pragma mark - getters and setters

- (void)setYm_HitFrameEdgeInsets:(UIEdgeInsets)ym_HitFrameEdgeInsets
{
	NSValue *value = [NSValue value:&ym_HitFrameEdgeInsets
					   withObjCType:@encode(UIEdgeInsets)];
	
	objc_setAssociatedObject(self, &kYM_HitFrameAdditionsKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)ym_HitFrameEdgeInsets
{
	NSValue *value = objc_getAssociatedObject(self, &kYM_HitFrameAdditionsKey);
	
	if(value) {
		UIEdgeInsets edgeInsets; [value getValue:&edgeInsets];
		return edgeInsets;
	} else {
		return UIEdgeInsetsZero;
	}
}

- (BOOL)pointInside:(CGPoint)point
		  withEvent:(UIEvent *)event
{
	if (UIEdgeInsetsEqualToEdgeInsets(self.ym_HitFrameEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
		return [super pointInside:point
						withEvent:event];
	}
	
	CGRect relativeFrame = self.bounds;
	CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.ym_HitFrameEdgeInsets);
	
	return CGRectContainsPoint(hitFrame, point);
}

@end