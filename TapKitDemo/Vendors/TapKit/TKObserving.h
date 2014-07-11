//
//  TKObserving.h
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TKObserving <NSObject>

- (NSArray *)observers;
- (id)addObserver:(id)observer;
- (void)removeObserver:(id)observer;
- (void)removeAllObservers;

@end
