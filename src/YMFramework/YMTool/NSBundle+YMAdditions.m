//
//  NSBundle+YMAdditions.m
//  YMFramework
//
//  Created by TristenChen on 16/5/3.
//  Copyright © 2016年 cornapp. All rights reserved.
//

#import "NSBundle+YMAdditions.h"

@implementation NSBundle (YMAdditions)

- (nullable NSString *)ym_pathForResource:(nullable NSString *)name
                                   ofType:(nullable NSString *)ext
                              inDirectory:(nullable NSString *)subpath
{
    NSURL *url = [self URLForResource:@"YMFramework" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithPath:[url.path stringByAppendingString:subpath]];
    
    return [imageBundle pathForResource:name ofType:ext];
}

@end
