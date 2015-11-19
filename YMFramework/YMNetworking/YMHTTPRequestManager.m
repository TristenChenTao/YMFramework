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
#import "NSString+YMAdditions.h"

@interface YMHTTPRequestManager()

@end

@implementation YMHTTPRequestManager

static const int defaultTimeout = 5;
static const NSString *resultCodeKey = @"ResultCode";
static const NSString *resultMessageKey = @"ResultMessage";
static const NSString *resultDataKey = @"Data";

static BOOL kIsReachable = YES;

+ (void)load
{
    [super load];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusNotReachable) {
            kIsReachable = NO;
        }
        else {
            kIsReachable = YES;
        }
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (YMHTTPRequestOperation *)requestWithMethodType:(YMHttpMethodType)methodType
                                      relativeURL:(NSString *)relativeURL
                                          baseURL:(NSString *)baseURL
                                           baseIP:(NSString *)baseIP
                                      headerField:(NSDictionary *)headerField
                                       parameters:(NSDictionary *)parameters
                                          timeout:(float)timeout
                                          success:(void (^)(NSURLRequest *request, NSInteger ResultCode, NSString *ResultMessage,id data))success
                                          failure:(void (^)(NSURLRequest *request, NSError *error))failure;
{
    NSMutableURLRequest *request = [YMHTTPRequestManager requestWithMethodType:methodType
                                                                    URLAddress:[baseURL stringByAppendingString:relativeURL]
                                                                       timeout:timeout
                                                                    parameters:parameters
                                                                   headerField:headerField];
    
    if (kIsReachable == NO && failure) {
        NSError *error = [NSError errorWithDomain:baseURL code:YMHttpResponseTypeForNoReachable userInfo:nil];
        failure(request,error);
        return nil;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
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

+ (NSMutableURLRequest *)requestWithMethodType:(YMHttpMethodType)methodType
                                    URLAddress:(NSString *)URLAddress
                                       timeout:(float)timeout
                                    parameters:(NSDictionary *)parameters
                                   headerField:(NSDictionary *)headerField
{
    NSString *requestType = nil;
    switch (methodType) {
        case YMHttpMethodTypeForGet:
            requestType = @"GET";
            break;
        case YMHttpMethodTypeForPost:
            requestType = @"POST";
            break;
        default:
            requestType = @"POST";
            break;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = manager.requestSerializer;
    requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    requestSerializer.timeoutInterval = defaultTimeout;
    if (timeout > 0) {
        requestSerializer.timeoutInterval = timeout;
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
                              imageNames:(NSArray *)names
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
    
    NSMutableArray *arrayForData = [NSMutableArray arrayWithCapacity:images.count];
    for (int i = 0; i < images.count ; i++) {
        UIImage *image = images[i];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        [arrayForData addObject:imageData];
    }
    
    NSMutableURLRequest *request = [YMHTTPRequestManager multipartWithURL:[baseURL stringByAppendingString:relativeURL]
                                                                  timeout:timeout
                                                               parameters:parameters
                                                                     name:names
                                                                     data:arrayForData
                                                              headerField:headerField
                                                                 mimeType:@"image/jpeg"];
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
                                                     NSMutableURLRequest *request = [YMHTTPRequestManager multipartWithURL:[baseIP stringByAppendingString:relativeURL]
                                                                                                                   timeout:timeout
                                                                                                                parameters:parameters
                                                                                                                      name:names
                                                                                                                      data:arrayForData
                                                                                                               headerField:headerField
                                                                                                                  mimeType:@"image/png"];
                                                     
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

+ (YMHTTPRequestOperation *)uploadJSONData:(NSData *)data
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
    
    NSMutableURLRequest *request = [YMHTTPRequestManager multipartWithURL:[baseURL stringByAppendingString:relativeURL]
                                                                  timeout:timeout
                                                               parameters:parameters
                                                                     name:@[@"JSON"]
                                                                     data:@[data]
                                                              headerField:headerField
                                                                 mimeType:nil];
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
                                                     NSMutableURLRequest *request = [YMHTTPRequestManager multipartWithURL:[baseIP stringByAppendingString:relativeURL]
                                                                                                                   timeout:timeout
                                                                                                                parameters:parameters
                                                                                                                      name:@[@"JSON"]
                                                                                                                      data:@[data]
                                                                                                               headerField:headerField
                                                                                                                  mimeType:nil];
                                                     
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

+ (BOOL)isReachable
{
    return kIsReachable;
}

#pragma mark - private methods

+ (NSMutableURLRequest *)multipartWithURL:(NSString *)URLAddress
                                  timeout:(float)timeout
                               parameters:(NSDictionary *)parameters
                                     name:(NSArray *)name
                                     data:(NSArray *)data
                              headerField:(NSDictionary *)headerField
                                 mimeType:(NSString *)mimeType
{
    if (name.count != data.count) {
        YM_Log(@"name.count != data.count");
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = manager.requestSerializer;
    requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    requestSerializer.timeoutInterval = defaultTimeout;
    if (timeout > 0) {
        requestSerializer.timeoutInterval = timeout;
    }
    
    parameters = [YMHTTPRequestManager packageParameters:parameters];
    
    NSMutableURLRequest *request = [requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                           URLString:URLAddress
                                                                          parameters:parameters
                                                           constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                               for (int i = 0; i < data.count ; i++) {
                                                                   
                                                                   if ([NSString ym_isContainString:mimeType]) {
                                                                       [formData appendPartWithFileData:data[i]
                                                                                                   name:name[i]
                                                                                               fileName:name[i]
                                                                                               mimeType:mimeType];
                                                                   }
                                                                   else {
                                                                       [formData appendPartWithFormData:data[i]
                                                                                                   name:name[i]];
                                                                   }
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

+ (NSDictionary *)packageParameters:(NSDictionary *)parameters
{
    NSDictionary *baseInfo = @{@"proID" : [YMFrameworkConfig sharedInstance].productID,
                               @"edition" : [YMFrameworkConfig sharedInstance].productVersion,
                               @"channel" : [YMFrameworkConfig sharedInstance].productChannel,
                               @"uid" : [YMFrameworkConfig sharedInstance].userID,
                               @"deviceId" : [YMAnalytics idfaString],
                               @"device" : [YMDeviceInfo deviceVersion],
                               @"scrH" : @(kYm_ScreenHeight),
                               @"scrW" : @(kYm_ScreenWidth),
                               @"lang" : [YMDeviceInfo language],
                               @"network" : [YMDeviceInfo newtworkType],
                               @"isCrack" : @([YMDeviceInfo isJailBroken]),
                               @"country" : [YMDeviceInfo country],
                               @"osType" : @(1)};
    
    
    NSMutableDictionary *finalParameters = [NSMutableDictionary dictionaryWithDictionary:baseInfo];
    [finalParameters addEntriesFromDictionary:parameters];
    
    return finalParameters;
}

@end

@implementation YMHTTPRequestOperation

@end