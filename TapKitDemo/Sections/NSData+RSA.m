//
//  NSData+RSA.m
//  TapKitDemo
//
//  Created by Kevin Wu on 7/11/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "NSData+RSA.h"
#import <openssl/rsa.h>
#import <openssl/pem.h>

@implementation NSData (RSA)

- (NSData *)RSAEncryptWithPublicKey:(NSString *)publicKey
{
  NSMutableData *result = [[NSMutableData alloc] init];
  
  RSA *pub_rsa = [self publicRSAWithKey:publicKey];
  
  if ( pub_rsa ) {
    int blk_size = RSA_size(pub_rsa) - 11;
    int blk_count = ceil([self length] / (CGFloat)blk_size);
    
    unsigned char read_buf[1024];
    unsigned char parse_buf[1024];
    
    for ( int i=0; i<blk_count; ++i ) {
      int loc = i * blk_size;
      int len = MIN((blk_size), ([self length] - i*blk_size));
      memset(read_buf, 0, 1024);
      [self getBytes:read_buf range:NSMakeRange(loc, len)];
      
      memset(parse_buf, 0, 1024);
      int parse_count = RSA_public_encrypt(len, read_buf, parse_buf, pub_rsa, RSA_PKCS1_PADDING);
      
      [result appendBytes:parse_buf length:parse_count];
    }
    
  }
  
  return result;
}

- (NSData *)RSADecryptWithPrivateKey:(NSString *)privateKey
{
  NSMutableData *result = [[NSMutableData alloc] init];
  
  RSA *pri_rsa = [self privateRSAWithKey:privateKey];
  
  if ( pri_rsa ) {
    int blk_size = RSA_size(pri_rsa);
    int blk_count = [self length] / blk_size;
    
    if ( ([self length] % blk_size) == 0 ) {
      unsigned char read_buf[1024];
      unsigned char parse_buf[1024];
      
      for ( int i=0; i<blk_count; ++i ) {
        memset(read_buf, 0, 1024);
        [self getBytes:read_buf range:NSMakeRange((i*blk_size), blk_size)];
        
        memset(parse_buf, 0, 1024);
        int parse_count = RSA_private_decrypt(blk_size, read_buf, parse_buf, pri_rsa, RSA_PKCS1_PADDING);
        
        [result appendBytes:parse_buf length:parse_count];
      }
    }
    
  }
  
  return result;
}

- (NSData *)RSAEncryptWithPrivateKey:(NSString *)publicKey
{
  return nil;
}
- (NSData *)RSADecryptWithPublicKey:(NSString *)publicKey
{
  return nil;
}


- (RSA *)publicRSAWithKey:(NSString *)publicKey
{
  if ( [publicKey length]<=0 ) {
    return NULL;
  }
  
  const char *key = [publicKey UTF8String];
  
  BIO *bio = BIO_new_mem_buf((void *)key, strlen(key));
  RSA *rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, 0, NULL);
  BIO_free(bio);
  
  return rsa;
}

- (RSA *)privateRSAWithKey:(NSString *)privateKey
{
  if ( [privateKey length]<=0 ) {
    return NULL;
  }
  
  const char *key = [privateKey UTF8String];
  
  BIO *bio = BIO_new_mem_buf((void *)key, strlen(key));
  RSA *rsa = PEM_read_bio_RSAPrivateKey(bio, NULL, 0, NULL);
  BIO_free(bio);
  
  return rsa;
}

@end
