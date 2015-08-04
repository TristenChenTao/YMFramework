//
//  YMHTTPRequestManager.h
//  TestAFN
//
//  Created by Tristen-Macbook on 7/12/14.
//  Copyright (c) 2014 yumi. All rights reserved.
//


#import <Foundation/Foundation.h>

@class YMHTTPRequestOperation;

typedef enum
{
    YMHTTPMethodTypeForGet = 1,
    YMHTTPMethodTypeForPost = 2,
} YMHTTPMethodType;

//判断请求状态
const static NSInteger kYMRequestSuccess = 1;
const static NSInteger kYMRequestFail = 0;

@interface YMHTTPRequestManager : NSObject

/**
 *  HTTP请求
 *
 *  @param methodType  请求类型
 *  @param relativeURL 接口相对地址
 *  @param baseURL     域名
 *  @param baseIP      IP地址(当域名解析失败时使用IP地址请求)
 *  @param headerField 头部信息
 *  @param parameters  请求参数
 *  @param timeout     超时设置(默认设置是5秒)
 *  @param success     请求成功回调
 *  @param failure     请求失败回调
 *
 *  @return
 */
+ (YMHTTPRequestOperation *)requestWithMethodType:(YMHTTPMethodType)methodType
                                      relativeURL:(NSString *)relativeURL
                                          baseURL:(NSString *)baseURL
                                           baseIP:(NSString *)baseIP
                                      headerField:(NSDictionary *)headerField
                                       parameters:(NSDictionary *)parameters
                                          timeout:(float)timeout
                                          success:(void (^)(NSURLRequest *request, NSInteger ResultCode, NSString *ResultMessage,id data))success
                                          failure:(void (^)(NSURLRequest *request, NSError *error))failure;

/**
 *  上传图片
 *
 *  @param images      图片数组
 *  @param relativeURL 接口相对地址
 *  @param baseURL     域名
 *  @param baseIP      IP地址(当域名解析失败时使用IP地址请求)
 *  @param headerField 头部信息
 *  @param parameters  请求参数
 *  @param timeout     超时设置(默认设置是5秒)
 *  @param success     请求成功回调
 *  @param failure     请求失败回调
 *
 *  @return
 */
+ (YMHTTPRequestOperation *)uploadImages:(NSArray *)images
                             relativeURL:(NSString *)relativeURL
                                 baseURL:(NSString *)baseURL
                                  baseIP:(NSString *)baseIP
                             headerField:(NSDictionary *)headerField
                              parameters:(NSDictionary *)parameters
                                 timeout:(float)timeout
                                 success:(void (^)(NSURLRequest *request, NSInteger ResultCode, NSString *ResultMessage,id data))success
                                 failure:(void (^)(NSURLRequest *request, NSError *error))failure;

@end

@interface YMHTTPRequestOperation : NSOperation

@end


