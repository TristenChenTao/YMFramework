//
//  QDThirdPlatformUserInfo.h
//  TestThreePlatform2
//
//  Created by yumi_iOS on 12/11/15.
//  Copyright © 2015 yumi_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YMThirdPlatformTool.h"

@interface YMThirdPlatformUserInfo : NSObject

@property (nonatomic, assign) YMThirdPlatformType platformType;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *unionId;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *profileImageUrl;

@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic, strong) NSDate *expired;

@property (nonatomic, copy) NSString *homepage;

@end
