//
//  YMConfig.h
//  ESGAME
//
//  Created by Tristen陈涛 on 2017/2/20.
//  Copyright © 2017年 ESGAME. All rights reserved.
//

#ifndef YMConfig_h
#define YMConfig_h


#endif /* YMConfig_h */


//产品信息
static NSString * const kProductID = @"106";
static NSString * const kProductVersion = @"2";

//第三方服务信息

//友盟
static NSString * const kUMengAppKey = @"5715d15467e58ecdbd000b23";

//bugtag
static NSString * const kBugtagsAppKey = @"d52480aa42ebf840bb397342bb5e3808";

//微信
static NSString * const kWechatAppID = @"wx7d2983f6325f0d0a";
static NSString * const kWechatAppSecret = @"1ff3f5ff6101207a28a2653f030ab3fa";

//QQ
static NSString * const kQQAppID = @"1105295181";
static NSString * const kQQAppKey = @"bmNR6IwCkD1R9t40";


//微博
static NSString * const kSinaWeiboAppKey = @"267955451";
static NSString * const kSinaWeiboAppSecret = @"ef3f383dfe54e35c39c172b790083900";
static NSString * const kSinaWeiboAppRedirectURL = @"http://cornapp.com/";


//推送信息
#ifdef DEBUG
static NSString * const kPushAppKey = @"5b7baa565d76c7f4836a0613";//正式
#else

static NSString * const kPushAppKey = @"5b7baa565d76c7f4836a0613";//正式
#endif
