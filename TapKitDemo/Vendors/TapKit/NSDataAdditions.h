//
//  NSDataAdditions.h
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (TapKit)

///-------------------------------
/// Hash
///-------------------------------

- (NSString *)MD5HashString;

- (NSString *)SHA1HashString;

@end
