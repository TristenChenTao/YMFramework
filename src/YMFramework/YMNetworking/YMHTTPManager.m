//
//  YMHTTPManager.m
//  TestAFN
//
//  Created by Tristen-Macbook on 7/12/14.
//  Copyright (c) 2014 yumi. All rights reserved.
//

#import "YMHTTPManager.h"
#import "YMHTTPResponseData.h"

#import "AFHTTPSessionManager.h"

#import "YMAnalytics.h"
#import "YMFrameworkConfig.h"
#import "YMDeviceInfo.h"
#import "YMUI.h"
#import "NSString+YMAdditions.h"

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

+ (NSURLSessionDataTask *)GET:(NSString *)relativeURL
                      baseURL:(NSString *)baseURL
                       baseIP:(NSString *)baseIP
                   parameters:(NSDictionary *)parameters
                      timeout:(float)timeout
                     progress:(void (^)(NSProgress *downloadProgress)) downloadProgress
                      success:(void (^)(NSURLSessionDataTask *task, YMHTTPResponseData *responseData))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    if (timeout > 0) {
        configuration.timeoutIntervalForRequest = timeout;
    }
    else {
        configuration.timeoutIntervalForRequest = defaultTimeout;
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    NSDictionary *finalParameters = [YMHTTPManager packageParameters:parameters];
    NSURLSessionDataTask *task;
    task = [manager GET:[baseURL stringByAppendingString:relativeURL]
             parameters:finalParameters
               progress:downloadProgress
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if (success) {
                        [YMHTTPManager handleSucceedResponse:responseObject
                                          URLSessionDataTask:task
                                                     success:success];
                    }
                }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    task = [manager GET:[baseIP stringByAppendingString:relativeURL]
                             parameters:finalParameters
                               progress:downloadProgress
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    if (success) {
                                        [YMHTTPManager handleSucceedResponse:responseObject
                                                          URLSessionDataTask:task
                                                                     success:success];
                                    }
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    if (failure) {
                                        if (kIsReachable == NO) {
                                            NSError *newError = [NSError errorWithDomain:baseURL code:YMHTTPResponseStateForNoReachable userInfo:nil];
                                            failure(task,newError);
                                        }
                                        else {
                                            failure(task, error);
                                        }
                                    }
                                }];
                }];
    
    return task;
}

+ (NSURLSessionDataTask *)POST:(NSString *)relativeURL
                       baseURL:(NSString *)baseURL
                        baseIP:(NSString *)baseIP
                    parameters:(NSDictionary *)parameters
                       timeout:(float)timeout
                      progress:(void (^)(NSProgress *downloadProgress)) downloadProgress
                       success:(void (^)(NSURLSessionDataTask *task, YMHTTPResponseData *responseData))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    if (timeout > 0) {
        configuration.timeoutIntervalForRequest = timeout;
    }
    else {
        configuration.timeoutIntervalForRequest = defaultTimeout;
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    NSDictionary *finalParameters = [YMHTTPManager packageParameters:parameters];
    NSURLSessionDataTask *task = nil;
    task = [manager POST:[baseURL stringByAppendingString:relativeURL]
              parameters:finalParameters
                progress:downloadProgress
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if (success) {
                         [YMHTTPManager handleSucceedResponse:responseObject
                                           URLSessionDataTask:task
                                                      success:success];
                     }
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     task = [manager POST:[baseIP stringByAppendingString:relativeURL]
                               parameters:finalParameters
                                 progress:downloadProgress
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      if (success) {
                                          [YMHTTPManager handleSucceedResponse:responseObject
                                                            URLSessionDataTask:task
                                                                       success:success];
                                      }
                                  }
                                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      if (failure) {
                                          if (kIsReachable == NO) {
                                              NSError *newError = [NSError errorWithDomain:baseURL code:YMHTTPResponseStateForNoReachable userInfo:nil];
                                              failure(task,newError);
                                          }
                                          else {
                                              failure(task, error);
                                          }
                                      }
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
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    if (timeout > 0) {
        configuration.timeoutIntervalForRequest = timeout;
    }
    else {
        configuration.timeoutIntervalForRequest = defaultTimeout;
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
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
                               success:(void (^)(NSURLSessionDataTask *task, YMHTTPResponseData *responseData))success
                               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    if (timeout > 0) {
        configuration.timeoutIntervalForRequest = timeout;
    }
    else {
        configuration.timeoutIntervalForRequest = defaultTimeout;
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    NSDictionary *finalParameters = [YMHTTPManager packageParameters:parameters];
    NSURLSessionDataTask *task = nil;
    
    NSMutableArray *arrayForData = [NSMutableArray arrayWithCapacity:images.count];
    for (int i = 0; i < images.count ; i++) {
        UIImage *image = images[i];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        [arrayForData addObject:imageData];
    }
    
    task = [manager POST:[baseURL stringByAppendingString:relativeURL]
              parameters:finalParameters
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    //继续
}
                progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                }
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     
                 }];
    
    return task;
    
    
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
                               @"osType" : @(1),
                               @"osVer" : @([YMDeviceInfo systemVersion])
                               };
    
    
    NSMutableDictionary *finalParameters = [NSMutableDictionary dictionaryWithDictionary:baseInfo];
    [finalParameters addEntriesFromDictionary:parameters];
    
    return finalParameters;
}

+ (void)handleSucceedResponse:(id  _Nullable)responseObject
           URLSessionDataTask:(NSURLSessionDataTask *)task
                      success:(void (^)(NSURLSessionDataTask *task, YMHTTPResponseData *responseData))success
{
    
    if (success) {
        success(task,[[YMHTTPResponseData alloc] initWithData:responseObject]);
    }
}

+ (BOOL)isReachable
{
    return kIsReachable;
}

@end