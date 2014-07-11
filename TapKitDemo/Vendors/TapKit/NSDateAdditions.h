//
//  NSDateAdditions.h
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TapKit)

///-------------------------------
/// Adjusting
///-------------------------------

- (NSDate *)dateByAddingSeconds:(NSInteger)seconds;

- (NSDate *)dateByAddingMinutes:(NSInteger)minutes;

- (NSDate *)dateByAddingHours:(NSInteger)hours;

- (NSDate *)dateByAddingDays:(NSInteger)days;


///-------------------------------
/// Comparing
///-------------------------------

- (BOOL)earlierThan:(NSDate *)date;


- (BOOL)isSameYearAsDate:(NSDate *)date;

- (BOOL)isSameMonthAsDate:(NSDate *)date;

- (BOOL)isSameDayAsDate:(NSDate *)date;

- (BOOL)isSameWeekAsDate:(NSDate *)date;


///-------------------------------
/// Date components
///-------------------------------

- (NSDateComponents *)dateComponents;

@end
