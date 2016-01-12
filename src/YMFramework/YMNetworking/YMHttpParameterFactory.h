//
//  YMHttpParameterFactory.h
//  YMFramework
//
//  Created by Tristen on 1/12/16.
//  Copyright © 2016 cornapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMHttpParameterFactory : NSObject

/**
 *  构造基础产品信息请求参数
 *
 *  @return 基础产品信息请求参数
 */
+ (NSDictionary *)creatProductInfo;

/**
 *  构造基础设备信息请求参数
 *
 *  @return 基础设备信息请求参数
 */
+ (NSDictionary *)creatDeviceInfo;

/**
 *  构造基础产品和设备信息请求参数
 *
 *  @return 基础基础产品和设备信息请求参数
 */
+ (NSDictionary *)creatAllInfo;

@end
