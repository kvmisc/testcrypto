//
//  TKSettings.m
//  TapKit
//
//  Created by Kevin on 5/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKSettings.h"
#import "TKCommon.h"
#import "NSDictionaryAdditions.h"

@implementation TKSettings

#pragma mark - Initiation

- (id)initWithName:(NSString *)name
{
  self = [super init];
  if ( self ) {
    NSString *tmp = ([name length]>0) ? name : @"AppSettings.xml";
    _name = [tmp copy];
    
    
    NSString *path = TKPathForDocumentResource(_name);
    _settingMap = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if ( !_settingMap ) {
      _settingMap = [[NSMutableDictionary alloc] init];
    }
    
    _lock = [[NSLock alloc] init];
    
  }
  return self;
}


static TKSettings *Settings = nil;

+ (void)saveObject:(TKSettings *)object
{
  Settings = object;
}

+ (TKSettings *)sharedObject
{
  return Settings;
}



#pragma mark - Accessing values

- (id)objectForKey:(NSString *)key
{
  id object = nil;
  
  [_lock lock];
  object = [_settingMap objectForKey:key];
  [_lock unlock];
  
  return object;
}

- (void)setObject:(id)object forKey:(NSString *)key
{
  [_lock lock];
  
  if ( object ) {
    [_settingMap setObject:object forKeyIfNotNil:key];
  } else {
    [_settingMap removeObjectForKeyIfNotNil:key];
  }
  
  [_lock unlock];
}



#pragma mark - Basic routines

- (NSArray *)keys
{
  NSArray *keyAry = nil;
  
  [_lock lock];
  keyAry = [_settingMap allKeys];
  [_lock unlock];
  
  return keyAry;
}

- (void)synchronize
{
  [_lock lock];
  
  NSString *path = TKPathForDocumentResource(_name);
  [_settingMap writeToFile:path atomically:YES];
  
  [_lock unlock];
}

@end
