//
//  QDThirdPlatformShareEntity.m
//  TestThreePlatform2
//
//  Created by yumi_iOS on 12/11/15.
//  Copyright © 2015 yumi_iOS. All rights reserved.
//

#import "YMThirdPlatformShareEntity.h"

@implementation YMThirdPlatformShareEntity

- (instancetype)initWithData:(NSDictionary *)obj
{
    self = [super init];
    if (!self) return nil;
    
    _shareType = [obj[@"shareType"] intValue];
    _title = obj[@"title"];
    _contentText = obj[@"contentText"];
    _imageURL = obj[@"imageURL"];
    _resourceURL = obj[@"resourceURl"];
    
    return self;
}

@end
