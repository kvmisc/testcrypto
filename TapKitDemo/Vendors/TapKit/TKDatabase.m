//
//  TKDatabase.m
//  TapKit
//
//  Created by Kevin on 5/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#if USE_SQLITE

#import "TKDatabase.h"
#import "TKCommon.h"
#import "NSArrayAdditions.h"
#import "NSStringAdditions.h"

#define BuildParameterAry(_box_, _stt_, _cnt_) \
if ( (_cnt_)>0 ) { \
  (_box_) = [[NSMutableArray alloc] init]; \
  va_list lst; \
  va_start(lst, (_stt_)); \
  for ( NSUInteger i=0; i<(_cnt_); ++i ) { \
    id obj = va_arg(lst, id); \
    if ( !obj ) { obj = [NSNull null]; } \
    [(_box_) addObject:obj]; \
  } \
  va_end(lst); \
}

@implementation TKDatabase

#pragma mark - Initiation

- (id)initWithPath:(NSString *)path
{
  self = [super init];
  if ( self ) {
    _path = [path copy];
    
    _handle = NULL;
    _opened = NO;
    
    
    _lock = [[NSLock alloc] init];
  }
  return self;
}


static TKDatabase *Database = nil;

+ (void)saveObject:(TKDatabase *)database
{
  Database = database;
}

+ (TKDatabase *)sharedObject
{
  return Database;
}



#pragma mark - Connection management

- (BOOL)open
{
  if ( _opened ) {
    return YES;
  }
  
  int code = sqlite3_open([_path fileSystemRepresentation], &_handle);
  _opened = ( code==SQLITE_OK );
  return _opened;
}

- (void)close
{
  if ( _handle ) {
    sqlite3_close(_handle);
    _handle = NULL;
  }
  
  _opened = NO;
}



#pragma mark - Accessing database

- (BOOL)hasTableNamed:(NSString *)name
{
  if ( [name length]>0 ) {
    if ( [self open] ) {
      NSString *sql = @"SELECT COUNT(*) AS count FROM sqlite_master WHERE type='table' AND name=?;";
      TKDatabaseRow *row = [[self executeQuery:sql, name] firstObject];
      return ( [[row stringForName:@"count"] integerValue]>0 );
    }
  }
  return NO;
}

- (BOOL)hasRowForSQLStatement:(NSString *)sql
{
  if ( [sql length]>0 ) {
    if ( [self open] ) {
      return ( [[self executeQuery:sql] count]>0 );
    }
  }
  return NO;
}


- (BOOL)executeUpdate:(NSString *)sql, ...
{
  if ( [sql length]<=0 ) {
    return NO;
  }
  
  if ( !_opened ) {
    return NO;
  }
  
  
  BOOL result = NO;
  
  [_lock lock];
  
  sqlite3_stmt *statement = NULL;
  
  if ( sqlite3_prepare(_handle, [sql UTF8String], -1, &statement, 0)==SQLITE_OK ) {
    
    NSMutableArray *parameterAry = nil;
    NSUInteger parameterCount = [sql occurTimesOfCharacter:'?'];
    
    BuildParameterAry(parameterAry, sql, parameterCount);
    
    if ( [self bindStatement:statement withParameters:parameterAry] ) {
      
      sqlite3_step(statement);
      
      if ( sqlite3_finalize(statement)==SQLITE_OK ) {
        result = YES;
      }
      
    }
    
  }
  
  [_lock unlock];
  
  return result;
}


