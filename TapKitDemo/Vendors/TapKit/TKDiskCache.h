//
//  TKDiskCache.h
//  TapKit
//
//  Created by Kevin on 5/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TKDiskCacheItem;

@interface TKDiskCache : NSObject {
  NSString *_name;
  
  
  NSMutableArray *_itemAry;
  
  NSLock *_lock;
}

@property (nonatomic, copy, readonly) NSString *name;


///-------------------------------
/// Initiation
///-------------------------------

- (id)initWithName:(NSString *)name;


+ (void)saveObject:(TKDiskCache *)object;

+ (TKDiskCache *)sharedObject;


///-------------------------------
/// Accessing caches
///-------------------------------

- (void)addCacheItem:(TKDiskCacheItem *)item;

- (BOOL)setData:(NSData *)data forKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;


- (void)removeCacheForKey:(NSString *)key;


- (BOOL)hasCacheForKey:(NSString *)key;

- (NSData *)dataForKey:(NSString *)key;


///-------------------------------
/// Reorganize cache
///-------------------------------

- (NSArray *)keys;


- (void)clearCaches;

- (void)cleanCaches;


- (void)synchronize;


- (int)cacheSize;


///-------------------------------
/// Paths
///-------------------------------

- (NSString *)cachePathForKey:(NSString *)key;

@end



@interface TKDiskCacheItem : NSObject<
    NSCoding
> {
  NSString *_key;
  NSString *_path;
  NSDate *_expiry;
  int _size;
}

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSDate *expiry;
@property (nonatomic, assign) int size;

///-------------------------------
/// Validity
///-------------------------------

- (BOOL)nonempty;

- (BOOL)expired;

@end
