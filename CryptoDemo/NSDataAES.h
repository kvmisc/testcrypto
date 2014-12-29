//
//  NSDataAES.h
//  CryptoDemo
//
//  Created by Kevin Wu on 12/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES)

- (NSData *)AESEncryptedDataWithKey:(NSData *)key iv:(NSData *)iv;

- (NSData *)AESDecryptedDataWithKey:(NSData *)key iv:(NSData *)iv;


- (NSData *)AESGenerateKeyBySize:(NSUInteger)size;

- (NSData *)AESGenerateIV;

@end
