//
//  YMTool.h
//  YMFramework
//
//  Created by 涛 陈 on 4/24/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

//单例模式
#define YM_DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t onceToken = 0; \
__strong static id sharedInstance = nil; \
dispatch_once(&onceToken, ^{ \
sharedInstance = block(); \
}); \
return sharedInstance; \

#ifdef DEBUG
#   define YMLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define YMLog(...)
#endif







