//
//  NSDate+YMAdditions.h
//  YMFramework
//
//  Created by Wenchao Ding on 29/1/15.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (YMAdditions)

@property (readonly, nonatomic) NSInteger ym_year;
@property (readonly, nonatomic) NSInteger ym_month;
@property (readonly, nonatomic) NSInteger ym_day;
@property (readonly, nonatomic) NSInteger ym_weekday;
@property (readonly, nonatomic) NSInteger ym_weekOfYear;
@property (readonly, nonatomic) NSInteger ym_hour;
@property (readonly, nonatomic) NSInteger ym_minute;
@property (readonly, nonatomic) NSInteger ym_second;

@property (readonly, nonatomic) NSDate *ym_dateByIgnoringTimeComponents;
@property (readonly, nonatomic) NSDate *ym_firstDayOfMonth;
@property (readonly, nonatomic) NSDate *ym_lastDayOfMonth;
@property (readonly, nonatomic) NSDate *ym_firstDayOfWeek;
@property (readonly, nonatomic) NSDate *ym_tomorrow;
@property (readonly, nonatomic) NSDate *ym_yesterday;
@property (readonly, nonatomic) NSInteger ym_numberOfDaysInMonth;


+ (void)ym_setSpecialTimeZone:(NSString *)timeZone;

+ (instancetype)ym_dateFromString:(NSString *)string
                           format:(NSString *)format;

+ (instancetype)ym_dateWithYear:(NSInteger)year
                          month:(NSInteger)month
                            day:(NSInteger)day;
//获得指定N年后的日期
- (NSDate *)ym_dateByAddingYears:(NSInteger)years;
//获得指定N年前的日期
- (NSDate *)ym_dateBySubtractingYears:(NSInteger)years;
//获得指定N月后的日期
- (NSDate *)ym_dateByAddingMonths:(NSInteger)months;
//获得指定N月前的日期
- (NSDate *)ym_dateBySubtractingMonths:(NSInteger)months;
//获得指定N个礼拜后的日期
- (NSDate *)ym_dateByAddingWeeks:(NSInteger)weeks;
//获得指定N个礼拜前的日期
- (NSDate *)ym_dateBySubtractingWeeks:(NSInteger)weeks;
//获得指定N天后的日期
- (NSDate *)ym_dateByAddingDays:(NSInteger)days;
//获得指定N天前的日期
- (NSDate *)ym_dateBySubtractingDays:(NSInteger)days;
//获得指定日期和当前年份的年份差
- (NSInteger)ym_yearsFrom:(NSDate *)date;
//获得指定日期和当前年份的月份差
- (NSInteger)ym_monthsFrom:(NSDate *)date;
//获得指定日期和当前年份的礼拜差
- (NSInteger)ym_weeksFrom:(NSDate *)date;
//获得指定日期和当前年份的天数差
- (NSInteger)ym_daysFrom:(NSDate *)date;

//判断指定日期和当前日期是否同一月份
- (BOOL)ym_isEqualToDateForMonth:(NSDate *)date;
//判断指定日期和当前日期是否同一礼拜
- (BOOL)ym_isEqualToDateForWeek:(NSDate *)date;
//判断指定日期和当前日期是否同一天
- (BOOL)ym_isEqualToDateForDay:(NSDate *)date;

//根据指定格式将当前日期格式化
- (NSString *)ym_stringWithFormat:(NSString *)format;
//根据yyyyMMdd格式将当前日期格式化
- (NSString *)ym_string;

@end

