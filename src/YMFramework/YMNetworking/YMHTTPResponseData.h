//
//  YMHTTPResponseData.h
//  YMFramework
//
//  Created by Tristen on 12/15/15.
//  Copyright © 2015 cornapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YMHTTPManager.h"

//请求响应状态
typedef NS_ENUM(NSUInteger, YMHTTPResponseState)
{
    YMHTTPResponseStateForSuccess = 1,
    YMHTTPResponseStateForFail = 2,
    YMHTTPResponseStateForNoReachable = 3
};

@interface YMHTTPResponseData : NSObject

@property (readonly, nonatomic, assign) YMHTTPResponseState ResultCode;;
@property (readonly, nonatomic, copy  ) NSString            *ResultMessage;
@property (readonly, nonatomic, assign) NSInteger           ResultTimestamp;
@property (readonly, nonatomic, strong) id                  data;

- (instancetype)initWithData:(NSDictionary *)obj;

@end
