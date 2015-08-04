//
//  YMThirdPlatformShareEntity.m
//  YMFramework
//
//  Created by Tristen on 1/15/15.
//  Copyright (c) 2015 YM. All rights reserved.
//

#import "YMThirdPlatformShareEntity.h"

@implementation YMThirdPlatformShareEntity

- (instancetype)initWithData:(NSDictionary *)obj
{
    self = [super init];
    if (!self) return nil;
    
    _shareType = [obj[@"shareType"] intValue];
    _contentType = [obj[@"contentType"] intValue];
    _title = obj[@"title"];
    _contentText = obj[@"contentText"];
    _imageUrl = obj[@"imageUrl"];
    _resourceUrl = obj[@"resourceUrl"];
    
    return self;
}

@end
