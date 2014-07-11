//
//  TKOperation.h
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TKOperationBlock)(id operation);

@interface TKOperation : NSOperation {
  TKOperationBlock _didStartBlock;
  TKOperationBlock _didUpdateBlock;
  TKOperationBlock _didFailBlock;
  TKOperationBlock _didFinishBlock;
  
  BOOL _notifyOnMainThread;
  
  NSError *_error;
  
  
  BOOL _ready;
  BOOL _executing;
  BOOL _finished;
  BOOL _cancelled;
}

@property (nonatomic, copy) TKOperationBlock didStartBlock;
@property (nonatomic, copy) TKOperationBlock didUpdateBlock;
@property (nonatomic, copy) TKOperationBlock didFailBlock;
@property (nonatomic, copy) TKOperationBlock didFinishBlock;

@property (nonatomic, assign) BOOL notifyOnMainThread;

@property (nonatomic, strong) NSError *error;


///-------------------------------
/// Status transfer
///-------------------------------

- (void)transferStatusToReady;

- (void)transferStatusToCancelled;

- (void)transferStatusToFinished;

- (void)transferStatusFromReadyToExecuting;

- (void)transferStatusFromExecutingToFinished;


///-------------------------------
/// Notify routines
///-------------------------------

- (void)operationDidStart;

- (void)operationDidUpdate;

- (void)operationDidFail;

- (void)operationDidFinish;

@end
