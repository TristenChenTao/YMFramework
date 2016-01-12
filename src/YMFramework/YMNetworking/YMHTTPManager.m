//
//  YMHTTPManager.m
//  TestAFN
//
//  Created by Tristen-Macbook on 7/12/14.
//  Copyright (c) 2014 yumi. All rights reserved.
//

#import "YMHTTPManager.h"

#import "AFHTTPSessionManager.h"

#import "YMAnalytics.h"
#import "YMFrameworkConfig.h"
#import "YMDeviceInfo.h"
#import "YMUI.h"
#import "NSString+YMAdditions.h"
#import "YMHttpParameterFactory.h"

@implementation YMHTTPManager

static const int defaultTimeout = 5;

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

+ (BOOL)isReachable
{
    return kIsReachable;
}

+ (NSURLSessionDataTask *)GET:(NSString *)relativeURL
                      baseURL:(NSString *)baseURL
                       baseIP:(NSString *)baseIP
                   parameters:(NSDictionary *)parameters
                      timeout:(float)timeout
                     progress:(void (^)(NSProgress *progress)) downloadProgress
                      success:(void (^)(NSURLSessionDataTask *task, YMHTTPResponseData *responseData))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = [YMHTTPManager prepareForTimeout:timeout];
    NSDictionary *finalParameters = [YMHTTPManager packageParameters:parameters];
    __block NSURLSessionDataTask *task;
    task = [manager GET:[baseURL stringByAppendingString:relativeURL]
             parameters:finalParameters
               progress:downloadProgress
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [YMHTTPManager handleSucceedResponse:responseObject
                                      URLSessionDataTask:task
                                                 success:success];
                }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    task = [manager GET:[baseIP stringByAppendingString:relativeURL]
                             parameters:finalParameters
                               progress:downloadProgress
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    [YMHTTPManager handleSucceedResponse:responseObject
                                                      URLSessionDataTask:task
                                                                 success:success];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    [YMHTTPManager handleFailureTask:task
                                                               error:error
                                                             failure:failure];
                                }];
                }];
    
    return task;
}

+ (NSURLSessionDataTask *)POST:(NSString *)relativeURL
                       baseURL:(NSString *)baseURL
                        baseIP:(NSString *)baseIP
                    parameters:(NSDictionary *)parameters
                       timeout:(float)timeout
                      progress:(void (^)(NSProgress *progress)) downloadProgress
                       success:(void (^)(NSURLSessionDataTask *task, YMHTTPResponseData *responseData))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = [YMHTTPManager prepareForTimeout:timeout];
    NSDictionary *finalParameters = [YMHTTPManager packageParameters:parameters];
    __block NSURLSessionDataTask *task = nil;
    task = [manager POST:[baseURL stringByAppendingString:relativeURL]
              parameters:finalParameters
                progress:downloadProgress
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     [YMHTTPManager handleSucceedResponse:responseObject
                                       URLSessionDataTask:task
                                                  success:success];
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     task = [manager POST:[baseIP stringByAppendingString:relativeURL]
                               parameters:finalParameters
                                 progress:downloadProgress
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      [YMHTTPManager handleSucceedResponse:responseObject
                                                        URLSessionDataTask:task
                                                                   success:success];
                                  }
                                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      [YMHTTPManager handleFailureTask:task
                                                                 error:error
                                                               failure:failure];
                                  }];
                 }];
    
    return task;
}

+ (NSMutableURLRequest *)requestWithMethodType:(YMHttpRequestType)requestType
                                    URLAddress:(NSString *)URLAddress
                                       timeout:(float)timeout
                                    parameters:(NSDictionary *)parameters
{
    NSString *requestTypeString = nil;
    switch (requestType) {
        case YMHttpRequestTypeForGet:
            requestTypeString = @"GET";
            break;
        case YMHttpRequestTypeForPost:
            requestTypeString = @"POST";
            break;
        default:
            requestTypeString = @"POST";
            break;
    }
    
    AFHTTPSessionManager *manager = [YMHTTPManager prepareForTimeout:timeout];
    NSDictionary *finalParameters = [YMHTTPManager packageParameters:parameters];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:requestTypeString
                                                                      URLString:URLAddress
                                                                     parameters:finalParameters
                                                                          error:nil];
    return request;
}

