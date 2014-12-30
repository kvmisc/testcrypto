//
//  TKViewController.h
//  CryptoDemo
//
//  Created by Kevin on 5/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKViewController : UIViewController {
  NSData *_aes128;
  NSData *_aes192;
  NSData *_aes256;
  NSData *_iv;

  NSData *_pri1024;
  NSData *_pub1024;
  NSData *_pri2048;
  NSData *_pub2048;
  
  NSData *_source1;
  NSData *_source2;
  NSData *_source3;
}

@end
