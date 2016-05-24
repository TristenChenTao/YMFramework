//
//  YMDeviceInfo.m
//  YuMiAssistant
//
//  Created by Tristen-MacBook on 14/9/11.
//
//

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UMMobClick/MobClick.h>

//for mac
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

//for idfa
#import <AdSupport/AdSupport.h>

#import <mach/mach.h>
#import <mach/mach_host.h>

#import "SystemServices.h"

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

+ (NSString * )macString
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return macString;
}

+ (NSString *)idfaString
{
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if ([NSString ym_isEmptyString:idfa]) {
        
        return @"";
    }
    
    return idfa;
}

+ (NSString *)idfvString
{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    if ([NSString ym_isEmptyString:idfv]) {
        return @"";
    }
    
    return idfv;
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