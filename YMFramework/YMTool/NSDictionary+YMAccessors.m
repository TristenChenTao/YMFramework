//
//  NSDictionary+Accessors.m
//  Belle
//
//  Created by Allen Hsu on 1/11/14.
//  Copyright (c) 2014 Allen Hsu. All rights reserved.
//

#import "NSDictionary+YMAccessors.h"

@implementation NSDictionary (YMAccessors)

- (BOOL)ym_isKindOfClass:(Class)aClass forKey:(NSString *)key
{
    id value = [self objectForKey:key];
    return [value isKindOfClass:aClass];
}

- (BOOL)ym_isMemberOfClass:(Class)aClass forKey:(NSString *)key
{
    id value = [self objectForKey:key];
    return [value isMemberOfClass:aClass];
}

- (BOOL)ym_isArrayForKey:(NSString *)key
{
    return [self ym_isKindOfClass:[NSArray class] forKey:key];
}

- (BOOL)ym_isDictionaryForKey:(NSString *)key
{
    return [self ym_isKindOfClass:[NSDictionary class] forKey:key];
}

- (BOOL)ym_isStringForKey:(NSString *)key
{
    return [self ym_isKindOfClass:[NSString class] forKey:key];
}

- (BOOL)ym_isNumberForKey:(NSString *)key
{
    return [self ym_isKindOfClass:[NSNumber class] forKey:key];
}

- (NSArray *)ym_arrayForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    
    return nil;
}

- (NSDictionary *)ym_dictionaryForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    
    return nil;
}

- (NSString *)ym_stringForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    } else if ([value respondsToSelector:@selector(description)]) {
        return [value description];
    }
    
    return nil;
}

- (NSNumber *)ym_numberForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    } else if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        return [nf numberFromString:value];
    }
    
    return nil;
}

- (double)ym_doubleForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value doubleValue];
    }
    
    return 0;
}

- (float)ym_floatForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value floatValue];
    }
    
    return 0;
}

- (int)ym_intForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value intValue];
    }
    
    return 0;
}

- (unsigned int)ym_unsignedIntForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        value = [nf numberFromString:value];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value unsignedIntValue];
    }
    
    return 0;
}

- (NSInteger)ym_integerForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }
    
    return 0;
}

- (NSUInteger)ym_unsignedIntegerForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        value = [nf numberFromString:value];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value unsignedIntegerValue];
    }
    
    return 0;
}

- (long long)ym_longLongForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value longLongValue];
    }
    
    return 0;
}

- (unsigned long long)ym_unsignedLongLongForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        value = [nf numberFromString:value];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value unsignedLongLongValue];
    }
    
    return 0;
}

- (BOOL)ym_boolForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    
    return NO;
}

@end