- (NSArray *)executeQuery:(NSString *)sql, ...
{
  if ( [sql length]<=0 ) {
    return NO;
  }
  
  if ( !_opened ) {
    return NO;
  }
  
  
  NSArray *result = nil;
  
  [_lock lock];
  
  sqlite3_stmt *statement = NULL;
  
  if ( sqlite3_prepare(_handle, [sql UTF8String], -1, &statement, 0)==SQLITE_OK ) {
    
    NSMutableArray *parameterAry = nil;
    NSUInteger parameterCount = [sql occurTimesOfCharacter:'?'];
    
    BuildParameterAry(parameterAry, sql, parameterCount);
    
    if ( [self bindStatement:statement withParameters:parameterAry] ) {
      
      int columnCount = sqlite3_column_count(statement);
      
      
      NSMutableArray *nameAry = [[NSMutableArray alloc] init];
      NSMutableArray *typeAry = [[NSMutableArray alloc] init];
      
      for ( int i=0; i<columnCount; ++i ) {
        const char *cname = sqlite3_column_name(statement, i);
        if ( cname ) {
          NSString *name = [[NSString alloc] initWithUTF8String:cname];
          [nameAry addObject:name];
        } else {
          NSString *name = [[NSString alloc] initWithFormat:@"%d", i];
          [nameAry addObject:name];
        }
        
        const char *ctype = sqlite3_column_decltype(statement, i);
        if ( ctype ) {
          NSString *type = [[NSString alloc] initWithUTF8String:ctype];
          [typeAry addObject:type];
        } else {
          [typeAry addObject:@""];
        }
      }
      
      
      NSMutableArray *rowAry = [[NSMutableArray alloc] init];
      
      while ( sqlite3_step(statement)==SQLITE_ROW ) {
        
        TKDatabaseRow *row = [[TKDatabaseRow alloc] init];
        row.nameAry = nameAry;
        row.typeAry = typeAry;
        [rowAry addObject:row];
        
        NSMutableArray *valueAry = [[NSMutableArray alloc] init];
        row.valueAry = valueAry;
        
        for ( int i=0; i<columnCount; ++i ) {
          
          id object = [NSNull null];
          if ( sqlite3_column_blob(statement, i) ) {
            
            NSString *type = [[typeAry objectAtIndex:i] uppercaseString];
            
            if ( [type isEqualToString:@"INTEGER"] ) {
              sqlite3_int64 value = sqlite3_column_int64(statement, i);
              object = [[NSNumber alloc] initWithLongLong:value];
            } else if ( [type isEqualToString:@"REAL"] ) {
              double value = sqlite3_column_double(statement, i);
              object = [[NSNumber alloc] initWithDouble:value];
            } else if ( [type isEqualToString:@"BLOB"] ) {
              const void *value = sqlite3_column_blob(statement, i);
              int size = sqlite3_column_bytes(statement, i);
              object = [[NSMutableData alloc] initWithLength:size];
              memcpy([object mutableBytes], value, size);
            } else {
              const unsigned char *value = sqlite3_column_text(statement, i);
              object = [[NSString alloc] initWithFormat:@"%s", value];
            }
            
          }
          [valueAry addObject:object];
          
        }
      }
      
      if ( sqlite3_finalize(statement)==SQLITE_OK ) {
        if ( [rowAry count]>0 ) {
          result = rowAry;
        }
      }
      
    }
    
  }
  
  [_lock unlock];
  
  return result;
}



#pragma mark - Private

- (BOOL)bindStatement:(sqlite3_stmt *)statement withParameters:(NSArray *)ary
{
  int count = sqlite3_bind_parameter_count(statement);
  
  for ( NSUInteger i=0; i<[ary count]; ++i ) {
    id parameter = [ary objectAtIndex:i];
    [self bindObject:parameter toColumn:(i+1) inStatement:statement];
  }
  
  return ( [ary count]==count );
}

