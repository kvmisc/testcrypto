//
//  TKDatabase.h
//  TapKit
//
//  Created by Kevin on 5/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#if USE_SQLITE

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class TKDatabaseRow;

@interface TKDatabase : NSObject {
  NSString *_path;
  
  sqlite3 *_handle;
  BOOL _opened;
  
  
  NSLock *_lock;
}

@property (nonatomic, copy, readonly) NSString *path;

@property (nonatomic, readonly) sqlite3 *handle;
@property (nonatomic, readonly) BOOL opened;


///-------------------------------
/// Initiation
///-------------------------------

- (id)initWithPath:(NSString *)path;


+ (void)saveObject:(TKDatabase *)database;

+ (TKDatabase *)sharedObject;


///-------------------------------
/// Connection management
///-------------------------------

- (BOOL)open;

- (void)close;


///-------------------------------
/// Accessing database
///-------------------------------

- (BOOL)hasTableNamed:(NSString *)name;

- (BOOL)hasRowForSQLStatement:(NSString *)sql;


- (BOOL)executeUpdate:(NSString *)sql, ...;


- (NSArray *)executeQuery:(NSString *)sql, ...;

@end



@interface TKDatabaseRow : NSObject {
  NSArray *_nameAry;
  NSArray *_typeAry;
  NSArray *_valueAry;
}

@property (nonatomic, strong) NSArray *nameAry;
@property (nonatomic, strong) NSArray *typeAry;
@property (nonatomic, strong) NSArray *valueAry;


///-------------------------------
/// Accessing column
///-------------------------------

- (BOOL)boolForName:(NSString *)name;

- (int)intForName:(NSString *)name;

- (long long)longLongForName:(NSString *)name;

- (double)doubleForName:(NSString *)name;

- (NSDate *)dateForName:(NSString *)name;

- (NSString *)stringForName:(NSString *)name;

- (NSData *)dataForName:(NSString *)name;

@end

#endif
