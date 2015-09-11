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
    YMHttpMethodTypeForGet = 1,
    YMHttpMethodTypeForPost = 2,
} YMHttpMethodType;


//请求响应状态
typedef enum
{
    YMHttpResponseTypeForSuccess = 1,
    YMHttpResponseTypeForFail = 2,
    YMHttpResponseTypeForNoReachable = 3
} YMHttpResponseType;

@interface YMHTTPRequestManager : NSObject

/**
 *  HTTP 接口请求
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
+ (YMHTTPRequestOperation *)requestWithMethodType:(YMHttpMethodType)methodType
                                      relativeURL:(NSString *)relativeURL
                                          baseURL:(NSString *)baseURL
                                           baseIP:(NSString *)baseIP
                                      headerField:(NSDictionary *)headerField
                                       parameters:(NSDictionary *)parameters
                                          timeout:(float)timeout
                                          success:(void (^)(NSURLRequest *request, NSInteger ResultCode, NSString *ResultMessage,id data))success
                                          failure:(void (^)(NSURLRequest *request, NSError *error))failure;

/**
 *  HTTP Web请求
 *
 *  @param methodType  请求类型
 *  @param URLAddress 接口相对地址
 *  @param headerField 头部信息
 *  @param parameters  请求参数
 *  @param timeout     超时设置(默认设置是5秒)
 *  @param success     请求成功回调
 *  @param failure     请求失败回调
 *
 *  @return
 */
+ (NSMutableURLRequest *)requestWithMethodType:(YMHttpMethodType)methodType
                                    URLAddress:(NSString *)URLAddress
                                       timeout:(float)timeout
                                    parameters:(NSDictionary *)parameters
                                   headerField:(NSDictionary *)headerField;

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


