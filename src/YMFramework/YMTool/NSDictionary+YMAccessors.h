//
//  NSDictionary+Accessors.h
//  Belle
//
//  Created by Allen Hsu on 1/11/14.
//  Copyright (c) 2014 Allen Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YMAccessors)

- (BOOL)ym_isKindOfClass:(Class)aClass forKey:(NSString *)key;
- (BOOL)ym_isMemberOfClass:(Class)aClass forKey:(NSString *)key;
- (BOOL)ym_isArrayForKey:(NSString *)key;
- (BOOL)ym_isDictionaryForKey:(NSString *)key;
- (BOOL)ym_isStringForKey:(NSString *)key;
- (BOOL)ym_isNumberForKey:(NSString *)key;

- (NSArray *)ym_arrayForKey:(NSString *)key;
- (NSDictionary *)ym_dictionaryForKey:(NSString *)key;
- (NSString *)ym_stringForKey:(NSString *)key;
- (NSNumber *)ym_numberForKey:(NSString *)key;
- (double)ym_doubleForKey:(NSString *)key;
- (float)ym_floatForKey:(NSString *)key;

- (int)ym_intForKey:(NSString *)key;
- (unsigned int)ym_unsignedIntForKey:(NSString *)key;
- (NSInteger)ym_integerForKey:(NSString *)key;
- (NSUInteger)ym_unsignedIntegerForKey:(NSString *)key;
- (long long)ym_longLongForKey:(NSString *)key;
- (unsigned long long)ym_unsignedLongLongForKey:(NSString *)key;
- (BOOL)ym_boolForKey:(NSString *)key;

@end
