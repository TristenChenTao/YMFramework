//
//  NSDate+YMAdditions.h
//  YMFramework
//
//  Created by Wenchao Ding on 29/1/15.
//
//

#import "NSDate+YMAdditions.h"

#import "NSString+YMAdditions.h"

@interface NSCalendar (YMAdditions)

+ (instancetype)ym_sharedCalendar;

@end

static NSString *kSpecialTimeZone = nil;

@implementation NSCalendar (YMAdditions)

+ (void)ym_setTimeZone:(NSString *)timeZone
{
    kSpecialTimeZone = timeZone;
}

+ (instancetype)ym_sharedCalendar
{
    static id instance;
    static dispatch_once_t fs_sharedCalendar_onceToken;
    dispatch_once(&fs_sharedCalendar_onceToken, ^{
        instance = [NSCalendar currentCalendar];
    });
    
    if ([NSString ym_isContainString:kSpecialTimeZone]) {
         [instance setTimeZone:[NSTimeZone timeZoneWithAbbreviation:kSpecialTimeZone]];
    }
    else {
        [instance setTimeZone:[NSTimeZone defaultTimeZone]];
    }
    
    return instance;
}

@end


@implementation NSDate (YMAdditions)

- (NSInteger)ym_year
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitYear
                                              fromDate:self];
    
    return component.year;
}

- (NSInteger)ym_month
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitMonth
                                              fromDate:self];
    
    return component.month;
}

- (NSInteger)ym_day
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay
                                              fromDate:self];
    
    return component.day;
}

- (NSInteger)ym_weekday
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitWeekday
                                              fromDate:self];
    
    return component.weekday;
}

- (NSInteger)ym_weekOfYear
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitWeekOfYear
                                              fromDate:self];
    
    return component.weekOfYear;
}

- (NSInteger)ym_hour
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitHour
                                              fromDate:self];
    
    return component.hour;
}

- (NSInteger)ym_minute
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitMinute
                                              fromDate:self];
    
    return component.minute;
}

- (NSInteger)ym_second
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitSecond
                                              fromDate:self];
    
    return component.second;
}

- (NSDate *)ym_dateByIgnoringTimeComponents
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth| NSCalendarUnitDay
                                               fromDate:self];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)ym_firstDayOfMonth
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                               fromDate:self];
    components.day = 1;
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)ym_lastDayOfMonth
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                               fromDate:self];
    components.month++;
    components.day = 0;
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)ym_firstDayOfWeek
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday
                                                      fromDate:self];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    componentsToSubtract.day = - (weekdayComponents.weekday - calendar.firstWeekday);
    NSDate *beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract
                                                        toDate:self
                                                       options:0];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                               fromDate:beginningOfWeek];
    beginningOfWeek = [calendar dateFromComponents:components];
    
    return beginningOfWeek;
}

- (NSDate *)ym_tomorrow
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                               fromDate:self];
    components.day++;
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)ym_yesterday
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                               fromDate:self];
    components.day--;
    
    return [calendar dateFromComponents:components];
}

- (NSInteger)ym_numberOfDaysInMonth
{
    NSCalendar *c = [NSCalendar ym_sharedCalendar];
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay
                           inUnit:NSCalendarUnitMonth
                          forDate:self];
    
    return days.length;
}

+ (instancetype)ym_dateFromString:(NSString *)string
                           format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    
    return [formatter dateFromString:string];
}

+ (instancetype)ym_dateWithYear:(NSInteger)year
                          month:(NSInteger)month
                            day:(NSInteger)day
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)ym_dateByAddingYears:(NSInteger)years
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = years;
    
    return [calendar dateByAddingComponents:components
                                     toDate:self
                                    options:0];
}

- (NSDate *)ym_dateBySubtractingYears:(NSInteger)years
{
    return [self ym_dateByAddingYears:-years];
}

- (NSDate *)ym_dateByAddingMonths:(NSInteger)months
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = months;
    
    return [calendar dateByAddingComponents:components
                                     toDate:self
                                    options:0];
}

- (NSDate *)ym_dateBySubtractingMonths:(NSInteger)months
{
    return [self ym_dateByAddingMonths:-months];
}

- (NSDate *)ym_dateByAddingWeeks:(NSInteger)weeks
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.weekOfYear = weeks;
    
    return [calendar dateByAddingComponents:components
                                     toDate:self
                                    options:0];
}

-(NSDate *)ym_dateBySubtractingWeeks:(NSInteger)weeks
{
    return [self ym_dateByAddingWeeks:-weeks];
}

- (NSDate *)ym_dateByAddingDays:(NSInteger)days
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    
    return [calendar dateByAddingComponents:components
                                     toDate:self
                                    options:0];
}

- (NSDate *)ym_dateBySubtractingDays:(NSInteger)days
{
    return [self ym_dateByAddingDays:-days];
}

- (NSInteger)ym_yearsFrom:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear
                                               fromDate:date
                                                 toDate:self
                                                options:0];
    
    return components.year;
}

- (NSInteger)ym_monthsFrom:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth
                                               fromDate:date
                                                 toDate:self
                                                options:0];
    
    return components.month;
}

- (NSInteger)ym_weeksFrom:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekOfYear
                                               fromDate:date
                                                 toDate:self
                                                options:0];
    
    return components.weekOfYear;
}

- (NSInteger)ym_daysFrom:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar ym_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay
                                               fromDate:date
                                                 toDate:self
                                                options:0];
    
    return components.day;
}

- (NSString *)ym_stringWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

- (NSString *)ym_string
{
    return [self ym_stringWithFormat:@"yyyyMMdd"];
}

- (BOOL)ym_isEqualToDateForMonth:(NSDate *)date
{
    return self.ym_year == date.ym_year && self.ym_month == date.ym_month;
}

- (BOOL)ym_isEqualToDateForWeek:(NSDate *)date
{
    return self.ym_year == date.ym_year && self.ym_weekOfYear == date.ym_weekOfYear;
}

- (BOOL)ym_isEqualToDateForDay:(NSDate *)date
{
    return self.ym_year == date.ym_year && self.ym_month == date.ym_month && self.ym_day == date.ym_day;
}

@end