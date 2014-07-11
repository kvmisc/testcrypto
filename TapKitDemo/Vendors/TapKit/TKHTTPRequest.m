//
//  TKHTTPRequest.m
//  TapKit
//
//  Created by Kevin on 5/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKHTTPRequest.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "TKMacro.h"
#import "TKNAIManager.h"
#import "NSDictionaryAdditions.h"
#import "NSStringAdditions.h"

@implementation TKHTTPRequest

#pragma mark - Initiation

- (id)initWithRequest:(NSURLRequest *)request
{
  self = [super init];
  if ( self ) {
    _request = request;
    
    //_address = nil;
    //_timeoutInterval = 10.0;
    //_cachePolicy = NSURLRequestUseProtocolCachePolicy;
    //_method = @"GET";
    
    //_headerMap = [[NSMutableDictionary alloc] init];
    
    //_fieldMap = nil;
    //_body = nil;
    
    
    //_response = nil;
    //_responseData = nil;
    //_responseFilePath = nil;
    //_responseFileHandle = nil;
    
    
    //_connection = nil;
    
    
    //_bytesWritten = 0;
    //_totalBytesWritten = 0;
    //_totalBytesExpectedToWrite = 0;
    
    //_bytesRead = 0;
    //_totalBytesRead = 0;
    //_totalBytesExpectedToRead = 0;
    
    
    _shouldUpdateNetworkActivityIndicator = YES;
    
    _runLoopMode = NSRunLoopCommonModes;
    
    
    [self transferStatusToReady];
  }
  return self;
}

- (id)initWithAddress:(NSString *)address
{
  self = [super init];
  if ( self ) {
    //_request = nil;
    
    _address = address;
    _timeoutInterval = 10.0;
    _cachePolicy = NSURLRequestUseProtocolCachePolicy;
    _method = @"GET";
    
    _headerMap = [[NSMutableDictionary alloc] init];
    
    //_fieldMap = nil;
    //_body = nil;
    
    
    //_response = nil;
    //_responseData = nil;
    //_responseFilePath = nil;
    //_responseFileHandle = nil;
    
    
    //_connection = nil;
    
    
    //_bytesWritten = 0;
    //_totalBytesWritten = 0;
    //_totalBytesExpectedToWrite = 0;
    
    //_bytesRead = 0;
    //_totalBytesRead = 0;
    //_totalBytesExpectedToRead = 0;
    
    
    _shouldUpdateNetworkActivityIndicator = YES;
    
    _runLoopMode = NSRunLoopCommonModes;
    
    
    [self transferStatusToReady];
  }
  return self;
}

- (id)initWithAddress:(NSString *)address
      timeoutInterval:(NSTimeInterval)timeoutInterval
          cachePolicy:(NSURLRequestCachePolicy)cachePolicy
{
  self = [super init];
  if ( self ) {
    //_request = nil;
    
    _address = address;
    _timeoutInterval = ( (timeoutInterval>0.0) ? timeoutInterval : 10.0 );
    _cachePolicy = ( (cachePolicy==0) ? NSURLRequestUseProtocolCachePolicy : cachePolicy );
    _method = @"GET";
    
    _headerMap = [[NSMutableDictionary alloc] init];
    
    //_fieldMap = nil;
    //_body = nil;
    
    
    //_response = nil;
    //_responseData = nil;
    //_responseFilePath = nil;
    //_responseFileHandle = nil;
    
    
    //_connection = nil;
    
    
    //_bytesWritten = 0;
    //_totalBytesWritten = 0;
    //_totalBytesExpectedToWrite = 0;
    
    //_bytesRead = 0;
    //_totalBytesRead = 0;
    //_totalBytesExpectedToRead = 0;
    
    
    _shouldUpdateNetworkActivityIndicator = YES;
    
    _runLoopMode = NSRunLoopCommonModes;
    
    
    [self transferStatusToReady];
  }
  return self;
}



