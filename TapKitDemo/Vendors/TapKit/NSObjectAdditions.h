//
//  NSObjectAdditions.h
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TapKit)

///-------------------------------
/// Class name
///-------------------------------

+ (NSString *)className;

- (NSString *)className;


///-------------------------------
/// Key-Value Coding
///-------------------------------

- (BOOL)isValueForKeyPath:(NSString *)keyPath equalToValue:(id)value;

- (BOOL)isValueForKeyPath:(NSString *)keyPath identicalToValue:(id)value;

@end
