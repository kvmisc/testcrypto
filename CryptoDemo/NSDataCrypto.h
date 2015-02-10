//
//  NSDataCrypto.h
//  CryptoDemo
//
//  Created by Kevin Wu on 2/9/15.
//  Copyright (c) 2015 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <openssl/rsa.h>
#import <openssl/pem.h>

@interface NSData (Crypto)

- (NSData *)RSAEncryptedDataWithPublicKey:(RSA *)rsa;

- (NSData *)RSADecryptedDataWithPrivateKey:(RSA *)rsa;


- (NSData *)RSAEncryptedDataWithPrivateKey:(RSA *)rsa;

- (NSData *)RSADecryptedDataWithPublicKey:(RSA *)rsa;



+ (RSA *)RSAPublicKey:(NSData *)key;

+ (RSA *)RSAPrivateKey:(NSData *)key;

@end