//
//  NSDate+SeparateColumn.h
//  Klicen
//
//  Created by luxingtong on 14-9-26.
//  Copyright (c) 2014年 Chengdu Luxingtong Electtronic Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SeparateColumn)
//获取北京时间
-(NSDate *)BeijingTime;



- (NSDate *)todayPlusDays:(int)days;

- (int)year;
- (int)month;
/**
 *  
 1 －－星期天
 2－－星期一
 3－－星期二
 4－－星期三
 5－－星期四
 6－－星期五
 7－－星期六
 *
 *  @return 
 */
- (int)week;
- (int)day;
- (int)hour;
- (int)minute;
- (int)second;
/**
 *  获取当前时间的0时时间,比如2014-09-01 12:25:30 转换为2014-09-01 00:00:00
 *
 *  @return 当前时间的0时时间
 */
- (NSDate *)zeroDate;

/**
 *  获取当前时间的最大时间,比如2014-09-01 12:25:30 转换为2014-09-01 23:59:59
 *
 *  @return 当前时间的最大时间
 */
- (NSDate *)maxDate;

/**
 *  按照格式返回时间信息
 *
 *  @param dateFormat 时间格式,如yyyy-MM-dd
 *
 *  @return 格式化之后的时间字符串
 */
- (NSString *)stringWithFormat:(NSString *)dateFormat;

+ (NSString *)timeDistanceFromNow:(NSDate *)date;

+ (NSDate *)getDateFromString:(NSString *)string withFormat:(NSString *)format;

@end
