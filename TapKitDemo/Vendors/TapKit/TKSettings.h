//
//  TKSettings.h
//  TapKit
//
//  Created by Kevin on 5/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKSettings : NSObject {
  NSString *_name;
  
  
  NSMutableDictionary *_settingMap;
  
  NSLock *_lock;
}

@property (nonatomic, copy, readonly) NSString *name;


///-------------------------------
/// Initiation
///-------------------------------

- (id)initWithName:(NSString *)name;


+ (void)saveObject:(TKSettings *)object;

+ (TKSettings *)sharedObject;


///-------------------------------
/// Accessing values
///-------------------------------

- (id)objectForKey:(NSString *)key;

- (void)setObject:(id)object forKey:(NSString *)key;


///-------------------------------
/// Basic routines
///-------------------------------

- (NSArray *)keys;

- (void)synchronize;

@end
