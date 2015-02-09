//
//  NSDataCrypto.m
//  CryptoDemo
//
//  Created by Kevin Wu on 2/9/15.
//  Copyright (c) 2015 Tapmob. All rights reserved.
//

#import "NSDataCrypto.h"

#define ReleaseObject(ref) {if(ref){CFRelease(ref);ref=NULL;}}

@implementation NSData (Crypto)

- (NSData *)RSAEncryptPublicKey:(SecKeyRef)keyRef
{
  size_t cipherBufferSize = SecKeyGetBlockSize(keyRef);

  NSMutableData *cipher = [NSMutableData dataWithLength:cipherBufferSize];
  SecKeyEncrypt(keyRef,
                kSecPaddingPKCS1,
                [self bytes],
                [self length],
                [cipher mutableBytes],
                &cipherBufferSize);
  [cipher setLength:cipherBufferSize];

  return cipher;
}

- (NSData *)RSADecryptPrivateKey:(SecKeyRef)keyRef
{
  size_t cipherBufferSize = SecKeyGetBlockSize(keyRef);
  size_t keyBufferSize = [self length];

  NSMutableData *key = [NSMutableData dataWithLength:keyBufferSize];
  SecKeyDecrypt(keyRef,
                kSecPaddingPKCS1,
                [self bytes],
                cipherBufferSize,
                [key mutableBytes],
                &keyBufferSize);
  [key setLength:keyBufferSize];

  return key;
}


- (NSData *)RSAEncryptPrivateKey:(SecKeyRef)keyRef
{
  return nil;
}

- (NSData *)RSADecryptPublicKey:(SecKeyRef)keyRef
{
  return nil;
}



+ (SecKeyRef)RSACreatePublicKey:(NSData *)data
{
  SecKeyRef keyRef = NULL;

  SecCertificateRef certificateRef = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)data);
  if ( certificateRef ) {
    SecPolicyRef policyRef = SecPolicyCreateBasicX509();
    if ( policyRef ) {
      SecTrustRef trustRef;
      if ( SecTrustCreateWithCertificates(certificateRef, policyRef, &trustRef)==errSecSuccess ) {
        SecTrustResultType trustResultType;
        if ( SecTrustEvaluate(trustRef, &trustResultType)==errSecSuccess ) {
          keyRef = SecTrustCopyPublicKey(trustRef);
        }
      }
      ReleaseObject(trustRef);
    }
    ReleaseObject(policyRef);
  }
  ReleaseObject(certificateRef);
  
  return keyRef;
}

+ (SecKeyRef)RSACreatePrivateKey:(NSData *)data password:(NSString *)password
{
  SecKeyRef keyRef = NULL;

  const void *keys[] =   { kSecImportExportPassphrase };
  const void *values[] = { (__bridge CFStringRef)password };
  CFDictionaryRef optionRef = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);

  CFArrayRef itemRef = CFArrayCreate(NULL, 0, 0, NULL);

  OSStatus status = SecPKCS12Import((__bridge CFDataRef)data, optionRef, &itemRef);
  if ( (status==errSecSuccess) && (CFArrayGetCount(itemRef)>0) ) {
    CFDictionaryRef dictionaryRef = CFArrayGetValueAtIndex(itemRef, 0);

    SecIdentityRef identityRef = (SecIdentityRef)CFDictionaryGetValue(dictionaryRef, kSecImportItemIdentity);
    if ( SecIdentityCopyPrivateKey(identityRef, &keyRef)!=errSecSuccess ) {
      keyRef = NULL;
    }
  }
  ReleaseObject(itemRef);
  ReleaseObject(optionRef);

  return keyRef;
}

@end
