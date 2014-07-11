//
//  TKDiskCache.m
//  TapKit
//
//  Created by Kevin on 5/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKDiskCache.h"
#import "TKCommon.h"
#import "NSDateAdditions.h"

@implementation TKDiskCache

#pragma mark - Initiation

- (id)initWithName:(NSString *)name;
{
  self = [super init];
  if ( self ) {
    NSString *tmp = ([name length]>0) ? name : @"Caches";
    _name = [tmp copy];
    [self createDirectoryIfNeeded];
    
    NSString *path = [self cachePathForKey:@"profile.dat"];
    NSArray *itemAry = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    _itemAry = [self cleanCaches:itemAry];
    
    
    _lock = [[NSLock alloc] init];
    
  }
  return self;
}


static TKDiskCache *DiskCache = nil;

+ (void)saveObject:(TKDiskCache *)object
{
  DiskCache = object;
}

+ (TKDiskCache *)sharedObject
{
  return DiskCache;
}



#pragma mark - Accessing caches

- (void)addCacheItem:(TKDiskCacheItem *)item
{
  if ( !item ) {
    return;
  }
  
  
  if ( [item.key length]<=0 ) {
    return;
  }
  
  if ( [item.path length]<=0 ) {
    return;
  } else {
    if ( ![item.path isEqualToString:[self cachePathForKey:item.key]] ) {
      return;
    }
  }
  
  if ( !(item.expiry) ) {
    return;
  } else {
    if ( [item.expiry earlierThan:[NSDate date]] ) {
      return;
    }
  }
  
  
  [_lock lock];
  [_itemAry addObject:item];
  [_lock unlock];
  
}

- (BOOL)setData:(NSData *)data forKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval
{
  BOOL result = NO;
  
  if ( [key length]>0 ) {
    [_lock lock];
    
    TKDiskCacheItem *item = [self itemByKey:key];
    if ( !item ) {
      item = [[TKDiskCacheItem alloc] init];
      [_itemAry addObject:item];
    }
    
    
    item.key = key;
    
    item.path = [self cachePathForKey:key];
    
    item.expiry = [[NSDate alloc] initWithTimeIntervalSinceNow:((timeoutInterval>0)?(timeoutInterval):(24*60*60.0))];
    
    item.size = [data length];
    
    
    if ( data ) {
      [data writeToFile:item.path atomically:YES];
    } else {
      [[NSFileManager defaultManager] removeItemAtPath:item.path error:NULL];
    }
    
    
    result = YES;
    
    [_lock unlock];
  }
  
  return result;
}


- (void)removeCacheForKey:(NSString *)key
{
  if ( [key length]>0 ) {
    [_lock lock];
    TKDiskCacheItem *item = [self itemByKey:key];
    if ( item ) {
      [_itemAry removeObjectIdenticalTo:item];
      [[NSFileManager defaultManager] removeItemAtPath:item.path error:NULL];
    }
    [_lock unlock];
  }
}


- (BOOL)hasCacheForKey:(NSString *)key
{
  BOOL result = NO;
  
  if ( [key length]>0 ) {
    [_lock lock];
    TKDiskCacheItem *item = [self itemByKey:key];
    if ( item ) {
      result = ![item expired];
    }
    [_lock unlock];
  }
  
  return result;
}

- (NSData *)dataForKey:(NSString *)key
{
  NSData *data = nil;
  
  if ( [key length]>0 ) {
    [_lock lock];
    TKDiskCacheItem *item = [self itemByKey:key];
    if ( item ) {
      if ( ![item expired] ) {
        data = [[NSData alloc] initWithContentsOfFile:item.path];
      }
    }
    [_lock unlock];
  }
  
  return data;
}



#pragma mark - Reorganize cache

- (NSArray *)keys
{
  NSMutableArray *keyAry = nil;
  
  [_lock lock];
  
  if ( [_itemAry count]>0 ) {
    keyAry = [[NSMutableArray alloc] init];
    for ( TKDiskCacheItem *item in _itemAry ) {
      [keyAry addObject:item.key];
    }
  }
  
  [_lock unlock];
  
  return keyAry;
}


- (void)clearCaches
{
  [_lock lock];
  
  
  [_itemAry removeAllObjects];
  
  NSString *cacheRoot = TKPathForDocumentResource(_name);
  [[NSFileManager defaultManager] removeItemAtPath:cacheRoot error:NULL];
  
  
  [self createDirectoryIfNeeded];
  
  
  [_lock unlock];
}

- (void)cleanCaches
{
  [_lock lock];
  
  _itemAry = [self cleanCaches:_itemAry];
  
  [_lock unlock];
}


- (void)synchronize
{
  [_lock lock];
  
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_itemAry];
  NSString *path = [self cachePathForKey:@"profile.dat"];
  [data writeToFile:path atomically:YES];
  
  [_lock unlock];
}


- (int)cacheSize
{
  int size = 0;
  
  [_lock lock];
  
  for ( TKDiskCacheItem *item in _itemAry ) {
    size += item.size;
  }
  
  [_lock unlock];
  
  return size;
}



#pragma mark - Paths

- (NSString *)cachePathForKey:(NSString *)key
{
  if ( [key length]>0 ) {
    NSString *relativePath = [_name stringByAppendingPathComponent:key];
    return TKPathForDocumentResource(relativePath);
  }
  return nil;
}



#pragma mark - Private

- (TKDiskCacheItem *)itemByKey:(NSString *)key
{
  if ( [key length]>0 ) {
    for ( TKDiskCacheItem *item in _itemAry ) {
      if ( [key isEqualToString:item.key] ) {
        return item;
      }
    }
  }
  return nil;
}

- (NSMutableArray *)cleanCaches:(NSArray *)ary
{
  NSMutableArray *itemAry = [[NSMutableArray alloc] init];
  if ( [ary count]>0 ) {
    NSDate *now = [NSDate date];
    for ( TKDiskCacheItem *item in ary ) {
      if ( [now earlierThan:item.expiry] ) {
        [itemAry addObject:item];
      } else {
        [[NSFileManager defaultManager] removeItemAtPath:item.path error:NULL];
      }
    }
  }
  return itemAry;
}

- (void)createDirectoryIfNeeded
{
  NSString *cacheRoot = TKPathForDocumentResource(_name);
  
  if ( ![[NSFileManager defaultManager] fileExistsAtPath:cacheRoot isDirectory:NULL] ) {
    [[NSFileManager defaultManager] createDirectoryAtPath:cacheRoot
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
  }
}

@end



@implementation TKDiskCacheItem

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
  self = [super init];
  if ( self ) {
    _key = [decoder decodeObjectForKey:@"kKey"];
    _path = [decoder decodeObjectForKey:@"kPath"];
    _expiry = [decoder decodeObjectForKey:@"kExpiry"];
    _size = [decoder decodeIntForKey:@"kSize"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject:_key forKey:@"kKey"];
  [encoder encodeObject:_path forKey:@"kPath"];
  [encoder encodeObject:_expiry forKey:@"kExpiry"];
  [encoder encodeInt:_size forKey:@"kSize"];
}



#pragma mark - Validity

- (BOOL)nonempty
{
  if ( [_key length]<=0 ) {
    return NO;
  }
  
  if ( [_path length]<=0 ) {
    return NO;
  }
  
  if ( !_expiry ) {
    return NO;
  }
  
  return YES;
}

- (BOOL)expired
{
  return ( [_expiry earlierThan:[NSDate date]] );
}

@end
