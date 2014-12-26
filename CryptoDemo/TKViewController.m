//
//  TKViewController.m
//  CryptoDemo
//
//  Created by Kevin on 5/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKViewController.h"
#import "NSData+AES.h"
#import "NSData+RSA.h"

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
  
  
  _pri1024 = [[NSData alloc] initWithContentsOfFile:TKPathForBundleResource(nil, @"pri1024.key")];
  _pub1024 = [[NSData alloc] initWithContentsOfFile:TKPathForBundleResource(nil, @"pub1024.key")];
  
  _pri2048 = [[NSData alloc] initWithContentsOfFile:TKPathForBundleResource(nil, @"pri2048.key")];
  _pub2048 = [[NSData alloc] initWithContentsOfFile:TKPathForBundleResource(nil, @"pub2048.key")];
  
  const char *str = "01234567890123456789012345678901";
  _aesKey = [[NSData alloc] initWithBytes:str length:strlen(str)];
  
  
  
  _origin1 = [[NSData alloc] initWithContentsOfFile:TKPathForBundleResource(nil, @"plain.txt")];
  _origin2 = [[NSData alloc] initWithContentsOfFile:TKPathForBundleResource(nil, @"small.jpg")];
  _origin3 = [[NSData alloc] initWithContentsOfFile:TKPathForBundleResource(nil, @"medium.jpg")];
}


- (void)doit1:(id)sender
{
  {
    NSData *data1 = [_origin1 RSAEncryptWithPrivateKey:_pri1024];
    [data1 writeToFile:TKPathForDocumentResource(@"10_en_pri_1024.dat") atomically:YES];
    NSData *data2 = [data1 RSADecryptWithPublicKey:_pub1024];
    [data2 writeToFile:TKPathForDocumentResource(@"11_de_pub_1024.txt") atomically:YES];
  }
  {
    NSData *data1 = [_origin1 RSAEncryptWithPublicKey:_pub1024];
    [data1 writeToFile:TKPathForDocumentResource(@"12_en_pub_1024.dat") atomically:YES];
    NSData *data2 = [data1 RSADecryptWithPrivateKey:_pri1024];
    [data2 writeToFile:TKPathForDocumentResource(@"13_de_pri_1024.txt") atomically:YES];
  }
  {
    NSData *data1 = [_origin1 RSAEncryptWithPrivateKey:_pri2048];
    [data1 writeToFile:TKPathForDocumentResource(@"14_en_pri_2048.dat") atomically:YES];
    NSData *data2 = [data1 RSADecryptWithPublicKey:_pub2048];
    [data2 writeToFile:TKPathForDocumentResource(@"15_de_pub_2048.txt") atomically:YES];
  }
  {
    NSData *data1 = [_origin1 RSAEncryptWithPublicKey:_pub2048];
    [data1 writeToFile:TKPathForDocumentResource(@"16_en_pub_2048.dat") atomically:YES];
    NSData *data2 = [data1 RSADecryptWithPrivateKey:_pri2048];
    [data2 writeToFile:TKPathForDocumentResource(@"17_de_pri_2048.txt") atomically:YES];
  }
//  {
//    NSData *data1 = [_origin1 AES256EncryptWithKey:_aesKey];
//    [data1 writeToFile:TKPathForDocumentResource(@"18_en_aes.dat") atomically:YES];
//    NSData *data2 = [data1 AES256DecryptWithKey:_aesKey];
//    [data2 writeToFile:TKPathForDocumentResource(@"19_de_aes.txt") atomically:YES];
//  }
}

