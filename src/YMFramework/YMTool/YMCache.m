//
//  YMCache.m
//  YMHelper
//
//  Created by Tristen on 1/26/15.
//  Copyright (c) 2015 YM. All rights reserved.
//

#import "YMCache.h"

#import "SDImageCache.h"

@implementation YMCache

+ (void)removeImageForKey:(NSString *)key
                 fromDisk:(BOOL)fromDisk
{
    [[SDImageCache sharedImageCache] removeImageForKey:key
                                              fromDisk:fromDisk
                                        withCompletion:nil];
}

+ (void)clearCache
{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
}

+ (NSUInteger)totalCacheSize
{
    return [[SDImageCache sharedImageCache] getSize];
}

@end
