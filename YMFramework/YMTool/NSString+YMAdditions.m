//
//  NSString+YMAdditions.m
//  YMFramework
//
//  Created by 涛 陈 on 4/14/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import "NSString+YMAdditions.h"

#import "URLParser.h"

@implementation NSString (YMAdditions)

+ (BOOL)ym_isEmptyString:(NSString *)string;
{
    if (string == nil || ![string isKindOfClass:[NSString class]] || string.length == 0) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)ym_isContainString:(NSString *)string
{
    if (string != nil && [string isKindOfClass:[NSString class]] && string.length > 0) {
        return YES;
    }
    
    return NO;
}

+ (NSString *)ym_trim:(NSString *)string;
{
    NSString *tempText = [string copy];
    tempText = [tempText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tempText = [tempText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    tempText = [tempText stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    return tempText;
}

- (NSString *)ym_urlEncode
{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)ym_urlDecode
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)ym_randomStringWithLength:(NSInteger)len
{
    static const NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length]) % [letters length]]];
    }
    
    return randomString;
}

- (NSString *)ym_parameterForKeyFromURL:(NSString *)key
{
    URLParser *parser = [[URLParser alloc] initWithURLString:self];
    return [parser valueForVariable:key];
}

- (BOOL)ym_isWebURL
{
    if ([NSString ym_isEmptyString:self]) {
        return NO;
    }
    
    NSString *regex1 = @"(http(s)?://)?([\\w-]+\\.)+[\\w-]+([:\\d]*)?+(/[\\w- ;,./?%&=]*)?";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex1];
    if ([regextestmobile evaluateWithObject:self]) {
        return YES;
    }
    
    NSString *regex2 = @"[a-zA-z]+://[^\\s]*";
    
    regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if ([regextestmobile evaluateWithObject:self]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)ym_isAppStoreURL
{
    if ([NSString ym_isEmptyString:self]) {
        return NO;
    }
    
    if ([self rangeOfString:@"itunes.apple.com"].length > 0 && [self rangeOfString:@"?mt=8"].length > 0) {
        return YES;
    }
    
    return NO;
}

@end
