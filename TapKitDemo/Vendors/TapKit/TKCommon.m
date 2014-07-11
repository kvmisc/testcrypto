//
//  TKCommon.m
//  TapKit
//
//  Created by Kevin on 5/21/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKCommon.h"

#pragma mark - System message

void TKPresentSystemMessage(NSString *message)
{
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:message
                                                      message:nil
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                            otherButtonTitles:nil];
  [alertView show];
}



#pragma mark - Bundle image

UIImage *TKCreateImage(NSString *name)
{
  NSString *fileName = TKDeviceSpecificImageName(name, NO);
  NSString *path = TKPathForBundleResource(nil, fileName);
  return [[UIImage alloc] initWithContentsOfFile:path];
}

UIImage *TKCreateResizableImage(NSString *name, UIEdgeInsets insets)
{
  NSString *fileName = TKDeviceSpecificImageName(name, NO);
  NSString *path = TKPathForBundleResource(nil, fileName);
  UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
  return [image resizableImageWithCapInsets:insets];
}


NSString *TKDeviceSpecificImageName(NSString *name, BOOL screen)
{
  if ( [UIScreen mainScreen].scale==2.0 ) {
    
    NSString *extension = [name pathExtension];
    NSString *body = [name substringToIndex:[name rangeOfString:@"."].location];
    
    NSMutableString *newName = [[NSMutableString alloc] initWithString:body];
    
    if ( screen ) {
      if ( [UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone ) {
        if ( [UIScreen mainScreen].bounds.size.height>480.0 ) {
          [newName appendString:@"-568h"];
        }
      }
    }
    
    [newName appendString:@"@2x"];
    [newName appendFormat:@".%@", extension];
    
    return newName;
  }
  return name;
}



#pragma mark - Keyboard

BOOL TKIsKeyboardVisible()
{
  UIWindow *window = [UIApplication sharedApplication].keyWindow;
  UIView *firstResponder = TKFindFirstResponderInView(window);
  return ( firstResponder!=nil );
}

UIView *TKFindFirstResponderInView(UIView *topView)
{
  if ( [topView isFirstResponder] ) {
    return topView;
  }
  
  for ( UIView *subview in topView.subviews ) {
    if ( [subview isFirstResponder] ) {
      return subview;
    }
    
    UIView *firstResponder = TKFindFirstResponderInView(subview);
    if ( firstResponder ) {
      return firstResponder;
    }
  }
  return nil;
}



#pragma mark - Version

NSComparisonResult TKCompareVersion(NSString *version1, NSString *version2)
{
  NSArray *componentAry1 = [version1 componentsSeparatedByString:@"."];
  NSArray *componentAry2 = [version2 componentsSeparatedByString:@"."];
  
  NSUInteger count = MIN([componentAry1 count], [componentAry2 count]);
  
  for ( NSUInteger i=0; i<count; ++i ) {
    NSInteger component1 = [[componentAry1 objectAtIndex:i] integerValue];
    NSInteger component2 = [[componentAry2 objectAtIndex:i] integerValue];
    
    if ( component1>component2 ) {
      return NSOrderedDescending;
    } else if ( component1<component2 ) {
      return NSOrderedAscending;
    }
    
  }
  
  return NSOrderedSame;
}

NSInteger TKMajorVersion(NSString *version)
{
  NSArray *componentAry = [version componentsSeparatedByString:@"."];
  if ( [componentAry count]>=1 ) {
    return [[componentAry objectAtIndex:0] integerValue];
  }
  return 0;
}

NSInteger TKMinorVersion(NSString *version)
{
  NSArray *componentAry = [version componentsSeparatedByString:@"."];
  if ( [componentAry count]>=2 ) {
    return [[componentAry objectAtIndex:1] integerValue];
  }
  return 0;
}

NSInteger TKBugfixVersion(NSString *version)
{
  NSArray *componentAry = [version componentsSeparatedByString:@"."];
  if ( [componentAry count]>=3 ) {
    return [[componentAry objectAtIndex:2] integerValue];
  }
  return 0;
}



#pragma mark - System paths

NSString *TKPathForBundleResource(NSBundle *bundle, NSString *relativePath)
{
  NSBundle *searchBundle = ( (bundle) ? bundle : [NSBundle mainBundle] );
  return [[searchBundle resourcePath] stringByAppendingPathComponent:relativePath];
}

NSString *TKPathForDocumentResource(NSString *relativePath)
{
  static NSString *DocumentPath = nil;
  static dispatch_once_t Token;
  dispatch_once(&Token, ^{
    NSArray *pathAry = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                           NSUserDomainMask,
                                                           YES);
    DocumentPath = [pathAry objectAtIndex:0];
  });
  return [DocumentPath stringByAppendingPathComponent:relativePath];
}

