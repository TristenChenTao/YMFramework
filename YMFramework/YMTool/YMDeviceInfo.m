//
//  YMDeviceInfo.m
//  YuMiAssistant
//
//  Created by Tristen-MacBook on 14/9/11.
//
//

#import <mach/mach.h>
#import <mach/mach_host.h>

#import "SystemServices.h"

#import "YMDeviceInfo.h"
#import "NSString+YMAdditions.h"

@interface YMDeviceInfo()

@end

@implementation YMDeviceInfo

#define SystemSharedServices [SystemServices sharedServices]

+ (float)deviceOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (NSString *)deviceType
{
    return [SystemSharedServices systemDeviceTypeNotFormatted];
}

+ (NSString *)availableDiskSpace
{
    return [SystemSharedServices freeDiskSpaceinRaw];
}

+ (NSString *)totalDiskSpace
{
    return [SystemSharedServices diskSpace];
}

+ (NSString *)usedDiskSpace
{
    return [SystemSharedServices usedDiskSpaceinRaw];
}

+ (double)diskSpaceUsedRate
{
    return [[SystemSharedServices usedDiskSpaceinPercent] floatValue] / 100;
}

+ (NSString *)totalMemorySpace
{
    return [NSString stringWithFormat:@"%.2f MB",[SystemSharedServices totalMemory]];
}

//返回的单位为MB
+ (double)availableMemorySpace
{
    return [SystemSharedServices totalMemory] - [SystemSharedServices usedMemoryinRaw];
}

+ (NSString *)usedMemorySpace
{
    return [NSString stringWithFormat:@"%.2f MB",[SystemSharedServices usedMemoryinRaw]];
}

+ (double)memorySpaceUsedRate
{
    return [SystemSharedServices usedMemoryinPercent] /100;
}

+ (NSString *)language
{
    return [SystemSharedServices language];
}

+ (NSString *)newtworkType
{
    CTTelephonyNetworkInfo *telephonyInfo = [CTTelephonyNetworkInfo new];
    
    NSString *netType = @"";
    
    if ([NSString ym_isContainString:telephonyInfo.currentRadioAccessTechnology]) {
        netType = telephonyInfo.currentRadioAccessTechnology;
    }
    
    return netType;
}

+ (BOOL)isJailBroken
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        return YES;
    }
    
    return NO;
}

@end
