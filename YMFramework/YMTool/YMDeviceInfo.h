//
//  YMDeviceInfo.h
//  YuMiAssistant
//
//  Created by Tristen-MacBook on 14/9/11.
//
//

#import <Foundation/Foundation.h>

//判断iphone4
#define kYm_iPhone4Or4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone5
#define kYm_iPhone5Or5S ([[YMDeviceInfo deviceName] rangeOfString:@"iPhone 5"].length > 0 || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size))

//判断iphone6 (放大模式与标准模式)
#define kYm_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || [[YMDeviceInfo deviceName] isEqualToString:@"iPhone 6"]) : NO)

//判断iphone6+ (放大模式与标准模式)
#define kYm_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define kYm_iPad [[UIDevice currentDevice].model rangeOfString:@"iPad"].location != NSNotFound

//判断ios8之后版本
#define kYm_iOS8OrLater ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface YMDeviceInfo : NSObject

+ (float)deviceOSVersion;

+ (NSString *)deviceType;

+ (NSString *)totalDiskSpace;

+ (NSString *)availableDiskSpace;

+ (NSString *)usedDiskSpace;

+ (double)diskSpaceUsedRate;

+ (NSString *)totalMemorySpace;

+ (double)availableMemorySpace;

+ (NSString *)usedMemorySpace;

+ (double)memorySpaceUsedRate;

+ (NSString *)language;

+ (NSString *)newtworkType;

+ (BOOL)isJailBroken;

@end