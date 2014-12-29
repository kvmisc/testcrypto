//
//  NSDataRSA.h
//  CryptoDemo
//
//  Created by Kevin Wu on 12/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (RSA)

- (NSData *)RSAEncryptedDataWithPublicKey:(SecKeyRef)keyRef;

- (NSData *)RSADecryptedDataWithPrivateKey:(SecKeyRef)keyRef;


+ (SecKeyRef)RSAPublicKeyFromDERData:(NSData *)data;

+ (SecKeyRef)RSAPrivateKeyFromPFXData:(NSData *)data password:(NSString *)password;

//- (NSData *)RSAEncryptedDataWithPublicKey:(NSData *)key;
//- (NSData *)RSADecryptedDataWithPrivateKey:(NSData *)key;
//
//- (NSData *)RSAEncryptedDataWithPrivateKey:(NSData *)key;
//- (NSData *)RSADecryptedDataWithPublicKey:(NSData *)key;

@end
