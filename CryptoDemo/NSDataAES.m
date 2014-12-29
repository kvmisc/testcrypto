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
  return [self cryptWithOperation:kCCEncrypt key:key iv:iv];
}

- (NSData *)AESDecryptedDataWithKey:(NSData *)key iv:(NSData *)iv
{
  return [self cryptWithOperation:kCCDecrypt key:key iv:iv];
}


- (NSData *)AESGenerateKeyBySize:(NSUInteger)size
{
  if ( (size==kCCKeySizeAES128) || (size==kCCKeySizeAES192) || (size==kCCKeySizeAES256) ) {
    NSMutableData *data = [[NSMutableData alloc] initWithLength:size];
    SecRandomCopyBytes(kSecRandomDefault, size, [data mutableBytes]);
    return data;
  }
  return nil;
}

- (NSData *)AESGenerateIV
{
  NSMutableData *data = [[NSMutableData alloc] initWithLength:kCCBlockSizeAES128];
  SecRandomCopyBytes(kSecRandomDefault, kCCBlockSizeAES128, [data mutableBytes]);
  return data;
}


- (NSData *)cryptWithOperation:(CCOperation)operation key:(NSData *)key iv:(NSData *)iv
{
  if ( [self length]<=0 ) {
    DDLogDebug(@"[aes] data is empty");
    return nil;
  }
  if ( ([key length]!=kCCKeySizeAES128) && ([key length]!=kCCKeySizeAES192) && ([key length]!=kCCKeySizeAES256) ) {
    DDLogDebug(@"[aes] key size invalid");
    return nil;
  }
  if ( [iv length]!=kCCBlockSizeAES128 ) {
    DDLogDebug(@"[aes] initialization vector is empty");
    return nil;
  }
  
  NSData *result = nil;
  
  
  CCCryptorStatus status = kCCSuccess;
  
  CCCryptorRef cryptorRef = NULL;
  status = CCCryptorCreate(operation,
                           kCCAlgorithmAES,
                           kCCOptionPKCS7Padding,
                           [key bytes],
                           [key length],
                           [iv bytes],
                           &cryptorRef);
  
  if ( status==kCCSuccess ) {
    size_t bufferSize = CCCryptorGetOutputLength(cryptorRef, [self length], true);
    void *buffer = malloc(bufferSize);
    if ( buffer ) {
      NSUInteger totalLength = 0;
      size_t writtenLength = 0;
      status = CCCryptorUpdate(cryptorRef,
                               [self bytes],
                               [self length],
                               buffer,
                               bufferSize,
                               &writtenLength);
      totalLength += writtenLength;
      status = CCCryptorFinal(cryptorRef,
                              buffer+writtenLength,
                              bufferSize-writtenLength,
                              &writtenLength);
      totalLength += writtenLength;
      result = [[NSData alloc] initWithBytesNoCopy:buffer length:totalLength];
    }
    
    CCCryptorRelease(cryptorRef);
  }
  
  return result;
}

@end
