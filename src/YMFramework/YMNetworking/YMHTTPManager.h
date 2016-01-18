//
//  YMHTTPManager.h
//  TestAFN
//
//  Created by Tristen-Macbook on 7/12/14.
//  Copyright (c) 2014 yumi. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "YMHTTPResponseData.h"
@class YMHTTPResponseData;

typedef enum
{
    YMHttpRequestTypeForGet = 1,
    YMHttpRequestTypeForPost = 2,
} YMHttpRequestType;

@interface YMHTTPManager : NSObject

+ (BOOL)isReachable;

/**
 *  HTTP请求
 *
 *  @param methodType  请求方法
 *  @param relativeURL 接口相对地址
 *  @param baseURL     域名
 *  @param baseIP      IP地址(当域名解析失败时使用IP地址请求)
 *  @param parameters  请求参数
 *  @param timeout     超时设置(默认设置是5秒)
 *  @param success     请求成功回调
 *  @param failure     请求失败回调
 *  @return
 */

+ (NSURLSessionDataTask *)requestWithMethodType:(YMHttpRequestType)methodType
                                    relativeURL:(NSString *)relativeURL
                                        baseURL:(NSString *)baseURL
                                         baseIP:(NSString *)baseIP
                                     parameters:(NSDictionary *)parameters
                                        timeout:(float)timeout
                                       progress:(void (^)(NSProgress *progress)) downloadProgress
                                        success:(void (^)(NSURLSessionDataTask *task, YMHTTPResponseData *responseData))success
                                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
/**
 *  HTTP Web请求
 *
 *  @param URLAddress  地址
 *  @param timeout     超时设置(默认设置是5秒)
 *  @param parameters  请求参数
 *
 *  @return
 */

+ (NSMutableURLRequest *)requestWithMethodType:(YMHttpRequestType)requestType
                                    URLAddress:(NSString *)URLAddress
                                       timeout:(float)timeout
                                    parameters:(NSDictionary *)parameters;

/**
 *  上传图片
 *
 *  @param images      图片数组
 *  @param imageNames 图片名数组
 *  @param relativeURL 接口相对地址
 *  @param baseURL     域名
 *  @param baseIP      IP地址(当域名解析失败时使用IP地址请求)
 *  @param parameters  请求参数
 *  @param timeout     超时设置(默认设置是5秒)
 *  @param success     请求成功回调
 *  @param failure     请求失败回调
 *
 *  @return
 */
+ (NSURLSessionDataTask *)uploadImages:(NSArray *)images
                            imageNames:(NSArray *)names
                           relativeURL:(NSString *)relativeURL
                               baseURL:(NSString *)baseURL
                                baseIP:(NSString *)baseIP
                            parameters:(NSDictionary *)parameters
                               timeout:(float)timeout
                              progress:(void (^)(NSProgress *progress))uploadProgress
                               success:(void (^)(NSURLSessionDataTask *task, YMHTTPResponseData *responseData))success
                               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


/**
 *  上传JSON大数据
 *
 *  @param data        JSON数据
 *  @param relativeURL 接口相对地址
 *  @param baseURL     域名
 *  @param baseIP      IP地址(当域名解析失败时使用IP地址请求)
 *  @param parameters  请求参数
 *  @param timeout     超时设置(默认设置是5秒)
 *  @param success     请求成功回调
 *  @param failure     请求失败回调
 *
 *  @return
 */
+ (NSURLSessionDataTask *)uploadJSONData:(NSData *)data
                             relativeURL:(NSString *)relativeURL
                                 baseURL:(NSString *)baseURL
                                  baseIP:(NSString *)baseIP
                              parameters:(NSDictionary *)parameters
                                 timeout:(float)timeout
                                progress:(void (^)(NSProgress *progress))uploadProgress
                                 success:(void (^)(NSURLSessionDataTask *task, YMHTTPResponseData *responseData))success
                                 failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


@end