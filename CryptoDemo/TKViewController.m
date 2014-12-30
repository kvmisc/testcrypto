//
//  TKViewController.m
//  CryptoDemo
//
//  Created by Kevin on 5/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKViewController.h"
#import "NSDataAES.h"
#import "NSDataRSA.h"

@implementation TKViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  button.frame = CGRectMake(10, 10, 300, 40);
  [button addTarget:self action:@selector(doit1:) forControlEvents:UIControlEventTouchUpInside];
  button.layer.borderWidth = 1;
  button.layer.borderColor = [UIColor blackColor].CGColor;
  [self.view addSubview:button];
  
  button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  button.frame = CGRectMake(10, 60, 300, 40);
  [button addTarget:self action:@selector(doit2:) forControlEvents:UIControlEventTouchUpInside];
  button.layer.borderWidth = 1;
  button.layer.borderColor = [UIColor blackColor].CGColor;
  [self.view addSubview:button];
  
  button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  button.frame = CGRectMake(10, 110, 300, 40);
  [button addTarget:self action:@selector(doit3:) forControlEvents:UIControlEventTouchUpInside];
  button.layer.borderWidth = 1;
  button.layer.borderColor = [UIColor blackColor].CGColor;
  [self.view addSubview:button];
  

  _aes128 = [NSData AES128GenerateKey];
  _aes192 = [NSData AES192GenerateKey];
  _aes256 = [NSData AES256GenerateKey];
  _iv = [NSData AESGenerateIV];

  _pri1024 = [[NSData alloc] initWithContentsOfFile:TKPathForBundleResource(nil, @"pri1024.pem")];
  _pub1024 = [[NSData alloc] initWithContentsOfFile:TKPathForBundleResource(nil, @"pub1024.pem")];
  _pri2048 = [[NSData alloc] initWithContentsOfFile:TKPathForBundleResource(nil, @"pri2048.pem")];
  _pub2048 = [[NSData alloc] initWithContentsOfFile:TKPathForBundleResource(nil, @"pub2048.pem")];

  _source1 = [[NSData alloc] initWithContentsOfFile:TKPathForBundleResource(nil, @"plain.txt")];
  _source2 = [[NSData alloc] initWithContentsOfFile:TKPathForBundleResource(nil, @"small.jpg")];
  _source3 = [[NSData alloc] initWithContentsOfFile:TKPathForBundleResource(nil, @"big.jpg")];
}


- (void)doit1:(id)sender
{
  [self AESSample];
}

- (void)doit2:(id)sender
{
  [self RSASample];
}

- (void)doit3:(id)sender
{
}


