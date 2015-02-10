//
//  NSDataRSA.m
//  CryptoDemo
//
//  Created by Kevin Wu on 12/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "NSDataRSA.h"

#define ReleaseObject(ref) {if(ref){CFRelease(ref);ref=NULL;}}

@implementation NSData (RSA)

- (NSData *)RSAEncryptedDataWithKey:(SecKeyRef)pubkey
{
  NSMutableData *result = nil;

  if ( ([self length]>0) && [self length]<=(SecKeyGetBlockSize(pubkey)-11) ) {

    size_t size = SecKeyGetBlockSize(pubkey);

    result = [NSMutableData dataWithLength:size];

    SecKeyEncrypt(pubkey, kSecPaddingPKCS1, [self bytes], [self length], [result mutableBytes], &size);

    [result setLength:size];
  }
  return result;
}

- (NSData *)RSADecryptedDataWithKey:(SecKeyRef)prikey
{
  NSMutableData *result = nil;

  if ( [self length]==SecKeyGetBlockSize(prikey) ) {

    size_t size = [self length];

    result = [NSMutableData dataWithLength:size];

    SecKeyDecrypt(prikey, kSecPaddingPKCS1, [self bytes], [self length], [result mutableBytes], &size);

    [result setLength:size];
  }
  return result;
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
