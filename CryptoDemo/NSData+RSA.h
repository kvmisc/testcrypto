//
//  NSData+RSA.h
//  CryptoDemo
//
//  Created by Kevin on 7/11/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (RSA)

- (NSData *)RSAEncryptWithPublicKey:(NSString *)key;
- (NSData *)RSADecryptWithPrivateKey:(NSString *)key;

- (NSData *)RSAEncryptWithPrivateKey:(NSString *)key;
- (NSData *)RSADecryptWithPublicKey:(NSString *)key;

@end
