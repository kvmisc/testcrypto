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
  NSMutableData *result = NULL;
  
  RSA *rsa = [self RSAWithKey:key type:type];
  
  if ( rsa ) {
    int bsize = RSA_size(rsa) - 11;
    int bcount = ceil([self length] / (CGFloat)bsize);
    
    unsigned char ibuf[1024];
    unsigned char obuf[1024];
    
    result = [[NSMutableData alloc] init];
    
    for ( int i=0; i<bcount; ++i ) {
      int loc = i * bsize;
      int len = MIN((bsize), ([self length] - i*bsize));
      memset(ibuf, 0, 1024);
      [self getBytes:ibuf range:NSMakeRange(loc, len)];
      
      memset(obuf, 0, 1024);
      if ( type==0 ) {
        int length = RSA_public_encrypt(len, ibuf, obuf, rsa, RSA_PKCS1_PADDING);
        [result appendBytes:obuf length:length];
      } else {
        int length = RSA_private_encrypt(len, ibuf, obuf, rsa, RSA_PKCS1_PADDING);
        [result appendBytes:obuf length:length];
      }
    }
    
  }
  
  return result;
}

- (NSData *)RSADecryptWithKey:(NSString *)key type:(int)type
{
  NSMutableData *result = NULL;
  
  RSA *rsa = [self RSAWithKey:key type:type];
  
  if ( rsa ) {
    int bsize = RSA_size(rsa);
    int bcount = [self length] / bsize;
    
    if ( ([self length]%bsize)==0 ) {
      unsigned char ibuf[1024];
      unsigned char obuf[1024];
      
      result = [[NSMutableData alloc] init];
      
      for ( int i=0; i<bcount; ++i ) {
        memset(ibuf, 0, 1024);
        [self getBytes:ibuf range:NSMakeRange((i*bsize), bsize)];
        
        memset(obuf, 0, 1024);
        if ( type==0 ) {
          int length = RSA_public_decrypt(bsize, ibuf, obuf, rsa, RSA_PKCS1_PADDING);
          [result appendBytes:obuf length:length];
        } else {
          int length = RSA_private_decrypt(bsize, ibuf, obuf, rsa, RSA_PKCS1_PADDING);
          [result appendBytes:obuf length:length];
        }
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
