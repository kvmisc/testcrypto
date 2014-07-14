//
//  NSData+RSA.m
//  TapKitDemo
//
//  Created by Kevin on 7/11/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "NSData+RSA.h"
#import <openssl/rsa.h>
#import <openssl/pem.h>

@implementation NSData (RSA)

- (NSData *)RSAEncryptWithKey:(NSString *)key type:(int)type
{
  NSMutableData *result = [[NSMutableData alloc] init];
  
  RSA *rsa = [self RSAWithKey:key type:type];
  
  if ( rsa ) {
    int blk_size = RSA_size(rsa) - 11;
    int blk_count = ceil([self length] / (CGFloat)blk_size);
    
    unsigned char read_buf[1024];
    unsigned char parse_buf[1024];
    
    for ( int i=0; i<blk_count; ++i ) {
      int loc = i * blk_size;
      int len = MIN((blk_size), ([self length] - i*blk_size));
      memset(read_buf, 0, 1024);
      [self getBytes:read_buf range:NSMakeRange(loc, len)];
      
      memset(parse_buf, 0, 1024);
      int parse_count = 0;
      if ( type==0 ) {
        parse_count = RSA_public_encrypt(len, read_buf, parse_buf, rsa, RSA_PKCS1_PADDING);
      } else {
        parse_count = RSA_private_encrypt(len, read_buf, parse_buf, rsa, RSA_PKCS1_PADDING);
      }
      
      [result appendBytes:parse_buf length:parse_count];
    }
    
  }
  
  return result;
}

- (NSData *)RSADecryptWithKey:(NSString *)key type:(int)type
{
  NSMutableData *result = [[NSMutableData alloc] init];
  
  RSA *rsa = [self RSAWithKey:key type:type];
  
  if ( rsa ) {
    int blk_size = RSA_size(rsa);
    int blk_count = [self length] / blk_size;
    
    if ( ([self length] % blk_size) == 0 ) {
      unsigned char read_buf[1024];
      unsigned char parse_buf[1024];
      
      for ( int i=0; i<blk_count; ++i ) {
        memset(read_buf, 0, 1024);
        [self getBytes:read_buf range:NSMakeRange((i*blk_size), blk_size)];
        
        memset(parse_buf, 0, 1024);
        int parse_count = 0;
        if ( type==0 ) {
          parse_count = RSA_public_decrypt(blk_size, read_buf, parse_buf, rsa, RSA_PKCS1_PADDING);
        } else {
          parse_count = RSA_private_decrypt(blk_size, read_buf, parse_buf, rsa, RSA_PKCS1_PADDING);
        }
        
        [result appendBytes:parse_buf length:parse_count];
      }
    }
    
  }
  
  return result;
}



- (RSA *)RSAWithKey:(NSString *)key type:(int)type
{
  RSA *rsa = NULL;
  
  if ( [key length]>0 ) {
    const char *str = [key UTF8String];
    
    BIO *bio = BIO_new_mem_buf((void *)str, strlen(str));
    if ( type==0 ) {
      rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, 0, NULL);
    } else {
      rsa = PEM_read_bio_RSAPrivateKey(bio, NULL, 0, NULL);
    }
    BIO_free(bio);
  }
  
  return rsa;
}

@end
