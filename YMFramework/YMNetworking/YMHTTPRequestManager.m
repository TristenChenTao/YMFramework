//
//  YMHTTPRequestManager.m
//  TestAFN
//
//  Created by Tristen-Macbook on 7/12/14.
//  Copyright (c) 2014 yumi. All rights reserved.
//

#import "YMHTTPRequestManager.h"

#import "AFHTTPRequestOperationManager.h"

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
    
    NSMutableURLRequest *request = [YMHTTPRequestManager requestWithRequestSerializer:requestSerializer
                                                                               Method:requestType
                                                                            URLString:[baseURL stringByAppendingString:relativeURL]
                                                                           parameters:parameters
                                                                          headerField:headerField];
    __block AFHTTPRequestOperation *operation = nil;
    operation = [manager HTTPRequestOperationWithRequest:request
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     [YMHTTPRequestManager handleResponseWhenSucceedWithAFHTTPRequestOperation:operation
                                                                                                                responseObject:responseObject
                                                                                                                       success:success];
                                                 }
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     //如果请求失败则清空缓存
                                                     [[NSURLCache sharedURLCache] removeAllCachedResponses];
                                                     //如果请求失败会使用IP方式请求
                                                     NSMutableURLRequest *request = [YMHTTPRequestManager requestWithRequestSerializer:requestSerializer
                                                                                                                                Method:requestType
                                                                                                                             URLString:[baseIP stringByAppendingString:relativeURL]
                                                                                                                            parameters:parameters
                                                                                                                           headerField:headerField];
                                                     
                                                     operation = [manager HTTPRequestOperationWithRequest:request
                                                                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                                      [YMHTTPRequestManager handleResponseWhenSucceedWithAFHTTPRequestOperation:operation
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

+(NSMutableURLRequest *)requestWithRequestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                              Method:(NSString *)method
                                           URLString:(NSString *)URLString
                                          parameters:(id)parameters
                                         headerField:(NSDictionary *)headerField
{
    
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:method
                                                              URLString:URLString
                                                             parameters:parameters error:nil];
    
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
    AFHTTPRequestSerializer *requestSerializer = manager.requestSerializer;
    requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    if (timeout > 0) {
        requestSerializer.timeoutInterval = timeout;
    }
    else {
        requestSerializer.timeoutInterval = defaultTimeout;
    }
    
    NSMutableURLRequest *request = [YMHTTPRequestManager multipartFormRequestWithRequestSerializer:requestSerializer
                                                                                         URLString:[baseIP stringByAppendingString:relativeURL]
                                                                                        parameters:parameters
                                                                                            images:images
                                                                                       headerField:headerField];
    __block AFHTTPRequestOperation *operation = nil;
    operation = [manager HTTPRequestOperationWithRequest:request
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     [YMHTTPRequestManager handleResponseWhenSucceedWithAFHTTPRequestOperation:operation
                                                                                                                responseObject:responseObject
                                                                                                                       success:success];
                                                 }
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     //如果请求失败则清空缓存
                                                     [[NSURLCache sharedURLCache] removeAllCachedResponses];
                                                     
                                                     //如果请求失败会使用IP方式请求
                                                     NSMutableURLRequest *request = [YMHTTPRequestManager multipartFormRequestWithRequestSerializer:requestSerializer
                                                                                                                                          URLString:[baseIP stringByAppendingString:relativeURL]
                                                                                                                                         parameters:parameters
                                                                                                                                             images:images
                                                                                                                                        headerField:headerField];
                                                     operation = [manager HTTPRequestOperationWithRequest:request
                                                                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                                      [YMHTTPRequestManager handleResponseWhenSucceedWithAFHTTPRequestOperation:operation
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

+(NSMutableURLRequest *)multipartFormRequestWithRequestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                                        URLString:(NSString *)URLString
                                                       parameters:(NSDictionary *)parameters
                                                           images:(NSArray *)images
                                                      headerField:(NSDictionary *)headerField
{
    NSError *serializationError = nil;
    
    NSMutableURLRequest *request = [requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                           URLString:URLString
                                                                          parameters:parameters
                                                           constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                               for (int i = 0; i < images.count ; i++) {
                                                                   UIImage *image = images[i];
                                                                   NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                                                                   [formData appendPartWithFormData:imageData
                                                                                               name:[NSString stringWithFormat:@"image%d",i]];
                                                               }
                                                           }
                                                                               error:&serializationError];
    
    [headerField enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    return request;
}

+ (void)handleResponseWhenSucceedWithAFHTTPRequestOperation:(AFHTTPRequestOperation *)operation
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

@end


@implementation YMHTTPRequestOperation

@end
