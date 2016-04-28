//
//  YMHttpParameterFactory.m
//  YMFramework
//
//  Created by Tristen on 1/12/16.
//  Copyright © 2016 cornapp. All rights reserved.
//

#import "YMHttpParameterFactory.h"

#import "YMFrameworkConfig.h"
#import "YMDeviceInfo.h"
#import "YMUI.h"

@implementation YMHttpParameterFactory

+ (NSDictionary *)creatProductInfo
{
    NSDictionary *productInfo = @{@"proID" : [YMFrameworkConfig sharedInstance].productID,
                                  @"edition" : [YMFrameworkConfig sharedInstance].productVersion,
                                  @"channel" : [YMFrameworkConfig sharedInstance].productChannel,
                                  @"uid" : [YMFrameworkConfig sharedInstance].userID,
                                  @"osType" : @(1)
                                  };
    return productInfo;
}

/**
 *  构造基础设备信息请求参数
 *
 *  @return 基础设备信息请求参数
 */
+ (NSDictionary *)creatDeviceInfo
{
    NSDictionary *productInfo = @{@"deviceId" : [YMDeviceInfo idfaString],
                                  @"device" : [YMDeviceInfo deviceVersion],
                                  @"scrH" : @(kYm_ScreenHeight),
                                  @"scrW" : @(kYm_ScreenWidth),
                                  @"lang" : [YMDeviceInfo language],
                                  @"network" : [YMDeviceInfo newtworkType],
                                  @"isCrack" : @([YMDeviceInfo isJailBroken]),
                                  @"country" : [YMDeviceInfo country],
                                  @"osType" : @(1),
                                  @"osVer" : @([YMDeviceInfo systemVersion])
                                  };
    return productInfo;
}

/**
 *  构造基础产品和设备信息请求参数
 *
 *  @return 基础基础产品和设备信息请求参数
 */
+ (NSDictionary *)creatAllInfo
{
    NSMutableDictionary *allInfo = [NSMutableDictionary dictionary];
    [allInfo addEntriesFromDictionary:[YMHttpParameterFactory creatProductInfo]];
    [allInfo addEntriesFromDictionary:[YMHttpParameterFactory creatDeviceInfo]];
    
    return allInfo;
}

@end
