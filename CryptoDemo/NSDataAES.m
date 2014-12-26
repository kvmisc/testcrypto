//
//  NSDataAES.m
//  CryptoDemo
//
//  Created by Kevin Wu on 12/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "NSDataAES.h"
#import <openssl/aes.h>
#import <openssl/evp.h>

@implementation NSData (AES)

//- (NSData *)encrypt:(NSData *)aaa
//{
//  
//  
//  // AES_BLOCK_SIZE = 16
//  unsigned char key[AES_BLOCK_SIZE];
//  // Generate AES 128-bit key
//  for ( int i=0; i<16; ++i) {
//    key[i] = 32 + i;
//  }
//  
//  unsigned char* input_string;
//  unsigned char* encrypt_string;
//  unsigned char* decrypt_string;
//  unsigned int len;        // encrypt length (in multiple of AES_BLOCK_SIZE)
//  unsigned int i;
//  
//  unsigned char *param = NULL;
//  
//  // set the encryption length
//  len = 0;
//  if ((strlen(param) + 1) % AES_BLOCK_SIZE == 0) {
//    len = strlen(param) + 1;
//  } else {
//    len = ((strlen(param) + 1) / AES_BLOCK_SIZE + 1) * AES_BLOCK_SIZE;
//  }
//  
//  // set the input string
//  input_string = (unsigned char*)calloc(len, sizeof(unsigned char));
//  
//  strncpy((char*)input_string, param, strlen(param));
//  
//
//  AES_KEY aes;
//  
//  
//  AES_set_encrypt_key(key, 128, &aes);
//  encrypt_string = (unsigned char*)calloc(len, sizeof(unsigned char));
//  AES_ecb_encrypt(input_string, encrypt_string, &aes, AES_ENCRYPT);
//  
//  
//  decrypt_string = (unsigned char*)calloc(len, sizeof(unsigned char));
//  AES_set_decrypt_key(key, 128, &aes);
//  AES_ecb_encrypt(encrypt_string, decrypt_string, &aes, AES_DECRYPT);
//  
//  
//  
//  // print
//  printf("input_string = %s\n", input_string);
//  printf("encrypted string = ");
//  for (i=0; i<len; ++i) {
//    printf("%x%x", (encrypt_string[i] >> 4) & 0xf,
//           encrypt_string[i] & 0xf);
//  }
//  printf("\n");
//  printf("decrypted string = %s\n", decrypt_string);
//  return nil;
//}


- (NSData *)AES256EncryptWithKey:(NSData *)key
{
  if ( TKDNonempty(key) && ([self length]>0) ) {
    
    NSData *encoded = nil;
    
    EVP_CIPHER_CTX *cipher = malloc(sizeof(EVP_CIPHER_CTX));
    if ( cipher ) {
      EVP_CIPHER_CTX_init(cipher);
      
      unsigned char *obuf = malloc([self length] + AES_BLOCK_SIZE);
      if ( obuf ) {
        int olen = 0;
        
        EVP_EncryptInit(cipher, EVP_aes_256_ecb(), [key bytes], NULL);
        
        int tmp = 0;
        EVP_EncryptUpdate(cipher, obuf, &tmp, [self bytes], [self length]);
        olen += tmp;
        EVP_EncryptFinal(cipher, obuf+olen, &tmp);
        olen += tmp;
        
        EVP_CIPHER_CTX_cleanup(cipher);
        
        if ( olen>0 ) {
          unsigned char *buffer = malloc(olen);
          if ( buffer ) {
            memset(buffer, 0, olen);
            memcpy(buffer, obuf, olen);
            encoded = [[NSData alloc] initWithBytesNoCopy:buffer length:olen];
          }
        }
        free(obuf);
      }
      free(cipher);
    }
    
    return TKDatOrLater(encoded, nil);
  }
  return nil;
}

- (NSData *)AES256DecryptWithKey:(NSData *)key
{
  if ( TKDNonempty(key) && ([self length]>0) ) {
    
    NSData *encoded = nil;
    
    EVP_CIPHER_CTX *cipher = malloc(sizeof(EVP_CIPHER_CTX));
    if ( cipher ) {
      EVP_CIPHER_CTX_init(cipher);
      
      unsigned char *obuf = malloc([self length] + AES_BLOCK_SIZE);
      if ( obuf ) {
        int olen = 0;
        
        EVP_DecryptInit(cipher, EVP_aes_256_ecb(), [key bytes], NULL);
        
        int tmp = 0;
        EVP_DecryptUpdate(cipher, obuf, &tmp, [self bytes], [self length]);
        olen += tmp;
        EVP_DecryptFinal(cipher, obuf+olen, &tmp);
        olen += tmp;
        
        EVP_CIPHER_CTX_cleanup(cipher);
        
        if ( olen>0 ) {
          unsigned char *buffer = malloc(olen);
          if ( buffer ) {
            memset(buffer, 0, olen);
            memcpy(buffer, obuf, olen);
            encoded = [[NSData alloc] initWithBytesNoCopy:buffer length:olen];
          }
        }
        free(obuf);
      }
      free(cipher);
    }
    
    return TKDatOrLater(encoded, nil);
  }
  return nil;
}

@end
