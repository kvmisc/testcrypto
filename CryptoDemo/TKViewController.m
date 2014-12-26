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
  
  
  NSData *pri = [[NSData alloc] initWithContentsOfFile:TKPathForBundleResource(nil, @"pri2048.key")];
  _privateKey = [[NSString alloc] initWithData:pri encoding:NSUTF8StringEncoding];
  
  NSData *pub = [[NSData alloc] initWithContentsOfFile:TKPathForBundleResource(nil, @"pub2048.key")];
  _publicKey = [[NSString alloc] initWithData:pub encoding:NSUTF8StringEncoding];
}


- (void)doit1:(id)sender
{
  NSString *path = TKPathForBundleResource(nil, @"plain.txt");
  NSData *input = [[NSData alloc] initWithContentsOfFile:path];
  
  
  NSData *encrypt = [self encrypt:input];
  [encrypt writeToFile:TKPathForDocumentResource(@"1encrypt.dat") atomically:YES];
  
  NSData *decrypt = [self decrypt:encrypt];
  [decrypt writeToFile:TKPathForDocumentResource(@"1decrypt.txt") atomically:YES];
}

- (void)doit2:(id)sender
{
  NSString *path = TKPathForBundleResource(nil, @"small.jpg");
  NSData *input = [[NSData alloc] initWithContentsOfFile:path];
  
  
  NSData *encrypt = [self encrypt:input];
  [encrypt writeToFile:TKPathForDocumentResource(@"2encrypt.dat") atomically:YES];
  
  NSData *decrypt = [self decrypt:encrypt];
  [decrypt writeToFile:TKPathForDocumentResource(@"2decrypt.jpg") atomically:YES];
}

- (void)doit3:(id)sender
{
  NSString *path = TKPathForBundleResource(nil, @"medium.jpg");
  NSData *input = [[NSData alloc] initWithContentsOfFile:path];
  
  
  NSData *encrypt = [self encrypt:input];
  [encrypt writeToFile:TKPathForDocumentResource(@"3encrypt.dat") atomically:YES];
  
  NSData *decrypt = [self decrypt:encrypt];
  [decrypt writeToFile:TKPathForDocumentResource(@"3decrypt.jpg") atomically:YES];
}


- (NSData *)doEncrypt:(NSData *)data
{
  //NSData *result = [data AES256EncryptWithKey:@"0123456701234567" iv:_iv];
  
  //return [data RSAEncryptWithPublicKey:_publicKey];
  
  return [data RSAEncryptWithPrivateKey:_privateKey];
}

- (NSData *)doDecrypt:(NSData *)data
{
  //NSData *result = [data AES256DecryptWithKey:@"0123456701234567" iv:_iv];
  
  //return [data RSADecryptWithPrivateKey:_privateKey];
  
  return [data RSADecryptWithPublicKey:_publicKey];
}



- (NSData *)encrypt:(NSData *)data
{
  NSLog(@" ");
  NSLog(@"==============================");
  
  
  NSLog(@"[Encrypt] input: %d", [data length]);
  NSDate *date = [NSDate date];
  NSData *result = [self doEncrypt:data];
  NSLog(@"[Encrypt] time: %f", [[NSDate date] timeIntervalSinceDate:date]);
  NSLog(@"[Encrypt] result:%d", [result length]);
  
  
  NSLog(@"==============================");
  NSLog(@" ");
  
  return result;
}

- (NSData *)decrypt:(NSData *)data
{
  NSLog(@" ");
  NSLog(@"==============================");
  
  
  NSLog(@"[Decrypt] input: %d", [data length]);
  NSDate *date = [NSDate date];
  NSData *result = [self doDecrypt:data];
  NSLog(@"[Decrypt] time: %f", [[NSDate date] timeIntervalSinceDate:date]);
  NSLog(@"[Decrypt] result: %d", [result length]);
  
  
  NSLog(@"==============================");
  NSLog(@" ");
  
  return result;
}

@end