#pragma mark - Lifecycle

- (void)startAsynchronous
{
  [[[self class] operationQueue] addOperation:self];
}

- (NSData *)startSynchronous
{
  
  if ( [self isCancelled] ) {
    [self transferStatusToFinished];
    return nil;
  }
  
  if ( [self isExecuting] ) {
    // Should not be here.
    return nil;
  }
  
  if ( [self isFinished] ) {
    return _responseData;
  }
  
  if ( [self isReady] ) {
    
    [self startUsingNetwork];
    [self transferStatusFromReadyToExecuting];
    
    NSURLRequest *request = ( (_request) ? _request : [self buildRequest] );
    
    __autoreleasing NSURLResponse *response = nil;
    __autoreleasing NSError *error = nil;
    
    _responseData = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    
    _response = response;
    _error = error;
    
    [self transferStatusFromExecutingToFinished];
    [self stopUsingNetwork];
    
    return _responseData;
  }
  
  return nil;
}

- (void)removeObserverAndCancel
{
  _didStartBlock = nil;
  _didUpdateBlock = nil;
  _didFailBlock = nil;
  _didFinishBlock = nil;
  
  [self cancel];
}



#pragma mark - Request header

- (void)addValue:(NSString *)value forRequestHeader:(NSString *)header
{
  if ( [header length]>0 ) {
    
    if ( value ) {
      [((NSMutableDictionary *)_headerMap) setObject:value forKey:header];
    } else {
      [((NSMutableDictionary *)_headerMap) removeObjectForKey:header];
    }
    
  }
}

- (void)clearRequestHeaders
{
  [((NSMutableDictionary *)_headerMap) removeAllObjects];
}

- (void)setRequestHeaders:(NSDictionary *)dictionary
{
  [((NSMutableDictionary *)_headerMap) removeAllObjects];
  
  for ( NSString *header in [dictionary keyEnumerator] ) {
    NSString *value = [dictionary objectForKey:header];
    [((NSMutableDictionary *)_headerMap) setObject:value forKey:header];
  }
}



#pragma mark - Request body

- (void)addValue:(id)value forFormField:(NSString *)field fileName:(NSString *)fileName
{
  if ( [field length]>0 ) {
    
    if ( !_fieldMap ) {
      _fieldMap = [[NSMutableDictionary alloc] init];
    }
    
    if ( value ) {
      
      if ( [fileName length]>0 ) {
        [((NSMutableDictionary *)_fieldMap) setObject:@{ @"file": fileName, @"data": value } forKey:field];
      } else {
        [((NSMutableDictionary *)_fieldMap) setObject:value forKey:field];
      }
      
    } else {
      
      [((NSMutableDictionary *)_fieldMap) removeObjectForKey:field];
      
    }
    
  }
}

- (void)clearFormFields
{
  [((NSMutableDictionary *)_fieldMap) removeAllObjects];
  _fieldMap = nil;
}


- (void)setRequestBody:(NSData *)body
{
  _body = body;
}



#pragma mark - Private

- (void)startUsingNetwork
{
  if ( _shouldUpdateNetworkActivityIndicator ) {
    [[TKNAIManager sharedObject] addNetworkUser:self];
  }
}

- (void)stopUsingNetwork
{
  if ( _shouldUpdateNetworkActivityIndicator ) {
    [[TKNAIManager sharedObject] removeNetworkUser:self];
  }
}


