//
//  NSDateAdditions.m
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "NSDateAdditions.h"

@implementation NSDate (TapKit)

#pragma mark - Adjusting

- (NSDate *)dateByAddingSeconds:(NSInteger)seconds
{
  NSTimeInterval timeInterval = [self timeIntervalSinceReferenceDate] + seconds;
  return [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:timeInterval];
}

- (NSDate *)dateByAddingMinutes:(NSInteger)minutes
{
  NSTimeInterval timeInterval = [self timeIntervalSinceReferenceDate] + minutes * (60.0);
  return [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:timeInterval];
}

- (NSDate *)dateByAddingHours:(NSInteger)hours
{
  NSTimeInterval timeInterval = [self timeIntervalSinceReferenceDate] + hours * (60*60.0);
  return [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:timeInterval];
}

- (NSDate *)dateByAddingDays:(NSInteger)days
{
  NSTimeInterval timeInterval = [self timeIntervalSinceReferenceDate] + days * (24*60*60.0);
  return [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:timeInterval];
}



#pragma mark - Comparing

- (BOOL)earlierThan:(NSDate *)date
{
  return ( [self earlierDate:date]==self );
}


- (BOOL)isSameYearAsDate:(NSDate *)date
{
  NSDateComponents *components1 = [self dateComponents];
  NSDateComponents *components2 = [date dateComponents];
  return ( [components1 year]==[components2 year] );
}

- (BOOL)isSameMonthAsDate:(NSDate *)date
{
  NSDateComponents *components1 = [self dateComponents];
  NSDateComponents *components2 = [date dateComponents];
  return (([components1 year]==[components2 year])
          && ([components1 month]==[components2 month])
          );
}

- (BOOL)isSameDayAsDate:(NSDate *)date
{
  NSDateComponents *components1 = [self dateComponents];
  NSDateComponents *components2 = [date dateComponents];
  return (([components1 year]==[components2 year])
          && ([components1 month]==[components2 month])
          && ([components1 day]==[components2 day])
          );
}

- (BOOL)isSameWeekAsDate:(NSDate *)date
{
  NSDateComponents *components1 = [self dateComponents];
  NSDateComponents *components2 = [date dateComponents];
  
  // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
  if ( [components1 week]!=[components2 week] ) {
    return NO;
  }
  
  // Must have a time interval under 1 week.
  return ( abs([self timeIntervalSinceDate:date])<(60.0*60*24*7) );
}



#pragma mark - Date components

- (NSDateComponents *)dateComponents
{
  NSCalendarUnit calendarUnit =
                    NSEraCalendarUnit
                  | NSYearCalendarUnit
                  | NSMonthCalendarUnit
                  | NSDayCalendarUnit
                  | NSHourCalendarUnit
                  | NSMinuteCalendarUnit
                  | NSSecondCalendarUnit
                  | NSWeekCalendarUnit
                  | NSWeekdayCalendarUnit
                  | NSWeekdayOrdinalCalendarUnit
                  | NSQuarterCalendarUnit
                  | NSWeekOfMonthCalendarUnit
                  | NSWeekOfYearCalendarUnit
                  | NSYearForWeekOfYearCalendarUnit
                  | NSCalendarCalendarUnit
                  | NSTimeZoneCalendarUnit;
  return [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];
}

@end
