//
//  NSData+RSA.h
//  CryptoDemo
//
//  Created by Kevin on 7/11/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (RSA)

- (NSData *)RSAEncryptWithKey:(NSString *)key type:(int)type;

- (NSData *)RSADecryptWithKey:(NSString *)key type:(int)type;

@end
