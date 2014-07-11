//
//  NSStringAdditions.m
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "NSStringAdditions.h"
#import "NSDataAdditions.h"
#import "NSDictionaryAdditions.h"

@implementation NSString (TapKit)

#pragma mark - UUID

+ (NSString *)UUIDString
{
  CFUUIDRef UUIDRef = CFUUIDCreate(NULL);
  
  NSString *string = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, UUIDRef);
  
  if ( UUIDRef ) {
    CFRelease(UUIDRef);
    UUIDRef = NULL;
  }
  
  return string;
}



#pragma mark - Validity

- (BOOL)isDecimalNumber
{
  return [self isInCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
}

- (BOOL)isWhitespaceAndNewline
{
  return [self isInCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (BOOL)isInCharacterSet:(NSCharacterSet *)characterSet
{
  for ( NSUInteger i=0; i<[self length]; ++i ) {
    if ( ![characterSet characterIsMember:[self characterAtIndex:i]] ) {
      return NO;
    }
  }
  return YES;
}



#pragma mark - Finding

- (NSUInteger)occurTimesOfCharacter:(unichar)character
{
  NSUInteger times = 0;
  for ( NSUInteger i=0; i<[self length]; ++i ) {
    if ( [self characterAtIndex:i]==character ) {
      times++;
    }
  }
  return times;
}



#pragma mark - Hash

- (NSString *)MD5HashString
{
  return [[self dataUsingEncoding:NSUTF8StringEncoding] MD5HashString];
}

- (NSString *)SHA1HashString
{
  return [[self dataUsingEncoding:NSUTF8StringEncoding] SHA1HashString];
}



#pragma mark - URL

- (NSString *)URLEncodedString
{
  return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                               (__bridge CFStringRef)self,
                                                                               NULL,
                                                                               CFSTR("!*'();:@&=+$,/?%#[]<>"),
                                                                               kCFStringEncodingUTF8);
}

- (NSString *)URLDecodedString
{
  return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                               (__bridge CFStringRef)self,
                                                                                               CFSTR(""),
                                                                                               kCFStringEncodingUTF8);
}


- (NSDictionary *)URLQueryDictionary
{
  NSString *queryString = self;
  
  NSRange markRange = [self rangeOfString:@"?"];
  if ( markRange.location!=NSNotFound ) {
    NSUInteger idx = markRange.location + markRange.length;
    queryString = [self substringFromIndex:idx];
  }
  
  NSArray *pairAry = [queryString componentsSeparatedByString:@"&"];
  
  NSMutableDictionary *queryMap = [[NSMutableDictionary alloc] init];
  
  for ( NSString *pair in pairAry ) {
    NSArray *componentAry = [pair componentsSeparatedByString:@"="];
    if ( [componentAry count]==2 ) {
      NSString *key = [componentAry objectAtIndex:0];
      NSString *value = [[componentAry objectAtIndex:1] URLDecodedString];
      [queryMap setObject:value forKey:key];
    }
  }
  
  if ( [queryMap count]>0 ) {
    return queryMap;
  }
  
  return nil;
}

- (NSString *)stringByAddingQueryDictionary:(NSDictionary *)dictionary
{
  NSString *queryString = [dictionary URLQueryString];
  
  if ( [queryString length]>0 ) {
    
    NSMutableString *string = [[NSMutableString alloc] initWithString:self];
    
    if ( [string rangeOfString:@"?"].location==NSNotFound ) {
      [string appendString:@"?"];
    }
    
    if ( (![string hasSuffix:@"&"]) && (![string hasSuffix:@"?"]) ) {
      [string appendString:@"&"];
    }
    
    [string appendString:queryString];
    
    return string;
  }
  return self;
}

- (NSString *)stringByAppendingQueryValue:(NSString *)value forKey:(NSString *)key
{
  if ( [key length]>0 ) {
    NSString *fixedValue = ( ([value length]>0) ? value : @"" );
    return [self stringByAddingQueryDictionary:@{ key: fixedValue }];
  }
  return self;
}

@end
