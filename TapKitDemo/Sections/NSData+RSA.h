//
//  NSData+RSA.h
//  TapKitDemo
//
//  Created by Kevin Wu on 7/11/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (RSA)

- (NSData *)RSAEncryptWithPublicKey:(NSString *)publicKey;
- (NSData *)RSADecryptWithPrivateKey:(NSString *)privateKey;

- (NSData *)RSAEncryptWithPrivateKey:(NSString *)publicKey;
- (NSData *)RSADecryptWithPublicKey:(NSString *)publicKey;

@end
