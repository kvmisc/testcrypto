//
//  ViewController.h
//  CryptoDemo
//
//  Created by Kevin Wu on 2/9/15.
//  Copyright (c) 2015 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
  SecKeyRef publicKey;
  SecKeyRef privateKey;
  NSData *publicTag;
  NSData *privateTag;
}
- (void)encryptWithPublicKey:(uint8_t *)plainBuffer cipherBuffer:(uint8_t *)cipherBuffer;
- (void)decryptWithPrivateKey:(uint8_t *)cipherBuffer plainBuffer:(uint8_t *)plainBuffer;
- (SecKeyRef)getPublicKeyRef;
- (SecKeyRef)getPrivateKeyRef;
- (void)testAsymmetricEncryptionAndDecryption;
- (void)generateKeyPair:(NSUInteger)keySize;

@end
