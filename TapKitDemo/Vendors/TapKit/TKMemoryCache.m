//
//  TKMemoryCache.m
//  TapKitDemo
//
//  Created by Kevin on 7/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKMemoryCache.h"
#import "NSDateAdditions.h"

@implementation TKMemoryCache

#pragma mark - Initiation

- (id)init
{
  self = [super init];
  if ( self ) {
    
    _itemAry = [[NSMutableArray alloc] init];
    
    _lock = [[NSLock alloc] init];
    
  }
  return self;
}


static TKMemoryCache *MemoryCache = nil;

+ (void)saveObject:(TKMemoryCache *)object
{
  MemoryCache = object;
}

+ (TKMemoryCache *)sharedObject
{
  return MemoryCache;
}



#pragma mark - Accessing caches

- (void)addCacheItem:(TKMemoryCacheItem *)item
{
  if ( !item ) {
    return;
  }
  
  
  if ( [item.key length]<=0 ) {
    return;
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

- (BOOL)setObject:(id)object forKey:(NSString *)key withTimeoutInterval:(NSTimeInterval)timeoutInterval
{
  BOOL result = NO;
  
  if ( [key length]>0 ) {
    [_lock lock];
    
    TKMemoryCacheItem *item = [self itemByKey:key];
    if ( !item ) {
      item = [[TKMemoryCacheItem alloc] init];
      [_itemAry addObject:item];
    }
    
    
    item.key = key;
    
    item.expiry = [[NSDate alloc] initWithTimeIntervalSinceNow:((timeoutInterval>0)?(timeoutInterval):(24*60*60.0))];
    
    item.object = object;
    
    
    result = YES;
    
    [_lock unlock];
  }
  
  return result;
}


- (void)removeCacheForKey:(NSString *)key
{
  if ( [key length]>0 ) {
    [_lock lock];
    TKMemoryCacheItem *item = [self itemByKey:key];
    if ( item ) {
      [_itemAry removeObjectIdenticalTo:item];
    }
    [_lock unlock];
  }
}


- (BOOL)hasCacheForKey:(NSString *)key
{
  BOOL result = NO;
  
  if ( [key length]>0 ) {
    [_lock lock];
    TKMemoryCacheItem *item = [self itemByKey:key];
    if ( item ) {
      result = ![item expired];
    }
    [_lock unlock];
  }
  
  return result;
}

- (id)objectForKey:(NSString *)key;
{
  id object = nil;
  
  if ( [key length]>0 ) {
    [_lock lock];
    TKMemoryCacheItem *item = [self itemByKey:key];
    if ( item ) {
      if ( ![item expired] ) {
        object = item.object;
      }
    }
    [_lock unlock];
  }
  
  return object;
}



#pragma mark - Reorganize cache

- (NSArray *)keys
{
  NSMutableArray *keyAry = nil;
  
  [_lock lock];
  
  if ( [_itemAry count]>0 ) {
    keyAry = [[NSMutableArray alloc] init];
    for ( TKMemoryCacheItem *item in _itemAry ) {
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
  
  [_lock unlock];
}

- (void)cleanCaches
{
  [_lock lock];
  
  NSMutableArray *itemAry = [[NSMutableArray alloc] init];
  
  for ( TKMemoryCacheItem *item in _itemAry ) {
    if ( ![item expired] ) {
      [itemAry addObject:item];
    }
  }
  
  _itemAry = itemAry;
  
  [_lock unlock];
}



#pragma mark - Private

- (TKMemoryCacheItem *)itemByKey:(NSString *)key
{
  if ( [key length]>0 ) {
    for ( TKMemoryCacheItem *item in _itemAry ) {
      if ( [key isEqualToString:item.key] ) {
        return item;
      }
    }
  }
  return nil;
}

@end



@implementation TKMemoryCacheItem

#pragma mark - Validity

- (BOOL)nonempty
{
  if ( [_key length]<=0 ) {
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
