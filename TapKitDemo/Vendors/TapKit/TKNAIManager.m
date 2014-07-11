//
//  TKNAIManager.m
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKNAIManager.h"
#import "TKCommon.h"
#import "NSArrayAdditions.h"

@implementation TKNAIManager

#pragma mark - Initiation

- (id)init
{
  self = [super init];
  if ( self ) {
    
    _userAry = TKCreateWeakMutableArray();
    
    _lock = [[NSLock alloc] init];
    
  }
  return self;
}


+ (TKNAIManager *)sharedObject
{
  static TKNAIManager *NAIManager = nil;
  static dispatch_once_t Token;
  dispatch_once(&Token, ^{
    NAIManager = [[self alloc] init];
  });
  return NAIManager;
}



#pragma mark - User routines

- (BOOL)isNetworkUser:(id)user
{
  BOOL result = NO;
  
  [_lock lock];
  result = [_userAry hasObjectIdenticalTo:user];
  [_lock unlock];
  
  return result;
}


- (void)addNetworkUser:(id)user
{
  [_lock lock];
  
  [_userAry addUnidenticalObjectIfNotNil:user];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = ([_userAry count]>0);
  
  [_lock unlock];
}

- (void)removeNetworkUser:(id)user
{
  [_lock lock];
  
  [_userAry removeObjectIdenticalTo:user];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = ([_userAry count]>0);
  
  [_lock unlock];
}

- (void)removeAllNetworkUsers
{
  [_lock lock];
  
  [_userAry removeAllObjects];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  
  [_lock unlock];
}

@end
