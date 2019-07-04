//
//  NSDate+SeparateColumn.m
//  jkjk
//
//  Created by luxingtong on 14-9-26.
//  Copyright (c) 2014年 Chengdu Luxingtong Electtronic Co. Ltd. All rights reserved.
//

#import "NSDate+SeparateColumn.h"

@implementation NSDate (SeparateColumn)

//获取北京时间
-(NSDate *)BeijingTime {
    //从iOS4.1开始,[NSDate date]为GMT(格林威治标准时间),这个时间和北京时间相差8个小时
    NSDate *date = [NSDate date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: 3600*8];
    return localeDate;
}

- (NSDate *)todayPlusDays:(int)days{
    NSDate *date = [NSDate date];
    NSDate *localeDate = [date dateByAddingTimeInterval: 3600*24*days];
    return localeDate;

}

- (int)year
{
    return (int)[[self getCurrentComponents] year];
}
- (int)month
{
    return (int)[[self getCurrentComponents] month];
}
- (int)week
{
    return (int)[[self getCurrentComponents] weekday];
}
- (int)day
{
    return (int)[[self getCurrentComponents] day];
}
- (int)hour
{
    return (int)[[self getCurrentComponents] hour];
}
- (int)minute
{
    return (int)[[self getCurrentComponents] minute];
}
- (int)second
{
    return (int)[[self getCurrentComponents] second];
}

static NSCalendar *calendar;
static NSDateComponents *comps;
- (NSDateComponents *)getCurrentComponents
{
    if (calendar == nil) {
        calendar = [NSCalendar currentCalendar];
    }
    if (comps == nil) {
        comps = [[NSDateComponents alloc] init];
    }
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:self];
    
    return comps;
}

/**
 *  获取当前时间的0时时间,比如2014-09-01 12:25:30 转换为2014-09-01 00:00:00
 *
 *  @return 当前时间的0时时间
 */
- (NSDate *)zeroDate
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:self];
    
    [components setHour:0];
    
    [components setMinute:0];
    
    [components setSecond:0];
    
    NSDate *morningStart = [calendar dateFromComponents:components];
    
    return morningStart;
}

/**
 *  获取当前时间的最大时间,比如2014-09-01 12:25:30 转换为2014-09-01 23:59:59
 *
 *  @return 当前时间的最大时间
 */
- (NSDate *)maxDate
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:self];
    
    [components setHour:23];
    
    [components setMinute:59];
    
    [components setSecond:59];
    
    NSDate *morningStart = [calendar dateFromComponents:components];
    
    return morningStart;
}

/**
 *  按照格式返回时间信息
 *
 *  @param dateFormat 时间格式,如yyyy-MM-dd
 *
 *  @return 格式化之后的时间字符串
 */
- (NSString *)stringWithFormat:(NSString *)dateFormat
{
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.calendar = [NSCalendar currentCalendar];
    fmt.dateFormat = dateFormat;
    return [fmt stringFromDate:self];
}

+ (NSString *)timeDistanceFromNow:(NSDate *)date
{
    NSTimeInterval timeDistance = - date.timeIntervalSinceNow;
    
    int secendInMin = 60;
    int secendInHour = 60*secendInMin;
    int secendInDay = secendInHour*24;
    int secendInMonth = secendInDay*30;
    int secendInYear = 12*secendInMonth;
    
    if ((int)timeDistance/secendInYear > 0) {
        return [NSString stringWithFormat:@"%d年前",(int)timeDistance/secendInYear];
    } else if ((int)timeDistance/secendInMonth > 0){
        return [NSString stringWithFormat:@"%d月前",(int)timeDistance/secendInMonth];
    } else if ((int)timeDistance/secendInDay > 0){
        return [NSString stringWithFormat:@"%d天前",(int)timeDistance/secendInDay];
    } else if ((int)timeDistance/secendInHour > 0){
        return [NSString stringWithFormat:@"%d小时前",(int)timeDistance/secendInHour];
    } else if ((int)timeDistance/secendInMin > 0){
        return [NSString stringWithFormat:@"%d分钟前",(int)timeDistance/secendInMin];
    } else {
        return @"现在";
    }
    

}


+ (NSDate *)getDateFromString:(NSString *)string withFormat:(NSString *)format
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = format;
    
    return [fmt dateFromString:string];

}


@end
