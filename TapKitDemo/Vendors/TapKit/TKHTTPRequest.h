//
//  TKHTTPRequest.h
//  TapKit
//
//  Created by Kevin on 5/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKOperation.h"

@interface TKHTTPRequest : TKOperation<
    NSURLConnectionDelegate,
    NSURLConnectionDataDelegate
> {
  NSURLRequest *_request;
  
  NSString *_address;
  NSTimeInterval _timeoutInterval;
  NSURLRequestCachePolicy _cachePolicy;
  NSString *_method;
  
  NSDictionary *_headerMap;
  
  NSDictionary *_fieldMap;
  NSData *_body;
  
  
  NSURLResponse *_response;
  NSData *_responseData;
  NSString *_responseFilePath;
  NSFileHandle *_responseFileHandle;
  
  
  NSURLConnection *_connection;
  
  
  NSInteger _bytesWritten;
  NSInteger _totalBytesWritten;
  NSInteger _totalBytesExpectedToWrite;
  
  NSInteger _bytesRead;
  NSInteger _totalBytesRead;
  NSInteger _totalBytesExpectedToRead;
  
  
  BOOL _shouldUpdateNetworkActivityIndicator;
  
  NSString *_runLoopMode;
}

@property (nonatomic, strong, readonly) NSURLRequest *request;

@property (nonatomic, copy, readonly) NSString *address;
@property (nonatomic, readonly) NSTimeInterval timeoutInterval;
@property (nonatomic, readonly) NSURLRequestCachePolicy cachePolicy;
@property (nonatomic, copy, readonly) NSString *method;

@property (nonatomic, strong, readonly) NSDictionary *headerMap;

@property (nonatomic, strong, readonly) NSDictionary *fieldMap;
@property (nonatomic, strong, readonly) NSData *body;


@property (nonatomic, strong, readonly) NSURLResponse *response;
@property (nonatomic, strong, readonly) NSData *responseData;
@property (nonatomic, copy) NSString *responseFilePath;
@property (nonatomic, strong, readonly) NSFileHandle *responseFileHandle;


@property (nonatomic, strong, readonly) NSURLConnection *connection;


@property (nonatomic, readonly) NSInteger bytesWritten;
@property (nonatomic, readonly) NSInteger totalBytesWritten;
@property (nonatomic, readonly) NSInteger totalBytesExpectedToWrite;

@property (nonatomic, readonly) NSInteger bytesRead;
@property (nonatomic, readonly) NSInteger totalBytesRead;
@property (nonatomic, readonly) NSInteger totalBytesExpectedToRead;


@property (nonatomic, assign) BOOL shouldUpdateNetworkActivityIndicator;

@property (nonatomic, copy) NSString *runLoopMode;


///-------------------------------
/// Initiation
///-------------------------------

- (id)initWithRequest:(NSURLRequest *)request;

- (id)initWithAddress:(NSString *)address;

- (id)initWithAddress:(NSString *)address
      timeoutInterval:(NSTimeInterval)timeoutInterval
          cachePolicy:(NSURLRequestCachePolicy)cachePolicy;


///-------------------------------
/// Lifecycle
///-------------------------------

- (void)startAsynchronous;

- (NSData *)startSynchronous;

- (void)removeObserverAndCancel;


///-------------------------------
/// Request header
///-------------------------------

- (void)addValue:(NSString *)value forRequestHeader:(NSString *)header;

- (void)clearRequestHeaders;

- (void)setRequestHeaders:(NSDictionary *)dictionary;


///-------------------------------
/// Request body
///-------------------------------

- (void)addValue:(id)value forFormField:(NSString *)field fileName:(NSString *)fileName;

- (void)clearFormFields;


- (void)setRequestBody:(NSData *)body;

@end
