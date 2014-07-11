//
//  NSArrayAdditions.h
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (TapKit)

///-------------------------------
/// Querying
///-------------------------------

- (id)objectOrNilAtIndex:(NSUInteger)idx;

- (id)firstObject;

- (id)randomObject;


- (BOOL)hasObjectEqualTo:(id)object;

- (BOOL)hasObjectIdenticalTo:(id)object;


///-------------------------------
/// Key-Value Coding
///-------------------------------

- (NSArray *)objectsForKeyPath:(NSString *)keyPath equalToValue:(id)value;

- (NSArray *)objectsForKeyPath:(NSString *)keyPath identicalToValue:(id)value;


- (id)firstObjectForKeyPath:(NSString *)keyPath equalToValue:(id)value;

- (id)firstObjectForKeyPath:(NSString *)keyPath identicalToValue:(id)value;

@end



@interface NSMutableArray (TapKit)

///-------------------------------
/// Content management
///-------------------------------

- (id)addObjectIfNotNil:(id)object;

- (id)addUnequalObjectIfNotNil:(id)object;

- (id)addUnidenticalObjectIfNotNil:(id)object;

- (id)insertObject:(id)object atIndexIfNotNil:(NSUInteger)idx;


- (void)removeFirstObject;


///-------------------------------
/// Ordering
///-------------------------------

- (void)shuffle;

- (void)reverse;

- (id)moveObjectAtIndex:(NSUInteger)idx toIndex:(NSUInteger)toIdx;


///-------------------------------
/// Filtering
///-------------------------------

- (void)unequal;

- (void)unidentical;


///-------------------------------
/// Stack operation
///-------------------------------

- (id)push:(id)object;

- (id)pop;


///-------------------------------
/// Queue operation
///-------------------------------

- (id)enqueue:(id)object;

- (id)dequeue;

@end
