//
//  YMThirdPlatformUserInfo.h
//  YuMiAssistant
//
//  Created by Tristen-MacBook on 8/18/14.
//
//

#import <Foundation/Foundation.h>

#import "YMThirdPlatformTool.h"

@interface YMThirdPlatformUserInfo : NSObject

@property (nonatomic, assign) YMThirdPlatformType platformType;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *profileImageUrl;

@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic, strong) NSDate *expired;

@property (nonatomic, copy) NSString *homepage;

@end
