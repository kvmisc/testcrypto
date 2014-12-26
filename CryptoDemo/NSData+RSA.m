//
//  NSData+RSA.m
//  CryptoDemo
//
//  Created by Kevin on 7/11/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "NSData+RSA.h"
#import <openssl/rsa.h>
#import <openssl/pem.h>

#define MakePublicRSA(rsa, key) \
const char *ckey = [key UTF8String]; \
BIO *bio = BIO_new_mem_buf((void *)ckey, strlen(ckey)); \
rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, 0, NULL); \
BIO_free(bio);

#define MakePrivateRSA(rsa, key) \
const char *ckey = [key UTF8String]; \
BIO *bio = BIO_new_mem_buf((void *)ckey, strlen(ckey)); \
rsa = PEM_read_bio_RSAPrivateKey(bio, NULL, 0, NULL); \
BIO_free(bio);


@implementation NSData (RSA)

- (NSData *)RSAEncryptWithPublicKey:(NSString *)key
{
  if ( TKSNonempty(key) ) {
    NSMutableData *encoded = [[NSMutableData alloc] init];
    
    RSA *rsa = NULL;
    MakePublicRSA(rsa, key);
    
    if ( rsa ) {
      int bsize = RSA_size(rsa) - 11;
      int bcount = ceil([self length] / (CGFloat)bsize);
      
      unsigned char ibuf[1024];
      unsigned char obuf[1024];
      
      for ( int i=0; i<bcount; ++i ) {
        int loc = i * bsize;
        int len = MIN((bsize), ([self length] - i*bsize));
        memset(ibuf, 0, 1024);
        [self getBytes:ibuf range:NSMakeRange(loc, len)];
        
        memset(obuf, 0, 1024);
        int length = RSA_public_encrypt(len, ibuf, obuf, rsa, RSA_PKCS1_PADDING);
        [encoded appendBytes:obuf length:length];
      }
    }
    
    return TKDatOrLater(encoded, nil);
  }
  return nil;
}

- (NSData *)RSADecryptWithPrivateKey:(NSString *)key
{
  if ( TKSNonempty(key) ) {
    NSMutableData *encoded = [[NSMutableData alloc] init];
    
    RSA *rsa = NULL;
    MakePrivateRSA(rsa, key);
    
    if ( rsa ) {
      int bsize = RSA_size(rsa);
      int bcount = [self length] / bsize;
      
      if ( ([self length]%bsize)==0 ) {
        unsigned char ibuf[1024];
        unsigned char obuf[1024];
        
        for ( int i=0; i<bcount; ++i ) {
          memset(ibuf, 0, 1024);
          [self getBytes:ibuf range:NSMakeRange((i*bsize), bsize)];
          
          memset(obuf, 0, 1024);
          int length = RSA_private_decrypt(bsize, ibuf, obuf, rsa, RSA_PKCS1_PADDING);
          [encoded appendBytes:obuf length:length];
        }
      }
    }
    
    return TKDatOrLater(encoded, nil);
  }
  return nil;
}


- (NSData *)RSAEncryptWithPrivateKey:(NSString *)key
{
  if ( TKSNonempty(key) ) {
    NSMutableData *encoded = [[NSMutableData alloc] init];
    
    RSA *rsa = NULL;
    MakePrivateRSA(rsa, key);
    
    if ( rsa ) {
      int bsize = RSA_size(rsa) - 11;
      int bcount = ceil([self length] / (CGFloat)bsize);
      
      unsigned char ibuf[1024];
      unsigned char obuf[1024];
      
      for ( int i=0; i<bcount; ++i ) {
        int loc = i * bsize;
        int len = MIN((bsize), ([self length] - i*bsize));
        memset(ibuf, 0, 1024);
        [self getBytes:ibuf range:NSMakeRange(loc, len)];
        
        memset(obuf, 0, 1024);
        int length = RSA_private_encrypt(len, ibuf, obuf, rsa, RSA_PKCS1_PADDING);
        [encoded appendBytes:obuf length:length];
      }
    }
    
    return TKDatOrLater(encoded, nil);
  }
  return nil;
}

- (NSData *)RSADecryptWithPublicKey:(NSString *)key
{
  if ( TKSNonempty(key) ) {
    NSMutableData *encoded = [[NSMutableData alloc] init];
    
    RSA *rsa = NULL;
    MakePublicRSA(rsa, key);
    
    if ( rsa ) {
      int bsize = RSA_size(rsa);
      int bcount = [self length] / bsize;
      
      if ( ([self length]%bsize)==0 ) {
        unsigned char ibuf[1024];
        unsigned char obuf[1024];
        
        for ( int i=0; i<bcount; ++i ) {
          memset(ibuf, 0, 1024);
          [self getBytes:ibuf range:NSMakeRange((i*bsize), bsize)];
          
          memset(obuf, 0, 1024);
          int length = RSA_public_decrypt(bsize, ibuf, obuf, rsa, RSA_PKCS1_PADDING);
          [encoded appendBytes:obuf length:length];
        }
      }
    }
    
    return TKDatOrLater(encoded, nil);
  }
  return nil;
}

@end
