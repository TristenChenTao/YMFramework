//
//  YMProgress.h
//  YMFramework
//
//  Created by Tristen on 12/8/15.
//  Copyright © 2015 cornapp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,YMProgrssFailType)
{
    YMProgrssFailTypeForNormal = 1,
    YMProgrssFailTypeForNotReachable = 2,
    YMProgrssFailTypeForLocation = 3
};

@interface YMProgress : NSObject

+ (void)showWithStatus:(NSString *)status;

+ (void)dismiss;

+ (void)showSuccessStatus:(NSString *)text;

+ (void)showFailStatus:(NSString *)text;

+ (void)showFailStatus:(NSString *)text
          withFailType:(YMProgrssFailType)failType;

+ (void)showInfoWithStatus:(NSString *)text;

@end
