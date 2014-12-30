//
//  NSDataRSA.m
//  CryptoDemo
//
//  Created by Kevin Wu on 12/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "NSDataRSA.h"

#define ValidData(a) (((a)&&([a length]>0))?(a):(nil))

@implementation NSData (RSA)

- (NSData *)RSAEncryptedDataWithPublicKey:(RSA *)rsa
{
  if ( [self length]>0 ) {
    NSMutableData *result = [[NSMutableData alloc] init];
    if ( rsa ) {
      if ( [self length]<=(RSA_size(rsa)-11) ) {
        unsigned char buffer[2048];
        memset(buffer, 0, 2048);
        int length = RSA_public_encrypt([self length], [self bytes], buffer, rsa, RSA_PKCS1_PADDING);
        if ( length>0 ) {
          [result appendBytes:buffer length:length];
        }
      }
    }
    return ValidData(result);
  }
  return nil;
}

- (NSData *)RSADecryptedDataWithPrivateKey:(RSA *)rsa
{
  if ( [self length]>0 ) {
    NSMutableData *result = [[NSMutableData alloc] init];
    if ( rsa ) {
      if ( [self length]==RSA_size(rsa) ) {
        unsigned char buffer[2048];
        memset(buffer, 0, 2048);
        int length = RSA_private_decrypt([self length], [self bytes], buffer, rsa, RSA_PKCS1_PADDING);
        if ( length>0 ) {
          [result appendBytes:buffer length:length];
        }
      }
    }
    return ValidData(result);
  }
  return nil;
}


- (NSData *)RSAEncryptedDataWithPrivateKey:(RSA *)rsa
{
  if ( [self length]>0 ) {
    NSMutableData *result = [[NSMutableData alloc] init];
    if ( rsa ) {
      if ( [self length]<=(RSA_size(rsa)-11) ) {
        unsigned char buffer[2048];
        memset(buffer, 0, 2048);
        int length = RSA_private_encrypt([self length], [self bytes], buffer, rsa, RSA_PKCS1_PADDING);
        if ( length>0 ) {
          [result appendBytes:buffer length:length];
        }
      }
    }
    return ValidData(result);
  }
  return nil;
}

- (NSData *)RSADecryptedDataWithPublicKey:(RSA *)rsa
{
  if ( [self length]>0 ) {
    NSMutableData *result = [[NSMutableData alloc] init];
    if ( rsa ) {
      if ( [self length]==RSA_size(rsa) ) {
        unsigned char buffer[2048];
        memset(buffer, 0, 2048);
        int length = RSA_public_decrypt([self length], [self bytes], buffer, rsa, RSA_PKCS1_PADDING);
        if ( length>0 ) {
          [result appendBytes:buffer length:length];
        }
      }
    }
    return ValidData(result);
  }
  return nil;
}



+ (RSA *)RSAPublicKey:(NSData *)key
{
  if ( [key length]>0 ) {
    BIO *bio = BIO_new_mem_buf((void *)[key bytes], [key length]);
    RSA *rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, 0, NULL);
    BIO_free(bio);
    return rsa;
  }
  return NULL;
}

+ (RSA *)RSAPrivateKey:(NSData *)key
{
  if ( [key length]>0 ) {
    BIO *bio = BIO_new_mem_buf((void *)[key bytes], [key length]);
    RSA *rsa = PEM_read_bio_RSAPrivateKey(bio, NULL, 0, NULL);
    BIO_free(bio);
    return rsa;
  }
  return NULL;
}

@end
