//
//  YMThirdPlatformShareEntity.m
//  YMFramework
//
//  Created by Tristen on 1/15/15.
//  Copyright (c) 2015 YM. All rights reserved.
//

#import "YMThirdPlatformShareEntity.h"

#import "NSString+YMAdditions.h"

@implementation YMThirdPlatformShareEntity

- (instancetype)initWithData:(NSDictionary *)obj
{
    self = [super init];
    if (!self) return nil;
    
    _shareType = [obj[@"shareType"] intValue];
    _contentType = [obj[@"contentType"] intValue];
    _title = obj[@"title"];
    _contentText = obj[@"contentText"];
    _imageURL = obj[@"imageUrl"];
    _resourceURL = obj[@"resourceUrl"];
    _callbackAddress = obj[@"callbackAddress"];
    _callbackType = [obj[@"callbackType"] intValue];
    
    return self;
}

- (NSString *)title
{
    if ([NSString ym_isContainString:_title]) {
        return _title;
    }
    else {
        return @"";
    }
}

- (NSString *)contentText
{
    if ([NSString ym_isContainString:_contentText]) {
        return _contentText;
    }
    else {
        return @"";
    }
}

- (NSString *)imageURL
{
    if ([NSString ym_isContainString:_imageURL]) {
        return _imageURL;
    }
    else {
        return @"";
    }
}

- (NSString *)resourceURL
{
    if ([NSString ym_isContainString:_resourceURL]) {
        return _resourceURL;
    }
    else {
        return @"";
    }
}

- (NSString *)callbackAddress
{
    if ([NSString ym_isContainString:_callbackAddress]) {
        return _callbackAddress;
    }
    else {
        return @"";
    }
}

@end
