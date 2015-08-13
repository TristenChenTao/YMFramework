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

typedef enum
{
    YMThirdPlatformCallbackTypeForWebURL = 1,
    YMThirdPlatformCallbackTypeForHTTPRequest = 2,
}YMThirdPlatformCallbackType;

@interface YMThirdPlatformShareEntity : NSObject

@property(readonly, nonatomic, assign)YMThirdPlatformShareType shareType;

@property(readonly, nonatomic, assign)YMThirdPlatformContentType contentType;

@property(readonly, nonatomic, copy) NSString *title;

@property(readonly, nonatomic, copy) NSString *contentText;

@property(readonly, nonatomic, copy) NSString *imageURL;

@property(readonly, nonatomic, copy) NSString *resourceURL;

@property(readonly, nonatomic, copy) NSString *callbackAddress;

@property(readonly, nonatomic, assign)YMThirdPlatformCallbackType callbackType;


- (instancetype)initWithData:(NSDictionary *)obj;

@end