- (void)doit2:(id)sender
{
//  {
//    NSData *data1 = [_origin2 RSAEncryptWithPrivateKey:_pri1024];
//    [data1 writeToFile:TKPathForDocumentResource(@"20_en_pri_1024.dat") atomically:YES];
//    NSData *data2 = [data1 RSADecryptWithPublicKey:_pub1024];
//    [data2 writeToFile:TKPathForDocumentResource(@"21_de_pub_1024.jpg") atomically:YES];
//  }
//  {
//    NSData *data1 = [_origin2 RSAEncryptWithPublicKey:_pub1024];
//    [data1 writeToFile:TKPathForDocumentResource(@"22_en_pub_1024.dat") atomically:YES];
//    NSData *data2 = [data1 RSADecryptWithPrivateKey:_pri1024];
//    [data2 writeToFile:TKPathForDocumentResource(@"23_de_pri_1024.jpg") atomically:YES];
//  }
//  {
//    NSData *data1 = [_origin2 RSAEncryptWithPrivateKey:_pri2048];
//    [data1 writeToFile:TKPathForDocumentResource(@"24_en_pri_2048.dat") atomically:YES];
//    NSData *data2 = [data1 RSADecryptWithPublicKey:_pub2048];
//    [data2 writeToFile:TKPathForDocumentResource(@"25_de_pub_2048.jpg") atomically:YES];
//  }
//  {
//    NSData *data1 = [_origin2 RSAEncryptWithPublicKey:_pub2048];
//    [data1 writeToFile:TKPathForDocumentResource(@"26_en_pub_2048.dat") atomically:YES];
//    NSData *data2 = [data1 RSADecryptWithPrivateKey:_pri2048];
//    [data2 writeToFile:TKPathForDocumentResource(@"27_de_pri_2048.jpg") atomically:YES];
//  }
  {
    NSData *data1 = [_origin2 AES256EncryptWithKey:_aesKey];
    [data1 writeToFile:TKPathForDocumentResource(@"28_en_aes.dat") atomically:YES];
    NSData *data2 = [data1 AES256DecryptWithKey:_aesKey];
    [data2 writeToFile:TKPathForDocumentResource(@"29_de_aes.jpg") atomically:YES];
  }
}

- (void)doit3:(id)sender
{
//  {
//    NSData *data1 = [_origin3 RSAEncryptWithPrivateKey:_pri1024];
//    [data1 writeToFile:TKPathForDocumentResource(@"30_en_pri_1024.dat") atomically:YES];
//    NSData *data2 = [data1 RSADecryptWithPublicKey:_pub1024];
//    [data2 writeToFile:TKPathForDocumentResource(@"31_de_pub_1024.jpg") atomically:YES];
//  }
//  {
//    NSData *data1 = [_origin3 RSAEncryptWithPublicKey:_pub1024];
//    [data1 writeToFile:TKPathForDocumentResource(@"32_en_pub_1024.dat") atomically:YES];
//    NSData *data2 = [data1 RSADecryptWithPrivateKey:_pri1024];
//    [data2 writeToFile:TKPathForDocumentResource(@"33_de_pri_1024.jpg") atomically:YES];
//  }
//  {
//    NSData *data1 = [_origin3 RSAEncryptWithPrivateKey:_pri2048];
//    [data1 writeToFile:TKPathForDocumentResource(@"34_en_pri_2048.dat") atomically:YES];
//    NSData *data2 = [data1 RSADecryptWithPublicKey:_pub2048];
//    [data2 writeToFile:TKPathForDocumentResource(@"35_de_pub_2048.jpg") atomically:YES];
//  }
//  {
//    NSData *data1 = [_origin3 RSAEncryptWithPublicKey:_pub2048];
//    [data1 writeToFile:TKPathForDocumentResource(@"36_en_pub_2048.dat") atomically:YES];
//    NSData *data2 = [data1 RSADecryptWithPrivateKey:_pri2048];
//    [data2 writeToFile:TKPathForDocumentResource(@"37_de_pri_2048.jpg") atomically:YES];
//  }
  {
    NSData *data1 = [_origin3 AES256EncryptWithKey:_aesKey];
    [data1 writeToFile:TKPathForDocumentResource(@"38_en_aes.dat") atomically:YES];
    NSData *data2 = [data1 AES256DecryptWithKey:_aesKey];
    [data2 writeToFile:TKPathForDocumentResource(@"39_de_aes.jpg") atomically:YES];
  }
}

@end
