//
//  NSData+RSA.h
//  CryptoDemo
//
//  Created by Kevin on 7/11/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (RSA)

- (NSData *)RSAEncryptWithPublicKey:(NSData *)key;
- (NSData *)RSADecryptWithPrivateKey:(NSData *)key;

- (NSData *)RSAEncryptWithPrivateKey:(NSData *)key;
- (NSData *)RSADecryptWithPublicKey:(NSData *)key;

@end
