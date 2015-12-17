//
//  YMTool.h
//  YMFramework
//
//  Created by 涛 陈 on 4/24/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

///---------------------------------------------------------------------------------
/// @name Singleton Macros
///---------------------------------------------------------------------------------

/**
 Add a Singelton implementation to the .m File
 */
#define YM_MacrosSingletonImplemantion \
+ (instancetype)sharedInstance { \
\
static dispatch_once_t onceToken; \
static id sharedInstance = nil; \
dispatch_once(&onceToken, ^{ \
sharedInstance = [self.class new]; \
}); \
\
return sharedInstance; \
}

/**
 Add a Singelton interface declaration to the .h File
 */
#define YM_MacrosSingletonInterface + (instancetype)sharedInstance;

///---------------------------------------------------------------------------------
/// @name Log Macros
///---------------------------------------------------------------------------------

#ifdef DEBUG
#   define YM_Log(...) NSLog(__VA_ARGS__)
#else
#   define YM_Log(...)
#endif


#ifdef DEBUG
#   define YM_Log_Detail(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define YM_Log_Detail(...)
#endif


///---------------------------------------------------------------------------------
/// @name Debug Macros
///---------------------------------------------------------------------------------


#ifdef DEBUG

static BOOL const YM_Is_Debug = YES;
static BOOL const YM_Is_Release = NO;

#else

static BOOL const YM_Is_Debug = NO;
static BOOL const YM_Is_Release = YES;

#endif

///---------------------------------------------------------------------------------
/// @name Background Task Macros
///---------------------------------------------------------------------------------

#define YM_BgTaskBegin() { \
UIApplication *app = [UIApplication sharedApplication]; \
UIBackgroundTaskIdentifier task = [app beginBackgroundTaskWithExpirationHandler:^{ \
[app endBackgroundTask:task]; \
/* task = UIBackgroundTaskInvalid; */ \
}]; \
dispatch_block_t block = ^{ \

#define YM_BgTaskEnd() \
[app endBackgroundTask:task]; \
/* task = UIBackgroundTaskInvalid; */ \
}; \
dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block); \
}
