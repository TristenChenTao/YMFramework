//
//  NSString+YMAdditionsForNSDate.m
//  FSCalendar
//
//  Created by Wenchao Ding on 8/29/15.
//  Copyright (c) 2015 wenchaoios. All rights reserved.
//

#import "NSString+YMAdditionsForNSDate.h"

@implementation NSString (YMAdditionsForNSDate)

- (NSDate *)ym_dateWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter dateFromString:self];
}

- (NSDate *)ym_date
{
    return [self ym_dateWithFormat:@"yyyyMMdd"];
}

@end
