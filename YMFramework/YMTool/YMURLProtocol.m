//
//  YMURLProtocol.m
//  YMFramework
//
//  Created by 涛 陈 on 6/16/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import "STWebPURLProtocol.h"

#import "YMURLProtocol.h"


@implementation YMURLProtocol

+ (void)registerProtocol
{
    [STWebPURLProtocol registerWithOptions:@{STWebPURLProtocolOptionClaimWebPExtension: @YES}];
}

@end