//
//  NSDataAES.m
//  CryptoDemo
//
//  Created by Kevin Wu on 12/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "NSDataAES.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSData (AES)

- (NSData *)AESEncryptedDataWithKey:(NSData *)key iv:(NSData *)iv
{
  if ( [self length]>0 ) {
    if ( ([key length]==kCCKeySizeAES128) || ([key length]==kCCKeySizeAES192) || ([key length]==kCCKeySizeAES256) ) {
      if ( [iv length]==kCCBlockSizeAES128 ) {
        return [self AESCryptWithOperation:kCCEncrypt key:key iv:iv];
      }
    }
  }
  return nil;
}

- (NSData *)AESDecryptedDataWithKey:(NSData *)key iv:(NSData *)iv
{
  if ( [self length]>0 ) {
    if ( ([key length]==kCCKeySizeAES128) || ([key length]==kCCKeySizeAES192) || ([key length]==kCCKeySizeAES256) ) {
      if ( [iv length]==kCCBlockSizeAES128 ) {
        return [self AESCryptWithOperation:kCCDecrypt key:key iv:iv];
      }
    }
  }
  return nil;
}



+ (NSData *)AES128GenerateKey
{
  NSMutableData *data = [[NSMutableData alloc] initWithLength:kCCKeySizeAES128];
  SecRandomCopyBytes(kSecRandomDefault, kCCKeySizeAES128, [data mutableBytes]);
  return data;
}

+ (NSData *)AES192GenerateKey
{
  NSMutableData *data = [[NSMutableData alloc] initWithLength:kCCKeySizeAES192];
  SecRandomCopyBytes(kSecRandomDefault, kCCKeySizeAES192, [data mutableBytes]);
  return data;
}

+ (NSData *)AES256GenerateKey
{
  NSMutableData *data = [[NSMutableData alloc] initWithLength:kCCKeySizeAES256];
  SecRandomCopyBytes(kSecRandomDefault, kCCKeySizeAES256, [data mutableBytes]);
  return data;
}


+ (NSData *)AESGenerateIV
{
  NSMutableData *data = [[NSMutableData alloc] initWithLength:kCCBlockSizeAES128];
  SecRandomCopyBytes(kSecRandomDefault, kCCBlockSizeAES128, [data mutableBytes]);
  return data;
}



- (NSData *)AESCryptWithOperation:(CCOperation)operation key:(NSData *)key iv:(NSData *)iv
{
  CCCryptorRef cryptorRef = NULL;
  CCCryptorStatus status = CCCryptorCreate(operation,
                           kCCAlgorithmAES,
                           kCCOptionPKCS7Padding,
                           [key bytes],
                           [key length],
                           [iv bytes],
                           &cryptorRef);
  
  if ( status==kCCSuccess ) {
    NSUInteger bufferSize = CCCryptorGetOutputLength(cryptorRef, [self length], true);
    NSMutableData *result = [[NSMutableData alloc] initWithLength:bufferSize];

    void *buffer = [result mutableBytes];
    NSUInteger totalLength = 0;
    size_t writtenLength = 0;
    status = CCCryptorUpdate(cryptorRef,
                             [self bytes],
                             [self length],
                             buffer,
                             bufferSize,
                             &writtenLength);
    if ( status==kCCSuccess ) {
      totalLength += writtenLength;
      status = CCCryptorFinal(cryptorRef,
                              buffer+writtenLength,
                              bufferSize-writtenLength,
                              &writtenLength);
      if ( status==kCCSuccess ) {
        totalLength += writtenLength;
        [result setLength:totalLength];
        CCCryptorRelease(cryptorRef);
        return result;
      }
    }
    CCCryptorRelease(cryptorRef);
  }
  
  return nil;
}

@end
