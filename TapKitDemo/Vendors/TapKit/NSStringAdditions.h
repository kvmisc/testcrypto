//
//  NSStringAdditions.h
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TapKit)

///-------------------------------
/// UUID
///-------------------------------

+ (NSString *)UUIDString;


///-------------------------------
/// Validity
///-------------------------------

- (BOOL)isDecimalNumber;

- (BOOL)isWhitespaceAndNewline;


- (BOOL)isInCharacterSet:(NSCharacterSet *)characterSet;


///-------------------------------
/// Finding
///-------------------------------

- (NSUInteger)occurTimesOfCharacter:(unichar)character;


///-------------------------------
/// Hash
///-------------------------------

- (NSString *)MD5HashString;

- (NSString *)SHA1HashString;


///-------------------------------
/// URL
///-------------------------------

- (NSString *)URLEncodedString;

- (NSString *)URLDecodedString;


- (NSDictionary *)URLQueryDictionary;

- (NSString *)stringByAddingQueryDictionary:(NSDictionary *)dictionary;

- (NSString *)stringByAppendingQueryValue:(NSString *)value forKey:(NSString *)key;

@end