- (void)bindObject:(id)object toColumn:(int)index inStatement:(sqlite3_stmt *)statement
{
//  int sqlite3_bind_null(sqlite3_stmt*, int);
//  int sqlite3_bind_int64(sqlite3_stmt*, int, sqlite3_int64);
//  int sqlite3_bind_double(sqlite3_stmt*, int, double);
//  int sqlite3_bind_text(sqlite3_stmt*, int, const char*, int n, void(*)(void*));
//  int sqlite3_bind_blob(sqlite3_stmt*, int, const void*, int n, void(*)(void*));
  if ( (!object) || (object==[NSNull null]) ) {
    sqlite3_bind_null(statement, index);
  } else if ( [object isKindOfClass:[NSNumber class]] ) {
    if ( strcmp([object objCType], @encode(BOOL))==0 ) {
      sqlite3_bind_int64(statement, index, ([object boolValue] ? 1 : 0));
    } else if ( strcmp([object objCType], @encode(int))==0 ) {
      sqlite3_bind_int64(statement, index, [object intValue]);
    } else if ( strcmp([object objCType], @encode(long long))==0 ) {
      sqlite3_bind_int64(statement, index, [object longLongValue]);
    } else if ( strcmp([object objCType], @encode(double))==0 ) {
      sqlite3_bind_double(statement, index, [object doubleValue]);
    } else {
      sqlite3_bind_text(statement, index, [[object description] UTF8String], -1, SQLITE_STATIC);
    }
  } else if ( [object isKindOfClass:[NSDate class]] ) {
    sqlite3_bind_text(statement, index, [TKInternetDateString(object) UTF8String], -1, SQLITE_STATIC);
  } else if ( [object isKindOfClass:[NSString class]] ) {
    sqlite3_bind_text(statement, index, [object UTF8String], -1, SQLITE_STATIC);
  } else if ( [object isKindOfClass:[NSData class]] ) {
    sqlite3_bind_blob(statement, index, [object bytes], [object length], SQLITE_STATIC);
  } else {
    sqlite3_bind_text(statement, index, [[object description] UTF8String], -1, SQLITE_STATIC);
  }
}

@end



@implementation TKDatabaseRow

#pragma mark - Accessing column

- (BOOL)boolForName:(NSString *)name
{
  NSUInteger idx = [_nameAry indexOfObject:name];
  id object = [_valueAry objectOrNilAtIndex:idx];
  if ( TKIsInstance(object, [NSNumber class]) ) {
    return ( [object intValue]!=0 );
  }
  return NO;
}

- (int)intForName:(NSString *)name
{
  NSUInteger idx = [_nameAry indexOfObject:name];
  id object = [_valueAry objectOrNilAtIndex:idx];
  if ( TKIsInstance(object, [NSNumber class]) ) {
    return [object intValue];
  }
  return 0;
}

- (long long)longLongForName:(NSString *)name
{
  NSUInteger idx = [_nameAry indexOfObject:name];
  id object = [_valueAry objectOrNilAtIndex:idx];
  if ( TKIsInstance(object, [NSNumber class]) ) {
    return [object longLongValue];
  }
  return 0;
}

- (double)doubleForName:(NSString *)name
{
  NSUInteger idx = [_nameAry indexOfObject:name];
  id object = [_valueAry objectOrNilAtIndex:idx];
  if ( TKIsInstance(object, [NSNumber class]) ) {
    return [object doubleValue];
  }
  return 0.0;
}

- (NSDate *)dateForName:(NSString *)name
{
  NSUInteger idx = [_nameAry indexOfObject:name];
  id object = [_valueAry objectOrNilAtIndex:idx];
  if ( TKIsInstance(object, [NSString class]) ) {
    return TKInternetDateObject(object);
  }
  return nil;
}

- (NSString *)stringForName:(NSString *)name
{
  NSUInteger idx = [_nameAry indexOfObject:name];
  id object = [_valueAry objectOrNilAtIndex:idx];
  if ( TKIsInstance(object, [NSString class]) ) {
    return object;
  }
  return nil;
}

- (NSData *)dataForName:(NSString *)name
{
  NSUInteger idx = [_nameAry indexOfObject:name];
  id object = [_valueAry objectOrNilAtIndex:idx];
  if ( TKIsInstance(object, [NSData class]) ) {
    return object;
  }
  return nil;
}

@end

#endif
