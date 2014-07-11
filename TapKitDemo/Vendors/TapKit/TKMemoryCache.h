//
//  TKMemoryCache.h
//  TapKitDemo
//
//  Created by Kevin on 7/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TKMemoryCacheItem;

@interface TKMemoryCache : NSObject {
  NSMutableArray *_itemAry;
  
  NSLock *_lock;
}


///-------------------------------
/// Initiation
///-------------------------------

+ (void)saveObject:(TKMemoryCache *)object;

+ (TKMemoryCache *)sharedObject;


///-------------------------------
/// Accessing caches
///-------------------------------

- (void)addCacheItem:(TKMemoryCacheItem *)item;

- (BOOL)setObject:(id)object forKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;


- (void)removeCacheForKey:(NSString *)key;


- (BOOL)hasCacheForKey:(NSString *)key;

- (id)objectForKey:(NSString *)key;


///-------------------------------
/// Reorganize cache
///-------------------------------

- (NSArray *)keys;


- (void)clearCaches;

- (void)cleanCaches;

@end



@interface TKMemoryCacheItem : NSObject {
  NSString *_key;
  NSDate *_expiry;
  id _object;
}

@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) NSDate *expiry;
@property (nonatomic, strong) id object;

///-------------------------------
/// Validity
///-------------------------------

- (BOOL)nonempty;

- (BOOL)expired;

@end
