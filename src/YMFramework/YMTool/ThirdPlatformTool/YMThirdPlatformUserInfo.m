//
//  YMThirdPlatformUserInfo.m
//  YuMiAssistant
//
//  Created by Tristen-MacBook on 8/18/14.
//
//

#import "YMThirdPlatformUserInfo.h"

#import "NSString+YMAdditions.h"

@interface YMThirdPlatformUserInfo()

@end

@implementation YMThirdPlatformUserInfo



- (NSString *)userId
{
    if ([NSString ym_isContainString:_userId]) {
        return _userId;
    }
    else {
        return @"";
    }
}

- (NSString *)nickname
{
    if ([NSString ym_isContainString:_nickname]) {
        return _nickname;
    }
    else {
        return @"";
    }
}

- (NSString *)profileImageUrl
{
    if ([NSString ym_isContainString:_profileImageUrl]) {
        return _profileImageUrl;
    }
    else {
        return @"";
    }
}

- (NSString *)accessToken
{
    if ([NSString ym_isContainString:_accessToken]) {
        return _accessToken;
    }
    else {
        return @"";
    }
}

- (NSString *)homepage
{
    if ([NSString ym_isContainString:_homepage]) {
        return _homepage;
    }
    else {
        return @"";
    }
}

@end
