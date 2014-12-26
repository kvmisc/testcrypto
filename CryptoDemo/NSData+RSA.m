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

@implementation NSData (RSA)

- (NSData *)RSAEncryptWithPublicKey:(NSData *)key
{
  if ( TKDNonempty(key) ) {
    BIO *bio = BIO_new_mem_buf((void *)[key bytes], [key length]);
    RSA *rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, 0, NULL);
    BIO_free(bio);
    
    if ( rsa ) {
      NSMutableData *encoded = [[NSMutableData alloc] init];
      
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
      
      return TKDatOrLater(encoded, nil);
    }
  }
  return nil;
}

- (NSData *)RSADecryptWithPrivateKey:(NSData *)key
{
  if ( TKDNonempty(key) ) {
    BIO *bio = BIO_new_mem_buf((void *)[key bytes], [key length]);
    RSA *rsa = PEM_read_bio_RSAPrivateKey(bio, NULL, 0, NULL);
    BIO_free(bio);
    
    if ( rsa ) {
      NSMutableData *encoded = [[NSMutableData alloc] init];
      
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
      
      return TKDatOrLater(encoded, nil);
    }
  }
  return nil;
}


- (NSData *)RSAEncryptWithPrivateKey:(NSData *)key
{
  if ( TKDNonempty(key) ) {
    BIO *bio = BIO_new_mem_buf((void *)[key bytes], [key length]);
    RSA *rsa = PEM_read_bio_RSAPrivateKey(bio, NULL, 0, NULL);
    BIO_free(bio);
    
    if ( rsa ) {
      NSMutableData *encoded = [[NSMutableData alloc] init];
      
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
      
      return TKDatOrLater(encoded, nil);
    }
  }
  return nil;
}

- (NSData *)RSADecryptWithPublicKey:(NSData *)key
{
  if ( TKDNonempty(key) ) {
    BIO *bio = BIO_new_mem_buf((void *)[key bytes], [key length]);
    RSA *rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, 0, NULL);
    BIO_free(bio);
    
    if ( rsa ) {
      NSMutableData *encoded = [[NSMutableData alloc] init];
      
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
      
      return TKDatOrLater(encoded, nil);
    }
  }
  return nil;
}

@end
