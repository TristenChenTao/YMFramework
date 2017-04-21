//
//  NSString+YMAdditions.m
//  YMFramework
//
//  Created by 涛 陈 on 4/14/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
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

- (BOOL)ym_isContainsEmoji
{
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

- (NSString *)ym_MD5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (BOOL)ym_isMobileNumber
{
    if (self.length != 11) {
        return NO;
    }
    
    NSString *regex =@"[0-9]*";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regextestmobile evaluateWithObject:self];

}

@end
