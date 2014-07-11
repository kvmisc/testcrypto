//
//  NSObjectAdditions.m
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "NSObjectAdditions.h"

@implementation NSObject (TapKit)

#pragma mark - Class name

+ (NSString *)className
{
  return NSStringFromClass([self class]);
}

- (NSString *)className
{
  return NSStringFromClass([self class]);
}



#pragma mark - Key-Value Coding

- (BOOL)isValueForKeyPath:(NSString *)keyPath equalToValue:(id)value
{
  if ( [keyPath length]>0 ) {
    id objectValue = [self valueForKeyPath:keyPath];
    
    if ( (!value) && (!objectValue) ) {
      return YES;
    }
    
    return [objectValue isEqual:value];
  }
  return NO;
}

- (BOOL)isValueForKeyPath:(NSString *)keyPath identicalToValue:(id)value
{
  if ( [keyPath length]>0 ) {
    return ( [self valueForKeyPath:keyPath]==value );
  }
  return NO;
}

@end