- (void)AESSample
{
  NSString *name = nil;

  {
    NSData *source = _source1;
    {
      NSData *encrypt = [source AESEncryptedDataWithKey:_aes128 iv:_iv];
      name = [NSString stringWithFormat:@"10_aes128_en_%dto%d.dat", [source length], [encrypt length]];
      [encrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];

      NSData *decrypt = [encrypt AESDecryptedDataWithKey:_aes128 iv:_iv];
      name = [NSString stringWithFormat:@"11_aes128_de_%dto%d.txt", [encrypt length], [decrypt length]];
      [decrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];
    }
    {
      NSData *encrypt = [source AESEncryptedDataWithKey:_aes192 iv:_iv];
      name = [NSString stringWithFormat:@"12_aes192_en_%dto%d.dat", [source length], [encrypt length]];
      [encrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];

      NSData *decrypt = [encrypt AESDecryptedDataWithKey:_aes192 iv:_iv];
      name = [NSString stringWithFormat:@"13_aes192_de_%dto%d.txt", [encrypt length], [decrypt length]];
      [decrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];
    }
    {
      NSData *encrypt = [source AESEncryptedDataWithKey:_aes256 iv:_iv];
      name = [NSString stringWithFormat:@"14_aes256_en_%dto%d.dat", [source length], [encrypt length]];
      [encrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];

      NSData *decrypt = [encrypt AESDecryptedDataWithKey:_aes256 iv:_iv];
      name = [NSString stringWithFormat:@"15_aes256_de_%dto%d.txt", [encrypt length], [decrypt length]];
      [decrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];
    }
  }

  {
    NSData *source = _source2;
    {
      NSData *encrypt = [source AESEncryptedDataWithKey:_aes128 iv:_iv];
      name = [NSString stringWithFormat:@"20_aes128_en_%dto%d.dat", [source length], [encrypt length]];
      [encrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];

      NSData *decrypt = [encrypt AESDecryptedDataWithKey:_aes128 iv:_iv];
      name = [NSString stringWithFormat:@"21_aes128_de_%dto%d.jpg", [encrypt length], [decrypt length]];
      [decrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];
    }
    {
      NSData *encrypt = [source AESEncryptedDataWithKey:_aes192 iv:_iv];
      name = [NSString stringWithFormat:@"22_aes192_en_%dto%d.dat", [source length], [encrypt length]];
      [encrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];

      NSData *decrypt = [encrypt AESDecryptedDataWithKey:_aes192 iv:_iv];
      name = [NSString stringWithFormat:@"23_aes192_de_%dto%d.jpg", [encrypt length], [decrypt length]];
      [decrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];
    }
    {
      NSData *encrypt = [source AESEncryptedDataWithKey:_aes256 iv:_iv];
      name = [NSString stringWithFormat:@"24_aes256_en_%dto%d.dat", [source length], [encrypt length]];
      [encrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];

      NSData *decrypt = [encrypt AESDecryptedDataWithKey:_aes256 iv:_iv];
      name = [NSString stringWithFormat:@"25_aes256_de_%dto%d.jpg", [encrypt length], [decrypt length]];
      [decrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];
    }
  }

  {
    NSData *source = _source3;
    {
      NSData *encrypt = [source AESEncryptedDataWithKey:_aes128 iv:_iv];
      name = [NSString stringWithFormat:@"30_aes128_en_%dto%d.dat", [source length], [encrypt length]];
      [encrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];

      NSData *decrypt = [encrypt AESDecryptedDataWithKey:_aes128 iv:_iv];
      name = [NSString stringWithFormat:@"31_aes128_de_%dto%d.jpg", [encrypt length], [decrypt length]];
      [decrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];
    }
    {
      NSData *encrypt = [source AESEncryptedDataWithKey:_aes192 iv:_iv];
      name = [NSString stringWithFormat:@"32_aes192_en_%dto%d.dat", [source length], [encrypt length]];
      [encrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];

      NSData *decrypt = [encrypt AESDecryptedDataWithKey:_aes192 iv:_iv];
      name = [NSString stringWithFormat:@"33_aes192_de_%dto%d.jpg", [encrypt length], [decrypt length]];
      [decrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];
    }
    {
      NSData *encrypt = [source AESEncryptedDataWithKey:_aes256 iv:_iv];
      name = [NSString stringWithFormat:@"34_aes256_en_%dto%d.dat", [source length], [encrypt length]];
      [encrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];

      NSData *decrypt = [encrypt AESDecryptedDataWithKey:_aes256 iv:_iv];
      name = [NSString stringWithFormat:@"35_aes256_de_%dto%d.jpg", [encrypt length], [decrypt length]];
      [decrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];
    }
  }
}

- (void)RSASample
{
  NSString *name = nil;

  NSData *source = _source1;

  {
    RSA *pubkey = [NSData RSAPublicKey:_pub1024];
    RSA *prikey = [NSData RSAPrivateKey:_pri1024];
    {
      NSData *encrypt = [source RSAEncryptedDataWithPublicKey:pubkey];
      name = [NSString stringWithFormat:@"60_rsa1024_en_pub_%dto%d.dat", [source length], [encrypt length]];
      [encrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];

      NSData *decrypt = [encrypt RSADecryptedDataWithPrivateKey:prikey];
      name = [NSString stringWithFormat:@"61_rsa1024_de_pri_%dto%d.txt", [encrypt length], [decrypt length]];
      [decrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];
    }
    {
      NSData *encrypt = [source RSAEncryptedDataWithPrivateKey:prikey];
      name = [NSString stringWithFormat:@"62_rsa1024_en_pri_%dto%d.dat", [source length], [encrypt length]];
      [encrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];

      NSData *decrypt = [encrypt RSADecryptedDataWithPublicKey:pubkey];
      name = [NSString stringWithFormat:@"63_rsa1024_de_pub_%dto%d.txt", [encrypt length], [decrypt length]];
      [decrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];
    }
  }
  {
    RSA *pubkey = [NSData RSAPublicKey:_pub2048];
    RSA *prikey = [NSData RSAPrivateKey:_pri2048];
    {
      NSData *encrypt = [source RSAEncryptedDataWithPublicKey:pubkey];
      name = [NSString stringWithFormat:@"64_rsa2048_en_pub_%dto%d.dat", [source length], [encrypt length]];
      [encrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];

      NSData *decrypt = [encrypt RSADecryptedDataWithPrivateKey:prikey];
      name = [NSString stringWithFormat:@"65_rsa2048_de_pri_%dto%d.txt", [encrypt length], [decrypt length]];
      [decrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];
    }
    {
      NSData *encrypt = [source RSAEncryptedDataWithPrivateKey:prikey];
      name = [NSString stringWithFormat:@"66_rsa2048_en_pri_%dto%d.dat", [source length], [encrypt length]];
      [encrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];

      NSData *decrypt = [encrypt RSADecryptedDataWithPublicKey:pubkey];
      name = [NSString stringWithFormat:@"67_rsa2048_de_pub_%dto%d.txt", [encrypt length], [decrypt length]];
      [decrypt writeToFile:TKPathForDocumentResource(name) atomically:YES];
    }
  }
}

@end
