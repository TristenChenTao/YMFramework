//
//  AnalyticsModel.m
//  YMHelper
//
//  Created by kkkz on 12/17/15.
//  Copyright © 2015 YM. All rights reserved.
//

#import "YMAnalyticsModel.h"
#import "NSString+YMAdditions.h"

@interface YMAnalyticsModel() <NSCoding>

@end

@implementation YMAnalyticsModel

static NSString *kActionId = @"kActionId";
static NSString *kActionTimestamp = @"kActionTimestamp";

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.actionId forKey:kActionId];
    [encoder encodeObject:self.actionTimestamp forKey:kActionTimestamp];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.actionId = [decoder decodeObjectForKey:kActionId];
        self.actionTimestamp = [decoder decodeObjectForKey:kActionTimestamp];
    }
    
    return self;
}

#pragma mark - getters and setters

- (NSString *)actionId
{
    if ([NSString ym_isContainString:_actionId]) {
        return _actionId;
    }
    
    return @"";
}

- (NSString *)actionTimestamp
{
    if ([NSString ym_isContainString:_actionTimestamp]) {
        return _actionTimestamp;
    }
    
    return @"";
}

@end
