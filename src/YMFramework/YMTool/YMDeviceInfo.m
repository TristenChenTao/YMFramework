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
#import "MobClick.h"

#import "YMDeviceInfo.h"
#import "NSString+YMAdditions.h"

@interface YMDeviceInfo()

@end

@implementation YMDeviceInfo

#define SystemSharedServices [SystemServices sharedServices]

+ (float)systemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (NSString *)deviceType
{
    static NSString *deviceType = nil;
    if ([NSString ym_isContainString:deviceType]) {
        return deviceType;
    }
    
    deviceType = [YMDeviceInfo platformType:[YMDeviceInfo deviceVersion]];
    return deviceType;
}

+ (NSString *)deviceVersion
{
    static NSString *deviceVersion = nil;
    
    if ([NSString ym_isContainString:deviceVersion]) {
        return deviceVersion;
    }
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    deviceVersion = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return deviceVersion;
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

+ (NSString *)country
{
    return [SystemSharedServices country];
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
    return [MobClick isJailbroken];
}

#pragma mark - private methods

+  (NSString *)platformType:(NSString *)platform
{
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3 (WiFi)";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3 (Cellular)";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3 (China)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    if ([platform isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2G";
    if ([platform isEqualToString:@"AppleTV3,1"])   return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV3,2"])   return @"Apple TV 3 (2013)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    else                                            return @"Unknown";
    
    return platform;
}

@end