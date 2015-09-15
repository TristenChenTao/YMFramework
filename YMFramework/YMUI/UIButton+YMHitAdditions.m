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

const static NSString *kYM_AcceptEventInterval = @"kYM_AcceptEventIntervalKey";

const static NSString *kYM_ignoreEvent = @"kYM_ignoreEventKey";

const static NSTimeInterval kYM_DefaultEventInterval = 1.5;

+ (void)load
{
    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod(self, @selector(ym_button_sendAction:to:forEvent:));
    method_exchangeImplementations(a, b);
}

#pragma mark - public methods

- (void)ym_changeHitFrameEdgeInsets:(UIEdgeInsets)edgeInsets
{
	[self setYm_HitFrameEdgeInsets:edgeInsets];
}

#pragma mark - private methods

- (void)ym_button_sendAction:(SEL)action
                          to:(id)target
                    forEvent:(UIEvent *)event
{
    if(![self respondsToSelector:@selector(ym_ignoreEvent)]
       || ![self respondsToSelector:@selector(ym_button_sendAction:to:forEvent:)]) {
        return;
    }
    
    if (self.ym_ignoreEvent) return;
    
    NSTimeInterval interval = kYM_DefaultEventInterval;//默认间隔时间
    if (self.ym_AcceptEventInterval) {
        interval = [self.ym_AcceptEventInterval doubleValue];
    }
    
    self.ym_ignoreEvent = YES;
    [self performSelector:@selector(setYm_ignoreEvent:)
               withObject:@(NO)
               afterDelay:interval];
    
    
    [self ym_button_sendAction:action
                            to:target
                      forEvent:event];
}

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

- (NSNumber *)ym_AcceptEventInterval
{
    return objc_getAssociatedObject(self, &kYM_AcceptEventInterval);
}

- (void)setYm_AcceptEventInterval:(NSNumber *)ym_AcceptEventInterval
{
    objc_setAssociatedObject(self, &kYM_AcceptEventInterval, ym_AcceptEventInterval, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ym_ignoreEvent
{
    return [objc_getAssociatedObject(self, &kYM_ignoreEvent) boolValue];
}

- (void)setYm_ignoreEvent:(BOOL)ym_ignoreEvent
{
    objc_setAssociatedObject(self, &kYM_ignoreEvent, @(ym_ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end