NSString *TKPathForLibraryResource(NSString *relativePath)
{
  static NSString *LibraryPath = nil;
  static dispatch_once_t Token;
  dispatch_once(&Token, ^{
    NSArray *pathAry = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                           NSUserDomainMask,
                                                           YES);
    LibraryPath = [pathAry objectAtIndex:0];
  });
  return [LibraryPath stringByAppendingPathComponent:relativePath];
}

NSString *TKPathForCachesResource(NSString *relativePath)
{
  static NSString *CachesPath = nil;
  static dispatch_once_t Token;
  dispatch_once(&Token, ^{
    NSArray *pathAry = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                           NSUserDomainMask,
                                                           YES);
    CachesPath = [pathAry objectAtIndex:0];
  });
  return [CachesPath stringByAppendingPathComponent:relativePath];
}



#pragma mark - Weak collections

NSMutableArray *TKCreateWeakMutableArray()
{
  return (__bridge_transfer NSMutableArray *)CFArrayCreateMutable(nil, 0, nil);
}

NSMutableDictionary *TKCreateWeakMutableDictionary()
{
  return (__bridge_transfer NSMutableDictionary *)CFDictionaryCreateMutable(nil, 0, nil, nil);
}

NSMutableSet *TKCreateWeakMutableSet()
{
  return (__bridge_transfer NSMutableSet *)CFSetCreateMutable(nil, 0, nil);
}



#pragma mark - Object validaty

BOOL TKIsInstance(id object, Class cls)
{
  return ((object)
          && [object isKindOfClass:cls]
          );
}


BOOL TKIsStringWithText(id object)
{
  return ((object)
          && [object isKindOfClass:[NSString class]]
          && ([((NSString *)object) length]>0)
          );
}

BOOL TKIsDataWithBytes(id object)
{
  return ((object)
          && [object isKindOfClass:[NSData class]]
          && ([((NSData *)object) length]>0)
          );
}

BOOL TKIsArrayWithItems(id object)
{
  return ((object)
          && [object isKindOfClass:[NSArray class]]
          && ([((NSArray *)object) count]>0)
          );
}

BOOL TKIsDictionaryWithItems(id object)
{
  return ((object)
          && [object isKindOfClass:[NSDictionary class]]
          && ([((NSDictionary *)object) count]>0)
          );
}

BOOL TKIsSetWithItems(id object)
{
  return ((object)
          && [object isKindOfClass:[NSSet class]]
          && ([((NSSet *)object) count]>0)
          );
}



#pragma mark - Internet date

NSDateFormatter *TKInternetDateFormatter()
{
  static NSDateFormatter *InternetDateFormatter = nil;
  static dispatch_once_t Token;
  dispatch_once(&Token, ^{
    InternetDateFormatter = [[NSDateFormatter alloc] init];
    
    [InternetDateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    
    [InternetDateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    
    [InternetDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
  });
  return InternetDateFormatter;
}

NSDate *TKInternetDateObject(NSString *string)
{
  return [TKInternetDateFormatter() dateFromString:string];
}

NSString *TKInternetDateString(NSDate *date)
{
  return [TKInternetDateFormatter() stringFromDate:date];
}
