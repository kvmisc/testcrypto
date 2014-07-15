//
//  NSData+AES.h
//  TapKitDemo
//
//  Created by Kevin on 7/14/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES)

- (NSData *)AES256EncryptWithKey:(NSString *)key iv:(NSData *)iv;

- (NSData *)AES256DecryptWithKey:(NSString *)key iv:(NSData *)iv;


+ (NSData *)generateInitializationVector;

@end
