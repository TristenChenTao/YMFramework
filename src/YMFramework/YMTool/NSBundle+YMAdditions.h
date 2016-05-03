//
//  NSBundle+YMAdditions.h
//  YMFramework
//
//  Created by TristenChen on 16/5/3.
//  Copyright © 2016年 cornapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (YMAdditions)

- (nullable NSString *)ym_pathForResource:(nullable NSString *)name
                                   ofType:(nullable NSString *)ext
                              inDirectory:(nullable NSString *)subpath;

@end
