//
//  TKOperation.m
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKOperation.h"

@implementation TKOperation

#pragma mark - Status transfer

- (void)transferStatusToReady
{
  [self willChangeValueForKey:@"isReady"];
  _ready = YES;
  [self didChangeValueForKey:@"isReady"];
}

- (void)transferStatusToCancelled
{
  [self willChangeValueForKey:@"isCancelled"];
  _cancelled = YES;
  [self didChangeValueForKey:@"isCancelled"];
}

- (void)transferStatusToFinished
{
  [self willChangeValueForKey:@"isFinished"];
  _finished = YES;
  [self didChangeValueForKey:@"isFinished"];
}

- (void)transferStatusFromReadyToExecuting
{
  [self willChangeValueForKey:@"isExecuting"];
  [self willChangeValueForKey:@"isReady"];
  _ready = NO;
  _executing = YES;
  [self didChangeValueForKey:@"isReady"];
  [self didChangeValueForKey:@"isExecuting"];
}

- (void)transferStatusFromExecutingToFinished
{
  [self willChangeValueForKey:@"isFinished"];
  [self willChangeValueForKey:@"isExecuting"];
  _executing = NO;
  _finished = YES;
  [self didChangeValueForKey:@"isExecuting"];
  [self didChangeValueForKey:@"isFinished"];
}



#pragma mark - Notify routines

- (void)operationDidStart
{
  if ( _didStartBlock ) {
    if ( _notifyOnMainThread ) {
      dispatch_async(dispatch_get_main_queue(), ^{
        _didStartBlock(self);
      });
    } else {
      _didStartBlock(self);
    }
  }
}

- (void)operationDidUpdate
{
  if ( _didUpdateBlock ) {
    if ( _notifyOnMainThread ) {
      dispatch_async(dispatch_get_main_queue(), ^{
        _didUpdateBlock(self);
      });
    } else {
      _didUpdateBlock(self);
    }
  }
}

- (void)operationDidFail
{
  if ( _didFailBlock ) {
    if ( _notifyOnMainThread ) {
      dispatch_async(dispatch_get_main_queue(), ^{
        _didFailBlock(self);
      });
    } else {
      _didFailBlock(self);
    }
  }
}

- (void)operationDidFinish
{
  if ( _didFinishBlock ) {
    if ( _notifyOnMainThread ) {
      dispatch_async(dispatch_get_main_queue(), ^{
        _didFinishBlock(self);
      });
    } else {
      _didFinishBlock(self);
    }
  }
}



#pragma mark - NSOperation

- (void)cancel
{
  if ( [self isCancelled] ) {
    return;
  }
  
  if ( [self isFinished] ) {
    return;
  }
  
  [self transferStatusToCancelled];
  
  [super cancel];
}

- (BOOL)isReady
{
  return ( (_ready) && [super isReady] );
}

- (BOOL)isExecuting
{
  return ( _executing );
}

- (BOOL)isFinished
{
  return ( _finished );
}

- (BOOL)isCancelled
{
  return _cancelled;
}

- (BOOL)isConcurrent
{
  return YES;
}

@end
