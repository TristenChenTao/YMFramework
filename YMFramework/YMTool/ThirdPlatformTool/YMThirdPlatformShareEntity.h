//
//  YMThirdPlatformShareEntity.h
//  YMFramework
//
//  Created by Tristen on 1/15/15.
//  Copyright (c) 2015 YM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    YMThirdPlatformShareForWeibo = 1,
    YMThirdPlatformShareForQQSpace = 2,
    YMThirdPlatformShareForWechatTimeline =  3,
    YMThirdPlatformShareForWechatSession =  4,
    YMThirdPlatformShareForQQFriend = 5,
}YMThirdPlatformShareType;

typedef enum
{
    YMThirdPlatformContentForNews = 1,
    YMThirdPlatformContentForImage = 2,
    YMThirdPlatformContentForApp =  3,
}YMThirdPlatformContentType;

@interface YMThirdPlatformShareEntity : NSObject

@property(nonatomic, assign)YMThirdPlatformShareType shareType;

@property(nonatomic, assign)YMThirdPlatformContentType contentType;

@property(nonatomic, copy) NSString *title;

@property(nonatomic, copy) NSString *contentText;

@property(nonatomic, copy) NSString *imageUrl;

@property(nonatomic, copy) NSString *resourceUrl;

- (instancetype)initWithData:(NSDictionary *)obj;

@end
