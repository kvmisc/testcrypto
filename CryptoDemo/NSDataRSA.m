//
//  NSDataRSA.m
//  CryptoDemo
//
//  Created by Kevin Wu on 12/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "NSDataRSA.h"

#define RELEASE(object) if(object)CFRelease(object);

@implementation NSData (RSA)

- (NSData *)RSAEncryptedDataWithPublicKey:(SecKeyRef)keyRef
{
  if ( [self length]>0 ) {
    size_t blockSize = SecKeyGetBlockSize(keyRef);
    if ( [self length]<=(blockSize-11) ) {
      size_t cipherLength = [self length];
      NSMutableData *cipher = [[NSMutableData alloc] initWithLength:blockSize];
      
      SecKeyEncrypt(keyRef,
                    kSecPaddingPKCS1,
                    [self bytes],
                    [self length],
                    [cipher mutableBytes],
                    &cipherLength);
      return cipher;
    }
  }
  return nil;
}

- (NSData *)RSADecryptedDataWithPrivateKey:(SecKeyRef)keyRef
{
  if ( [self length]>0 ) {
    size_t blockSize = SecKeyGetBlockSize(keyRef);
    if ( [self length]==blockSize ) {
      size_t cipherLength = [self length];
      NSMutableData *cipher = [[NSMutableData alloc] initWithLength:blockSize];
      
      SecKeyDecrypt(keyRef,
                    kSecPaddingPKCS1,
                    [self bytes],
                    [self length],
                    [cipher mutableBytes],
                    &cipherLength);
      return cipher;
    }
  }
  return nil;
}


+ (SecKeyRef)RSAPublicKeyFromDERData:(NSData *)data
{
  SecKeyRef keyRef = NULL;
  
  if ( [data length]>0 ) {
    SecCertificateRef certificateRef = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)data);
    SecPolicyRef policyRef = SecPolicyCreateBasicX509();
    SecTrustRef trustRef = NULL;
    OSStatus status = SecTrustCreateWithCertificates(certificateRef, policyRef, &trustRef);
    
    if ( status==errSecSuccess ) {
      SecTrustResultType resultType;
      status = SecTrustEvaluate(trustRef, &resultType);
      if ( status==errSecSuccess ) {
        keyRef = SecTrustCopyPublicKey(trustRef);
      }
    }
    RELEASE(certificateRef);
    RELEASE(policyRef);
    RELEASE(trustRef);
  }
  return keyRef;
}

+ (SecKeyRef)RSAPrivateKeyFromPFXData:(NSData *)data password:(NSString *)password
{
  SecKeyRef keyRef = NULL;
  if ( [data length]>0 ) {
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { (__bridge CFStringRef)password };
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus status = SecPKCS12Import((__bridge CFDataRef)data, options, &items);
    
    if ( status==errSecSuccess ) {
      CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(items, 0);
      SecIdentityRef identityRef = (SecIdentityRef)CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
      SecTrustRef trustRef = (SecTrustRef)CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
      
      SecTrustResultType resultType;
      status = SecTrustEvaluate(trustRef, &resultType);
      
      status = SecIdentityCopyPrivateKey(identityRef, &keyRef);
      
      RELEASE(trustRef);
      RELEASE(identityRef);
    }
    RELEASE(options);
  }
  return keyRef;
}

//- (NSData *)RSAEncryptWithPublicKey:(NSData *)key
//{
//  if ( TKDNonempty(key) && ([self length]>0) ) {
//    BIO *bio = BIO_new_mem_buf((void *)[key bytes], [key length]);
//    RSA *rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, 0, NULL);
//    BIO_free(bio);
//
//    if ( rsa ) {
//      NSMutableData *encoded = [[NSMutableData alloc] init];
//
//      int bsize = RSA_size(rsa) - 11;
//      int bcount = ceil([self length] / (CGFloat)bsize);
//
//      unsigned char ibuf[1024];
//      unsigned char obuf[1024];
//
//      for ( int i=0; i<bcount; ++i ) {
//        int loc = i * bsize;
//        int len = MIN((bsize), ([self length] - i*bsize));
//        memset(ibuf, 0, 1024);
//        [self getBytes:ibuf range:NSMakeRange(loc, len)];
//
//        memset(obuf, 0, 1024);
//        int length = RSA_public_encrypt(len, ibuf, obuf, rsa, RSA_PKCS1_PADDING);
//        [encoded appendBytes:obuf length:length];
//      }
//
//      return TKDatOrLater(encoded, nil);
//    }
//  }
//  return nil;
//}

