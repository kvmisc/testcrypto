//
//  NSDataCrypto.h
//  CryptoDemo
//
//  Created by Kevin Wu on 2/9/15.
//  Copyright (c) 2015 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

//  http://stackoverflow.com/questions/10579985/how-can-i-get-seckeyref-from-der-pem-file
//
//  //Create a certificate signing request with the private key
//  openssl req -new -key rsaPrivate.pem -out rsaCertReq.csr
//
//  //Create a self-signed certificate with the private key and signing request
//  openssl x509 -req -days 3650 -in rsaCertReq.csr -signkey rsaPrivate.pem -out rsaCert.crt
//
//  //Convert the certificate to DER format: the certificate contains the public key
//  openssl x509 -outform der -in rsaCert.crt -out rsaCert.der
//
//  //Export the private key and certificate to p12 file
//  openssl pkcs12 -export -out rsaPrivate.p12 -inkey rsaPrivate.pem -in rsaCert.crt


@interface NSData (Crypto)

- (NSData *)RSAEncryptPublicKey:(SecKeyRef)keyRef;

- (NSData *)RSADecryptPrivateKey:(SecKeyRef)keyRef;


- (NSData *)RSAEncryptPrivateKey:(SecKeyRef)keyRef;

- (NSData *)RSADecryptPublicKey:(SecKeyRef)keyRef;



+ (SecKeyRef)RSACreatePublicKey:(NSData *)data;

+ (SecKeyRef)RSACreatePrivateKey:(NSData *)data password:(NSString *)password;

@end
