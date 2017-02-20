//
//  YMFrameworkConfig.m
//  YMFramework
//
//  Created by 涛 陈 on 6/4/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YMFrameworkConfig.h"
#import "YMTool.h"
#import "NSString+YMAdditions.h"

#import "YMPush.h"
#import "YMAnalytics.h"
#import "YMThirdPlatformTool.h"
#import "YMURLProtocol.h"

@interface YMFrameworkConfig()

@property (readwrite, nonatomic, copy) NSString *productID;
@property (readwrite, nonatomic, copy) NSString *productVersion;

@end

@implementation YMFrameworkConfig

YM_MacrosSingletonImplemantion

- (void)setupProductByID:(NSString *)ID
                 version:(NSString *)version
{
    self.productID = ID;
    self.productVersion = version;
}

- (void)setProductID:(NSString *)productID
{
    if ([NSString ym_isContainString:productID]) {
        _productID = productID;
    }
    else {
        _productID = @"";
    }
}

- (void)setProductVersion:(NSString *)productVersion
{
    if ([NSString ym_isContainString:productVersion]) {
        _productVersion = productVersion;
    }
    else {
        _productVersion = @"";
    }
}

- (NSString *)userID
{
    if ([NSString ym_isContainString:_userID]) {
        return _userID;
    }
    
    return @"";
}

@end
