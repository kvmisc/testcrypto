//
//  NSData+AES.h
//  CryptoDemo
//
//  Created by Kevin on 7/14/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES)

- (NSData *)AES256EncryptWithKey:(NSData *)key;

- (NSData *)AES256DecryptWithKey:(NSData *)key;

@end
