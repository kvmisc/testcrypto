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

- (NSData *)AES256EncryptWithKey:(NSData *)key
{
  if ( TKDNonempty(key) && ([self length]>0) ) {
    
    NSData *encoded = nil;
    
    EVP_CIPHER_CTX *cipher = malloc(sizeof(EVP_CIPHER_CTX));
    if ( cipher ) {
      EVP_CIPHER_CTX_init(cipher);
      
      unsigned char *obuf = malloc([self length] + AES_BLOCK_SIZE);
      if ( obuf ) {
        int olen = 0;
        
        EVP_EncryptInit(cipher, EVP_aes_256_ecb(), [key bytes], NULL);
        
        int tmp = 0;
        EVP_EncryptUpdate(cipher, obuf, &tmp, [self bytes], [self length]);
        olen += tmp;
        EVP_EncryptFinal(cipher, obuf+olen, &tmp);
        olen += tmp;
        
        EVP_CIPHER_CTX_cleanup(cipher);
        
        if ( olen>0 ) {
          unsigned char *buffer = malloc(olen);
          if ( buffer ) {
            memset(buffer, 0, olen);
            memcpy(buffer, obuf, olen);
            encoded = [[NSData alloc] initWithBytesNoCopy:buffer length:olen];
          }
        }
        free(obuf);
      }
      free(cipher);
    }
    
    return TKDatOrLater(encoded, nil);
  }
  return nil;
}

- (NSData *)AES256DecryptWithKey:(NSData *)key
{
  if ( TKDNonempty(key) && ([self length]>0) ) {
    
    NSData *encoded = nil;
    
    EVP_CIPHER_CTX *cipher = malloc(sizeof(EVP_CIPHER_CTX));
    if ( cipher ) {
      EVP_CIPHER_CTX_init(cipher);
      
      unsigned char *obuf = malloc([self length] + AES_BLOCK_SIZE);
      if ( obuf ) {
        int olen = 0;
        
        EVP_DecryptInit(cipher, EVP_aes_256_ecb(), [key bytes], NULL);
        
        int tmp = 0;
        EVP_DecryptUpdate(cipher, obuf, &tmp, [self bytes], [self length]);
        olen += tmp;
        EVP_DecryptFinal(cipher, obuf+olen, &tmp);
        olen += tmp;
        
        EVP_CIPHER_CTX_cleanup(cipher);
        
        if ( olen>0 ) {
          unsigned char *buffer = malloc(olen);
          if ( buffer ) {
            memset(buffer, 0, olen);
            memcpy(buffer, obuf, olen);
            encoded = [[NSData alloc] initWithBytesNoCopy:buffer length:olen];
          }
        }
        free(obuf);
      }
      free(cipher);
    }
    
    return TKDatOrLater(encoded, nil);
  }
  return nil;
}

@end
