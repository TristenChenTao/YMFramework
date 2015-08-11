//
//  YMHTTPRequestManager.m
//  TestAFN
//
//  Created by Tristen-Macbook on 7/12/14.
//  Copyright (c) 2014 yumi. All rights reserved.
//

#import "YMHTTPRequestManager.h"

#import "AFHTTPRequestOperationManager.h"

#import "YMAnalytics.h"
#import "YMFrameworkConfig.h"
#import "YMDeviceInfo.h"
#import "YMUI.h"

@interface YMHTTPRequestManager()

@end

@implementation YMHTTPRequestManager

static const int defaultTimeout = 5;
static const NSString *resultCodeKey = @"ResultCode";
static const NSString *resultMessageKey = @"ResultMessage";
static const NSString *resultDataKey = @"Data";


+ (YMHTTPRequestOperation *)requestWithMethodType:(YMHTTPMethodType)methodType
                                      relativeURL:(NSString *)relativeURL
                                          baseURL:(NSString *)baseURL
                                           baseIP:(NSString *)baseIP
                                      headerField:(NSDictionary *)headerField
                                       parameters:(NSDictionary *)parameters
                                          timeout:(float)timeout
                                          success:(void (^)(NSURLRequest *request, NSInteger ResultCode, NSString *ResultMessage,id data))success
                                          failure:(void (^)(NSURLRequest *request, NSError *error))failure;
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest *request = [YMHTTPRequestManager requestWithMethodType:methodType
                                                                    URLAddress:[baseURL stringByAppendingString:relativeURL]
                                                                       timeout:timeout
                                                                    parameters:parameters
                                                                   headerField:headerField];
    __block AFHTTPRequestOperation *operation = nil;
    operation = [manager HTTPRequestOperationWithRequest:request
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     [YMHTTPRequestManager handleSucceedResponse:operation
                                                                                  responseObject:responseObject
                                                                                         success:success];
                                                 }
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     //如果请求失败则清空缓存
                                                     [[NSURLCache sharedURLCache] removeAllCachedResponses];
                                                     //如果请求失败会使用IP方式请求
                                                     NSMutableURLRequest *request = [YMHTTPRequestManager requestWithMethodType:methodType
                                                                                                                     URLAddress:[baseIP stringByAppendingString:relativeURL]
                                                                                                                        timeout:timeout
                                                                                                                     parameters:parameters
                                                                                                                    headerField:headerField];
                                                     
                                                     operation = [manager HTTPRequestOperationWithRequest:request
                                                                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                                      [YMHTTPRequestManager handleSucceedResponse:operation
                                                                                                                                   responseObject:responseObject
                                                                                                                                          success:success];
                                                                                                  }
                                                                                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                                      if (failure) {
                                                                                                          failure(operation.request,error);
                                                                                                      }
                                                                                                  }
                                                                  ];
                                                     
                                                     [manager.operationQueue addOperation:operation];
                                                 }];
    
    [manager.operationQueue addOperation:operation];
    
    return (YMHTTPRequestOperation *)operation;
}

