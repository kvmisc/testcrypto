//
//  NSDataAES.h
//  CryptoDemo
//
//  Created by Kevin Wu on 12/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES)

- (NSData *)AES256EncryptWithKey:(NSData *)key iv:(NSData *)iv;

- (NSData *)AES256DecryptWithKey:(NSData *)key iv:(NSData *)iv;



- (NSData *)AES256EncryptWithKey:(NSData *)key;

- (NSData *)AES256DecryptWithKey:(NSData *)key;

@end
