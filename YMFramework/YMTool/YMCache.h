//
//  YMCache.h
//  YMHelper
//
//  Created by Tristen on 1/26/15.
//  Copyright (c) 2015 YM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMCache : NSObject

+ (void)removeImageForKey:(NSString *)key
                 fromDisk:(BOOL)fromDisk;

+ (void)clearCache;

+ (NSUInteger)totalCacheSize;

@end