+ (NSMutableURLRequest *)requestWithMethodType:(YMHTTPMethodType)methodType
                                    URLAddress:(NSString *)URLAddress
                                       timeout:(float)timeout
                                    parameters:(NSDictionary *)parameters
                                   headerField:(NSDictionary *)headerField
{
    NSString *requestType = nil;
    switch (methodType) {
        case YMHTTPMethodTypeForGet:
            requestType = @"GET";
            break;
        case YMHTTPMethodTypeForPost:
            requestType = @"POST";
            break;
        default:
            requestType = @"POST";
            break;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = manager.requestSerializer;
    requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    if (timeout > 0) {
        requestSerializer.timeoutInterval = timeout;
    }
    else {
        requestSerializer.timeoutInterval = defaultTimeout;
    }
    
    parameters = [YMHTTPRequestManager packageParameters:parameters];
    
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:requestType
                                                              URLString:URLAddress
                                                             parameters:parameters
                                                                  error:nil];
    
    [headerField enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    return request;
}

+ (YMHTTPRequestOperation *)uploadImages:(NSArray *)images
                             relativeURL:(NSString *)relativeURL
                                 baseURL:(NSString *)baseURL
                                  baseIP:(NSString *)baseIP
                             headerField:(NSDictionary *)headerField
                              parameters:(NSDictionary *)parameters
                                 timeout:(float)timeout
                                 success:(void (^)(NSURLRequest *request, NSInteger ResultCode, NSString *ResultMessage,id data))success
                                 failure:(void (^)(NSURLRequest *request, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableURLRequest *request = [YMHTTPRequestManager multipartFormRequestWithURLAddress:[baseURL stringByAppendingString:relativeURL]
                                                                                    timeout:timeout
                                                                                 parameters:parameters
                                                                                     images:images
                                                                                headerField:headerField];
    __block AFHTTPRequestOperation *operation = nil;
    operation = [manager HTTPRequestOperationWithRequest:request
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     [YMHTTPRequestManager handleSucceedResponse:operation
                                                                                  responseObject:responseObject
                                                                                         success:success];
                                                 }
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     //如果请求失败则清空缓存
                                                     [[NSURLCache sharedURLCache] removeAllCachedResponses];
                                                     
                                                     //如果请求失败会使用IP方式请求
                                                     NSMutableURLRequest *request = [YMHTTPRequestManager multipartFormRequestWithURLAddress:[baseIP stringByAppendingString:relativeURL]
                                                                                                                                     timeout:timeout
                                                                                                                                  parameters:parameters
                                                                                                                                      images:images
                                                                                                                                 headerField:headerField];
                                                     
                                                     operation = [manager HTTPRequestOperationWithRequest:request
                                                                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                                      [YMHTTPRequestManager handleSucceedResponse:operation
                                                                                                                                   responseObject:responseObject
                                                                                                                                          success:success];
                                                                                                  }
                                                                                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                                      if (failure) {
                                                                                                          failure(operation.request,error);
                                                                                                      }
                                                                                                  }
                                                                  ];
                                                     
                                                     [manager.operationQueue addOperation:operation];
                                                 }];
    
    [manager.operationQueue addOperation:operation];
    
    return (YMHTTPRequestOperation *)operation;
}

+ (NSMutableURLRequest *)multipartFormRequestWithURLAddress:(NSString *)URLAddress
                                                   timeout:(float)timeout
                                                parameters:(NSDictionary *)parameters
                                                    images:(NSArray *)images
                                               headerField:(NSDictionary *)headerField
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = manager.requestSerializer;
    requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    if (timeout > 0) {
        requestSerializer.timeoutInterval = timeout;
    }
    else {
        requestSerializer.timeoutInterval = defaultTimeout;
    }
    
    parameters = [YMHTTPRequestManager packageParameters:parameters];
    
    NSMutableURLRequest *request = [requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                           URLString:URLAddress
                                                                          parameters:parameters
                                                           constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                               for (int i = 0; i < images.count ; i++) {
                                                                   UIImage *image = images[i];
                                                                   NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                                                                   [formData appendPartWithFormData:imageData
                                                                                               name:[NSString stringWithFormat:@"image%d",i]];
                                                               }
                                                           }
                                                                               error:nil];
    
    [headerField enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    return request;
}

+ (void)handleSucceedResponse:(AFHTTPRequestOperation *)operation
               responseObject:(id)responseObject
                      success:(void (^)(NSURLRequest *request, NSInteger ResultCode, NSString *ResultMessage,id data))success
{
    NSDictionary *dic = responseObject;
    NSInteger ResultCode = [dic[resultCodeKey] integerValue];
    NSString *ResultMessage = dic[resultMessageKey];
    NSDictionary *data = dic[resultDataKey];
    
    if (success) {
        success(operation.request, ResultCode, ResultMessage,data);
    }
}

+ (NSDictionary*)packageParameters:(NSDictionary *)parameters
{
    NSDictionary *baseInfo = @{@"adId" : [YMAnalytics idfaString],
                               @"productId" : [YMFrameworkConfig sharedInstance].productID,
                               @"productVersion" : [YMFrameworkConfig sharedInstance].productVersion,
                               @"channelId" : [YMFrameworkConfig sharedInstance].productChannel,
                               @"deviceVersion" : [YMDeviceInfo deviceType],
                               @"screenHeight" : @(kYm_ScreenHeight),
                               @"screenWidth" : @(kYm_ScreenWidth),
                               @"language" : [YMDeviceInfo language],
                               @"connectType" : [YMDeviceInfo newtworkType],
                               @"isJailBroken" : @([YMDeviceInfo isJailBroken])};
    
    
    NSMutableDictionary *finalParameters = [NSMutableDictionary dictionaryWithDictionary:baseInfo];
    [finalParameters addEntriesFromDictionary:parameters];
    
    return finalParameters;
}

@end


@implementation YMHTTPRequestOperation

@end
