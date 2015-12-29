//
//  QDThirdPlatformShareEntity.h
//  TestThreePlatform2
//
//  Created by yumi_iOS on 12/11/15.
//  Copyright © 2015 yumi_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YMThirdPlatformShareType)
{
    YMThirdPlatformShareTypeForWeibo = 1,
    YMThirdPlatformShareTypeForQQZone = 2,
    YMThirdPlatformShareTypeForWechatTimeline = 3,
    YMThirdPlatformShareTypeForWechatSession = 4,
    YMThirdPlatformShareTypeForQQFriend = 5,
};

@interface YMThirdPlatformShareEntity : NSObject

@property(nonatomic, assign)YMThirdPlatformShareType shareType;

@property(nonatomic, copy) NSString *title;

@property(nonatomic, copy) NSString *contentText;

@property(nonatomic, copy) NSString *imageURL;

@property(nonatomic, copy) NSString *resourceURL;

- (instancetype)initWithData:(NSDictionary *)obj;

@end
