//
//  YMFrameworkConfig.h
//  YMFramework
//
//  Created by 涛 陈 on 6/4/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YMTool.h"

@interface YMFrameworkConfig : NSObject

@property (nonatomic, copy)NSString *userID;
@property (readonly, nonatomic, copy) NSString *productID;
@property (readonly, nonatomic, copy) NSString *productVersion;
@property (readonly, nonatomic, copy) NSString *productChannel;

YM_MacrosSingletonInterface

- (void)setupProductByID:(NSString *)ID
                 version:(NSString *)version;

@end
