//
//  NSString+YMAdditions.h
//  YMFramework
//
//  Created by 涛 陈 on 4/14/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YMAdditions)

+ (BOOL)ym_isEmptyString:(NSString *)string;

+ (BOOL)ym_isContainString:(NSString *)string;

/**
 *  去除空格与换行
 */
+ (NSString *)ym_trim:(NSString *)string;

- (NSString *)ym_urlEncode;

- (NSString *)ym_urlDecode;

/**
 *  生成随机字符串
 *
 *  @param len 字符串长度
 *
 *  @return
 */
+ (NSString *)ym_randomStringWithLength:(NSInteger)len;


/**
 *  从URL中取值
 *
 *  @param key
 *
 *  @return value
 */
- (NSString *)ym_parameterForKeyFromURL:(NSString *)key;


/**
 *  判断是否是网站链接
 *
 *  @return 
 */
- (BOOL)ym_isWebURL;

/**
 *  判断是否是App Store链接
 *
 *  @return
 */
- (BOOL)ym_isAppStoreURL;

/**
 *  判断是否是包含表情
 *
 *  @return
 */
- (BOOL)ym_isContainsEmoji;

@end
