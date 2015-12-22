//
//  YMHTTPResponseData.m
//  YMFramework
//
//  Created by Tristen on 12/15/15.
//  Copyright © 2015 cornapp. All rights reserved.
//

#import "YMHTTPResponseData.h"
#import "NSDictionary+YMAccessors.h"

@implementation YMHTTPResponseData

static NSString *kResultCodeKey = @"ResultCode";
static NSString *kResultMessageKey = @"ResultMessage";
static NSString *kResultTimestamp = @"Timestamp";
static NSString *kResultDataKey = @"Data";

- (instancetype)initWithData:(NSDictionary *)obj
{
    self = [super init];
    if (!self) return nil;
    
    if (obj[kResultCodeKey]) {
        _ResultCode = [obj ym_unsignedIntegerForKey:kResultCodeKey];
    }
    else {
        _ResultCode = YMHTTPResponseStateForFail;
    }
    
    if ([obj ym_isStringForKey:kResultMessageKey]) {
        _ResultMessage = [obj ym_stringForKey:kResultMessageKey];
    }
    else {
        _ResultMessage = @"";
    }
    
    _ResultTimestamp = [obj ym_integerForKey:kResultTimestamp];
    
    if (obj[kResultCodeKey]) {
        _data = obj[kResultCodeKey];
    }
    
    return self;
}

@end
