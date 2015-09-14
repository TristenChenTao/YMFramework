//
//  YMDebugging.h
//  YMFramework
//
//  Created by 涛 陈 on 5/29/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YMTool.h"

@interface YMDebugging : NSObject

@property (nonatomic, assign)BOOL networkDebuggingEnabled;

YM_MacrosSingletonInterface

- (void)showExplorer;

@end