+ (NSURLSessionDataTask *)uploadImages:(NSArray *)images
                            imageNames:(NSArray *)names
                           relativeURL:(NSString *)relativeURL
                               baseURL:(NSString *)baseURL
                                baseIP:(NSString *)baseIP
                            parameters:(NSDictionary *)parameters
                               timeout:(float)timeout
                              progress:(void (^)(NSProgress *progress))uploadProgress
                               success:(void (^)(NSURLSessionDataTask *task, YMHTTPResponseData *responseData))success
                               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    if (images.count != names.count) {
        YM_Log(@"name.count != data.count");
        return nil;
    }
    
    AFHTTPSessionManager *manager = [YMHTTPManager prepareForTimeout:timeout];
    NSDictionary *finalParameters = [YMHTTPManager packageParameters:parameters];
    __block NSURLSessionDataTask *task = nil;
    
    NSMutableArray *arrayForData = [NSMutableArray arrayWithCapacity:images.count];
    for (int i = 0; i < images.count ; i++) {
        UIImage *image = images[i];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        [arrayForData addObject:imageData];
    }
    
    task = [manager POST:[baseURL stringByAppendingString:relativeURL]
              parameters:finalParameters
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    for (int i = 0; i < arrayForData.count ; i++) {
        [formData appendPartWithFileData:arrayForData[i]
                                    name:names[i]
                                fileName:names[i]
                                mimeType:@"image/jpeg"];
    }
}
                progress:uploadProgress
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     [YMHTTPManager handleSucceedResponse:responseObject
                                       URLSessionDataTask:task
                                                  success:success];
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     task = [manager POST:[baseIP stringByAppendingString:relativeURL]
                               parameters:finalParameters
                constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    for (int i = 0; i < arrayForData.count ; i++) {
                        [formData appendPartWithFileData:arrayForData[i]
                                                    name:names[i]
                                                fileName:names[i]
                                                mimeType:@"image/jpeg"];
                    }}
                                 progress:uploadProgress
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      [YMHTTPManager handleSucceedResponse:responseObject
                                                        URLSessionDataTask:task
                                                                   success:success];
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      [YMHTTPManager handleFailureTask:task
                                                                 error:error
                                                               failure:failure];
                                  }];
                 }];
    return task;
}

+ (NSURLSessionDataTask *)uploadJSONData:(NSData *)data
                             relativeURL:(NSString *)relativeURL
                                 baseURL:(NSString *)baseURL
                                  baseIP:(NSString *)baseIP
                              parameters:(NSDictionary *)parameters
                                 timeout:(float)timeout
                                progress:(void (^)(NSProgress *progress))uploadProgress
                                 success:(void (^)(NSURLSessionDataTask *task, YMHTTPResponseData *responseData))success
                                 failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    if (data == nil) {
        YM_Log(@"uploadJSONData == nil");
        return nil;
    }
    
    AFHTTPSessionManager *manager = [YMHTTPManager prepareForTimeout:timeout];
    NSDictionary *finalParameters = [YMHTTPManager packageParameters:parameters];
    __block NSURLSessionDataTask *task = nil;
    
    task = [manager POST:[baseURL stringByAppendingString:relativeURL]
              parameters:finalParameters
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    [formData appendPartWithFormData:data
                                name:@"JSON"];
}
                progress:uploadProgress
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     [YMHTTPManager handleSucceedResponse:responseObject
                                       URLSessionDataTask:task
                                                  success:success];
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     task = [manager POST:[baseIP stringByAppendingString:relativeURL]
                               parameters:finalParameters
                constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    [formData appendPartWithFormData:data
                                                name:@"JSON"];
                }
                                 progress:uploadProgress
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      [YMHTTPManager handleSucceedResponse:responseObject
                                                        URLSessionDataTask:task
                                                                   success:success];
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      [YMHTTPManager handleFailureTask:task
                                                                 error:error
                                                               failure:failure];
                                  }];
                 }];
    return task;
    
}


+ (NSDictionary *)packageParameters:(NSDictionary *)parameters
{
    
    NSMutableDictionary *finalParameters = [NSMutableDictionary dictionaryWithDictionary:[YMHttpParameterFactory creatProductInfo]];
    [finalParameters addEntriesFromDictionary:parameters];
    
    return finalParameters;
}

+ (AFHTTPSessionManager *)prepareForTimeout:(float)timeout
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    if (timeout > 0) {
        configuration.timeoutIntervalForRequest = timeout;
    }
    else {
        configuration.timeoutIntervalForRequest = defaultTimeout;
    }
    
    return [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
}

+ (void)handleSucceedResponse:(id  _Nullable)responseObject
           URLSessionDataTask:(NSURLSessionDataTask *)task
                      success:(void (^)(NSURLSessionDataTask *task, YMHTTPResponseData *responseData))success
{
    if (success) {
        success(task,[[YMHTTPResponseData alloc] initWithData:responseObject]);
    }
}

+ (void)handleFailureTask:(NSURLSessionDataTask *)task
                    error:(NSError *)error
                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    if (failure) {
        if (kIsReachable == NO) {
            NSError *newError = [NSError errorWithDomain:@"" code:YMHTTPResponseStateForNoReachable userInfo:nil];
            failure(task,newError);
        }
        else {
            failure(task, error);
        }
    }
}

@end