- (NSURLRequest *)buildRequest
{
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_address]
                                                              cachePolicy:_cachePolicy
                                                          timeoutInterval:_timeoutInterval];
  
  // Request body
  NSData *data = [self buildRequestBody];
  if ( data ) {
    _body = data;
  }
  if ( [_body length]>0 ) {
    [request setHTTPBody:_body];
    [((NSMutableDictionary *)_headerMap) setObject:[NSString stringWithFormat:@"%u", [_body length]]
                                            forKey:@"Content-Length"];
    _method = @"POST";
  }
  
  // Request header
  if ( ![_headerMap hasKeyEqualTo:@"Accept-Encoding"] ) {
    [((NSMutableDictionary *)_headerMap) setObject:@"gzip" forKey:@"Accept-Encoding"];
  }
  if ( ![_headerMap hasKeyEqualTo:@"User-Agent"] ) {
    [((NSMutableDictionary *)_headerMap) setObject:@"tapkit/0.1" forKey:@"User-Agent"];
  }
  for ( NSString *header in [_headerMap keyEnumerator] ) {
    NSString *value = [_headerMap objectForKey:header];
    [request addValue:value forHTTPHeaderField:header];
  }
  
  // Request method
  [request setHTTPMethod:_method];
  
  return request;
}

- (NSData *)buildRequestBody
{
  if ( [_fieldMap count]<=0 ) {
    return nil;
  }
  
  BOOL containsFile = NO;
  
  for ( id value in [_fieldMap objectEnumerator] ) {
    if ( [value isKindOfClass:[NSDictionary class]] ) {
      containsFile = YES;
      break;
    }
  }
  
  NSMutableData *body = [[NSMutableData alloc] init];
  
  if ( containsFile ) {
    
    NSString *boundary = [NSString UUIDString];
    
    [self addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
  forRequestHeader:@"Content-Type"];
    
    NSData *prefixData = [[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *suffixData = [[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    for ( NSString *field in [_fieldMap keyEnumerator] ) {
      
      [body appendData:prefixData];
      
      id value = [_fieldMap objectForKey:field];
      
      if ( [value isKindOfClass:[NSDictionary class]] ) {
        NSString *file = value[ @"file" ];
        NSData *data = value[ @"data" ];
        
        NSMutableString *head = [[NSMutableString alloc] init];
        [head appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", field, file];
        [head appendFormat:@"Content-Type: %@\r\n\r\n", [self MIMETypeOfFile:file]];
        
        [body appendData:[head dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:data];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
      } else {
        NSMutableString *head = [[NSMutableString alloc] init];
        [head appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", field];
        
        [body appendData:[head dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
      }
      
    }
    
    [body appendData:suffixData];
    
  } else {
    
    NSData *queryData = [[_fieldMap URLQueryString] dataUsingEncoding:NSUTF8StringEncoding];
    [body appendData:queryData];
    
  }
  
  
  TKPRINT(@"form-data: %d", [body length]);
  return body;
}


- (NSString *)MIMETypeOfFile:(NSString *)file
{
  CFStringRef UTIType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                              (__bridge CFStringRef)[file pathExtension],
                                                              NULL);
  
  NSString *MIMEType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(UTIType, kUTTagClassMIMEType);
  
  if ( UTIType ) {
    CFRelease(UTIType);
  }
  
  if ( [MIMEType length]<=0 ) {
    return @"application/octet-stream";
  }
  
  return MIMEType;
}


+ (NSOperationQueue *)operationQueue
{
  static NSOperationQueue *OperationQueue = nil;
  static dispatch_once_t Token;
  dispatch_once(&Token, ^{
    OperationQueue = [[NSOperationQueue alloc] init];
    [OperationQueue setMaxConcurrentOperationCount:4];
  });
  return OperationQueue;
}

+ (NSThread *)operationThread
{
  static NSThread *OperationThread = nil;
  static dispatch_once_t Token;
  dispatch_once(&Token, ^{
    OperationThread = [[NSThread alloc] initWithTarget:self
                                              selector:@selector(threadBody:)
                                                object:nil];
    [OperationThread start];
  });
  return OperationThread;
}

+ (void)threadBody:(id)object
{
  while ( YES ) {
    @autoreleasepool {
      [[NSRunLoop currentRunLoop] run];
    }
  }
}



#pragma mark - NSOperation

- (void)start
{
  if ( [self isCancelled] ) {
    [self transferStatusToFinished];
    return;
  }
  
  if ( [self isExecuting] ) {
    return;
  }
  
  if ( [self isFinished] ) {
    return;
  }
  
  if ( [self isReady] ) {
    [self performSelector:@selector(main)
                 onThread:[[self class] operationThread]
               withObject:nil
            waitUntilDone:NO
                    modes:@[ _runLoopMode ]];
  }
}

- (void)cancel
{
  if ( [self isCancelled] ) {
    return;
  }
  
  if ( [self isFinished] ) {
    return;
  }
  
  if ( [self isReady] ) {
  }
  
  if ( [self isExecuting] ) {
    
    [_connection cancel];
    _connection = nil;
    
    _response = nil;
    _responseData = nil;
    //_responseFilePath = nil;
    [_responseFileHandle closeFile];
    _responseFileHandle = nil;
    [[NSFileManager defaultManager] removeItemAtPath:_responseFilePath error:NULL];
    
    [self operationDidFail];
    [self transferStatusFromExecutingToFinished];
    [self stopUsingNetwork];
  }
  
  [super cancel];
}


- (void)main
{
  @autoreleasepool {
    
    if ( ![self isCancelled] ) {
      
      [self startUsingNetwork];
      [self operationDidStart];
      [self transferStatusFromReadyToExecuting];
      
      
      NSURLRequest *request = ( (_request) ? _request : [self buildRequest] );
      
      _connection = [[NSURLConnection alloc] initWithRequest:request
                                                    delegate:self
                                            startImmediately:NO];
      [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:_runLoopMode];
      [_connection start];
      
    }
    
  }
}



#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  _response = response;
  
  if ( _responseFilePath ) {
    [[NSFileManager defaultManager] createFileAtPath:_responseFilePath contents:[NSData data] attributes:nil];
    _responseFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:_responseFilePath];
  } else {
    _responseData = [[NSMutableData alloc] init];
  }
  
  _bytesRead = 0;
  _totalBytesRead = 0;
  _totalBytesExpectedToRead = [[[((NSHTTPURLResponse *)_response) allHeaderFields] objectForKey:@"Content-Length"] integerValue];
  
  [self operationDidUpdate];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  if ( _responseFileHandle ) {
    [_responseFileHandle seekToEndOfFile];
    [_responseFileHandle writeData:data];
    [_responseFileHandle synchronizeFile];
  } else {
    [((NSMutableData *)_responseData) appendData:data];
  }
  
  _bytesRead = [data length];
  _totalBytesRead += _bytesRead;
  //_totalBytesExpectedToRead = 0;
  
  [self operationDidUpdate];
}

- (void)connection:(NSURLConnection *)connection
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
  _bytesWritten = bytesWritten;
  _totalBytesWritten = totalBytesWritten;
  _totalBytesExpectedToWrite = totalBytesExpectedToWrite;
  
  [self operationDidUpdate];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  //_response = nil;
  //_responseData = nil;
  //_responseFilePath = nil;
  [_responseFileHandle closeFile];
  _responseFileHandle = nil;
  //[[NSFileManager defaultManager] removeItemAtPath:_responseFilePath error:NULL];
  
  [self operationDidFinish];
  [self transferStatusFromExecutingToFinished];
  [self stopUsingNetwork];
}

//- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response { return nil; }
//- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request { return nil; }
//
//- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse { return nil; }



#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  _response = nil;
  _responseData = nil;
  //_responseFilePath = nil;
  [_responseFileHandle closeFile];
  _responseFileHandle = nil;
  [[NSFileManager defaultManager] removeItemAtPath:_responseFilePath error:NULL];
  
  [self operationDidFail];
  [self transferStatusFromExecutingToFinished];
  [self stopUsingNetwork];
}

//- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {}
//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace { return NO; }
//- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {}
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {}
//- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection { return NO; }

@end
