//
//  NSString+YMAdditions.h
//  YMFramework
//
//  Created by 涛 陈 on 4/14/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YMAdditions)

+ (BOOL)isEmptyString:(NSString *)string;

+ (BOOL)isContainString:(NSString *)string;

- (NSString *)urlEncode;

- (NSString *)urlDecode;

/**
 *  去除空格与换行
 */
- (NSString *)trim;

/**
 *  生成随机字符串
 *
 *  @param len 字符串长度
 *
 *  @return
 */
+ (NSString *)randomStringWithLength:(NSInteger)len;


/**
 *  从URL中取值
 *
 *  @param key
 *
 *  @return value
 */
- (NSString *)parameterForKeyFromURL:(NSString *)key;


/**
 *  判断是否是网站链接
 *
 *  @return 
 */
- (BOOL)isWebURL;

/**
 *  判断是否是App Store链接
 *
 *  @return
 */
- (BOOL)isAppStoreURL;

@end