//- (NSData *)RSAEncryptWithPublicKey:(NSData *)key
//{
//  if ( TKDNonempty(key) && ([self length]>0) ) {
//    BIO *bio = BIO_new_mem_buf((void *)[key bytes], [key length]);
//    RSA *rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, 0, NULL);
//    BIO_free(bio);
//    
//    if ( rsa ) {
//      NSMutableData *encoded = [[NSMutableData alloc] init];
//      
//      int bsize = RSA_size(rsa) - 11;
//      int bcount = ceil([self length] / (CGFloat)bsize);
//      
//      unsigned char ibuf[1024];
//      unsigned char obuf[1024];
//      
//      for ( int i=0; i<bcount; ++i ) {
//        int loc = i * bsize;
//        int len = MIN((bsize), ([self length] - i*bsize));
//        memset(ibuf, 0, 1024);
//        [self getBytes:ibuf range:NSMakeRange(loc, len)];
//        
//        memset(obuf, 0, 1024);
//        int length = RSA_public_encrypt(len, ibuf, obuf, rsa, RSA_PKCS1_PADDING);
//        [encoded appendBytes:obuf length:length];
//      }
//      
//      return TKDatOrLater(encoded, nil);
//    }
//  }
//  return nil;
//}

//- (NSData *)RSADecryptWithPrivateKey:(NSData *)key
//{
//  if ( TKDNonempty(key) && ([self length]>0) ) {
//    BIO *bio = BIO_new_mem_buf((void *)[key bytes], [key length]);
//    RSA *rsa = PEM_read_bio_RSAPrivateKey(bio, NULL, 0, NULL);
//    BIO_free(bio);
//    
//    if ( rsa ) {
//      NSMutableData *encoded = [[NSMutableData alloc] init];
//      
//      int bsize = RSA_size(rsa);
//      int bcount = [self length] / bsize;
//      
//      if ( ([self length]%bsize)==0 ) {
//        unsigned char ibuf[1024];
//        unsigned char obuf[1024];
//        
//        for ( int i=0; i<bcount; ++i ) {
//          memset(ibuf, 0, 1024);
//          [self getBytes:ibuf range:NSMakeRange((i*bsize), bsize)];
//          
//          memset(obuf, 0, 1024);
//          int length = RSA_private_decrypt(bsize, ibuf, obuf, rsa, RSA_PKCS1_PADDING);
//          [encoded appendBytes:obuf length:length];
//        }
//      }
//      
//      return TKDatOrLater(encoded, nil);
//    }
//  }
//  return nil;
//}
//
//
//- (NSData *)RSAEncryptWithPrivateKey:(NSData *)key
//{
//  if ( TKDNonempty(key) && ([self length]>0) ) {
//    BIO *bio = BIO_new_mem_buf((void *)[key bytes], [key length]);
//    RSA *rsa = PEM_read_bio_RSAPrivateKey(bio, NULL, 0, NULL);
//    BIO_free(bio);
//    
//    if ( rsa ) {
//      NSMutableData *encoded = [[NSMutableData alloc] init];
//      
//      int bsize = RSA_size(rsa) - 11;
//      int bcount = ceil([self length] / (CGFloat)bsize);
//      
//      unsigned char ibuf[1024];
//      unsigned char obuf[1024];
//      
//      for ( int i=0; i<bcount; ++i ) {
//        int loc = i * bsize;
//        int len = MIN((bsize), ([self length] - i*bsize));
//        memset(ibuf, 0, 1024);
//        [self getBytes:ibuf range:NSMakeRange(loc, len)];
//        
//        memset(obuf, 0, 1024);
//        int length = RSA_private_encrypt(len, ibuf, obuf, rsa, RSA_PKCS1_PADDING);
//        [encoded appendBytes:obuf length:length];
//      }
//      
//      return TKDatOrLater(encoded, nil);
//    }
//  }
//  return nil;
//}
//
//- (NSData *)RSADecryptWithPublicKey:(NSData *)key
//{
//  if ( TKDNonempty(key) && ([self length]>0) ) {
//    BIO *bio = BIO_new_mem_buf((void *)[key bytes], [key length]);
//    RSA *rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, 0, NULL);
//    BIO_free(bio);
//    
//    if ( rsa ) {
//      NSMutableData *encoded = [[NSMutableData alloc] init];
//      
//      int bsize = RSA_size(rsa);
//      int bcount = [self length] / bsize;
//      
//      if ( ([self length]%bsize)==0 ) {
//        unsigned char ibuf[1024];
//        unsigned char obuf[1024];
//        
//        for ( int i=0; i<bcount; ++i ) {
//          memset(ibuf, 0, 1024);
//          [self getBytes:ibuf range:NSMakeRange((i*bsize), bsize)];
//          
//          memset(obuf, 0, 1024);
//          int length = RSA_public_decrypt(bsize, ibuf, obuf, rsa, RSA_PKCS1_PADDING);
//          [encoded appendBytes:obuf length:length];
//        }
//      }
//      
//      return TKDatOrLater(encoded, nil);
//    }
//  }
//  return nil;
//}

@end
