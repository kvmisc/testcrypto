//
//  NSData+AES.m
//  CryptoDemo
//
//  Created by Kevin on 7/14/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "NSData+AES.h"
#import <openssl/evp.h>
#import <openssl/aes.h>
#import <openssl/rand.h>

@implementation NSData (AES)

- (NSData *)AES256EncryptWithKey:(NSString *)key iv:(NSData *)iv
{
  NSData *result = nil;
  
  if ( [key length]>0 ) {
    
    EVP_CIPHER_CTX *ctx = malloc(sizeof(EVP_CIPHER_CTX));
    if ( ctx ) {
      EVP_CIPHER_CTX_init(ctx);
      
      unsigned char *buf = malloc([self length] + AES_BLOCK_SIZE);
      int length = 0;
      int tmp = 0;
      
      if ( buf ) {
        EVP_EncryptInit(ctx, EVP_aes_256_cbc(), (unsigned char *)[key UTF8String], [iv bytes]);
        
        EVP_EncryptUpdate(ctx, buf, &tmp, [self bytes], [self length]);
        length += tmp;
        
        EVP_EncryptFinal(ctx, buf+length, &tmp);
        length += tmp;
        
        EVP_CIPHER_CTX_cleanup(ctx);
        
        if ( length>0 ) {
          unsigned char *fixed = malloc(length);
          if ( fixed ) {
            memset(fixed, 0, length);
            memcpy(fixed, buf, length);
            result = [[NSData alloc] initWithBytesNoCopy:fixed length:length];
          }
        }
        free(buf);
      }
      free(ctx);
    }
    
  }
  
  return result;
}

- (NSData *)AES256DecryptWithKey:(NSString *)key iv:(NSData *)iv
{
  NSData *result = nil;
  
  if ( [key length]>0 ) {
    
    EVP_CIPHER_CTX *ctx = malloc(sizeof(EVP_CIPHER_CTX));
    if ( ctx ) {
      EVP_CIPHER_CTX_init(ctx);
      
      unsigned char *buf = malloc([self length]);
      int length = 0;
      int tmp = 0;
      
      if ( buf ) {
        EVP_DecryptInit(ctx, EVP_aes_256_cbc(), (unsigned char *)[key UTF8String], [iv bytes]);
        
        EVP_DecryptUpdate(ctx, buf, &tmp, [self bytes], [self length]);
        length += tmp;
        
        EVP_DecryptFinal(ctx, buf+length, &tmp);
        length += tmp;
        
        EVP_CIPHER_CTX_cleanup(ctx);
        
        if ( length>0 ) {
          unsigned char *fixed = malloc(length);
          if ( fixed ) {
            memset(fixed, 0, length);
            memcpy(fixed, buf, length);
            result = [[NSData alloc] initWithBytesNoCopy:fixed length:length];
          }
        }
        free(buf);
      }
      free(ctx);
    }
    
  }
  
  return result;
}


+ (NSData *)generateInitializationVector
{
  unsigned char *buf = malloc(AES_BLOCK_SIZE);
  RAND_bytes(buf, AES_BLOCK_SIZE);
  return [[NSData alloc] initWithBytesNoCopy:buf length:AES_BLOCK_SIZE];
}

@end
