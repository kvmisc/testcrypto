//
//  TKNAIManager.h
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKNAIManager : NSObject {
  NSMutableArray *_userAry;
  
  NSLock *_lock;
}


///-------------------------------
/// Initiation
///-------------------------------

+ (TKNAIManager *)sharedObject;


///-------------------------------
/// User routines
///-------------------------------

- (BOOL)isNetworkUser:(id)user;


- (void)addNetworkUser:(id)user;

- (void)removeNetworkUser:(id)user;

- (void)removeAllNetworkUsers;

@end
