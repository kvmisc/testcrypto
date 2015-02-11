//
//  NSDataRSA.h
//  CryptoDemo
//
//  Created by Kevin Wu on 12/26/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

//  http://stackoverflow.com/questions/10579985/how-can-i-get-seckeyref-from-der-pem-file
//
//  # Create a certificate signing request with the private key
//  openssl req -new -key private.pem -out cert.csr
//
//  # Create a self-signed certificate with the private key and signing request
//  openssl x509 -req -days 3650 -in cert.csr -signkey private.pem -out cert.crt
//
//  # Convert the certificate to DER format: the certificate contains the public key
//  openssl x509 -outform der -in cert.crt -out cert.der
//
//  # Export the private key and certificate to p12 file
//  openssl pkcs12 -export -inkey private.pem -in cert.crt -out cert.p12


@interface NSData (RSA)

- (NSData *)RSAEncryptedDataWithKey:(SecKeyRef)pubkey;

- (NSData *)RSADecryptedDataWithKey:(SecKeyRef)prikey;



+ (SecKeyRef)RSACreatePublicKey:(NSData *)data;

+ (SecKeyRef)RSACreatePrivateKey:(NSData *)data password:(NSString *)password;

@end
