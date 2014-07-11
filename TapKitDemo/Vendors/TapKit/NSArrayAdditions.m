//
//  NSArrayAdditions.m
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "NSArrayAdditions.h"
#import "NSObjectAdditions.h"

@implementation NSArray (TapKit)

#pragma mark - Querying

- (id)objectOrNilAtIndex:(NSUInteger)idx
{
  if ( idx<[self count] ) {
    return [self objectAtIndex:idx];
  }
  return nil;
}

- (id)firstObject
{
  return [self objectOrNilAtIndex:0];
}

- (id)randomObject
{
  if ( [self count]>0 ) {
    NSUInteger idx = arc4random() % [self count];
    return [self objectAtIndex:idx];
  }
  return nil;
}


- (BOOL)hasObjectEqualTo:(id)object
{
  return ( [self indexOfObject:object]!=NSNotFound );
}

- (BOOL)hasObjectIdenticalTo:(id)object
{
  return ( [self indexOfObjectIdenticalTo:object]!=NSNotFound );
}



#pragma mark - Key-Value Coding

- (NSArray *)objectsForKeyPath:(NSString *)keyPath equalToValue:(id)value
{
  NSMutableArray *objectAry = [[NSMutableArray alloc] init];
  
  for ( NSUInteger i=0; i<[self count]; ++i ) {
    id object = [self objectAtIndex:i];
    if ( [object isValueForKeyPath:keyPath equalToValue:value] ) {
      [objectAry addObject:object];
    }
  }
  
  if ( [objectAry count]>0 ) {
    return objectAry;
  }
  
  return nil;
}

- (NSArray *)objectsForKeyPath:(NSString *)keyPath identicalToValue:(id)value
{
  NSMutableArray *objectAry = [[NSMutableArray alloc] init];
  
  for ( NSUInteger i=0; i<[self count]; ++i ) {
    id object = [self objectAtIndex:i];
    if ( [object isValueForKeyPath:keyPath identicalToValue:value] ) {
      [objectAry addObject:object];
    }
  }
  
  if ( [objectAry count]>0 ) {
    return objectAry;
  }
  
  return nil;
}


- (id)firstObjectForKeyPath:(NSString *)keyPath equalToValue:(id)value
{
  for ( NSUInteger i=0; i<[self count]; ++i ) {
    id object = [self objectAtIndex:i];
    if ( [object isValueForKeyPath:keyPath equalToValue:value] ) {
      return object;
    }
  }
  return nil;
}

- (id)firstObjectForKeyPath:(NSString *)keyPath identicalToValue:(id)value
{
  for ( NSUInteger i=0; i<[self count]; ++i ) {
    id object = [self objectAtIndex:i];
    if ( [object isValueForKeyPath:keyPath identicalToValue:value] ) {
      return object;
    }
  }
  return nil;
}

@end



@implementation NSMutableArray (TapKit)

#pragma mark - Content management

- (id)addObjectIfNotNil:(id)object
{
  if ( object ) {
    [self addObject:object];
    return object;
  }
  return nil;
}

- (id)addUnequalObjectIfNotNil:(id)object
{
  if ( object ) {
    if ( [self indexOfObject:object]==NSNotFound ) {
      [self addObject:object];
      return object;
    }
  }
  return nil;
}

- (id)addUnidenticalObjectIfNotNil:(id)object
{
  if ( object ) {
    if ( [self indexOfObjectIdenticalTo:object]==NSNotFound ) {
      [self addObject:object];
      return object;
    }
  }
  return nil;
}

- (id)insertObject:(id)object atIndexIfNotNil:(NSUInteger)idx
{
  if ( object ) {
    if ( idx<=[self count] ) {
      [self insertObject:object atIndex:idx];
      return object;
    }
  }
  return nil;
}


- (void)removeFirstObject
{
  if ( [self count]>0 ) {
    [self removeObjectAtIndex:0];
  }
}



#pragma mark - Ordering

// http://en.wikipedia.org/wiki/Knuth_shuffle
- (void)shuffle
{
  for ( NSUInteger i=[self count]; i>1; --i ) {
    
    NSUInteger m = 1;
    do {
      m <<= 1;
    } while ( m<i );
    
    NSUInteger j = 0;
    do {
      j = arc4random() % m;
    } while ( j>=i );
    
    [self exchangeObjectAtIndex:(i-1) withObjectAtIndex:j];
  }
}

- (void)reverse
{
  NSUInteger semi = floor( [self count]/2.0 );
  for ( NSUInteger i=0; i<semi; ++i ) {
    NSUInteger idx = [self count] - (i+1);
    [self exchangeObjectAtIndex:i withObjectAtIndex:idx];
  }
}

- (id)moveObjectAtIndex:(NSUInteger)idx toIndex:(NSUInteger)toIdx
{
  if ( idx!=toIdx ) {
    if ( (idx<[self count]) && (toIdx<[self count]) ) {
      id object = [self objectAtIndex:idx];
      [self removeObjectAtIndex:idx];
      [self insertObject:object atIndex:toIdx];
      return object;
    }
  }
  return nil;
}



#pragma mark - Filtering

- (void)unequal
{
  for ( NSUInteger i=0; i<[self count]; ++i ) {
    id object = [self objectAtIndex:i];
    
    for ( NSUInteger j=i+1; j<[self count];  ) {
      
      if ( [object isEqual:[self objectAtIndex:j]] ) {
        [self removeObjectAtIndex:j];
      } else {
        ++j;
      }
      
    }
  }
}

- (void)unidentical
{
  for ( NSUInteger i=0; i<[self count]; ++i ) {
    id object = [self objectAtIndex:i];
    
    for ( NSUInteger j=i+1; j<[self count];  ) {
      
      if ( object==[self objectAtIndex:j] ) {
        [self removeObjectAtIndex:j];
      } else {
        ++j;
      }
      
    }
  }
}



#pragma mark - Stack operation

- (id)push:(id)object
{
  return [self addObjectIfNotNil:object];
}

- (id)pop
{
  id object = [self lastObject];
  [self removeLastObject];
  return object;
}



#pragma mark - Queue operation

- (id)enqueue:(id)object
{
  return [self addObjectIfNotNil:object];
}

- (id)dequeue
{
  id object = [self firstObject];
  [self removeFirstObject];
  return object;
}

@end
