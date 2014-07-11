//
//  TKCompatibility.h
//  TapKit
//
//  Created by Kevin on 5/21/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 iPhone1,1  iPhone 2G       GSM
 iPhone1,2  iPhone 3G       GSM
 iPhone2,1  iphone 3GS      GSM
 iPhone3,1  iphone 4        GSM         Retina
 iPhone3,2  iphone 4        GSM Rev A   Retina
 iPhone3,3  iphone 4        CDMA        Retina
 iPhone4,1  iPhone 4S       GSM+CDMA    Retina
 iPhone5,1  iPhone 5        GSM         Retina and 4 Inch
 iPhone5,2  iPhone 5        GSM+CDMA    Retina and 4 Inch
 iPhone5,3  iPhone 5C       GSM         Retina and 4 Inch
 iPhone5,4  iPhone 5C       Global      Retina and 4 Inch
 iPhone6,1  iPhone 5S       GSM         Retina and 4 Inch
 iPhone6,2  iPhone 5S       Global      Retina and 4 Inch
 
 iPod1,1    iPod touch 1G
 iPod2,1    iPod touch 2G
 iPod3,1    iPod touch 3G
 iPod4,1    iPod touch 4G               Retina
 iPod5,1    iPod touch 5G               Retina and 4 Inch
 
 iPad1,1    iPad 1G         WiFi
 iPad1,1    iPad 1G         GSM
 iPad2,1    iPad 2          WiFi
 iPad2,2    iPad 2          GSM
 iPad2,3    iPad 2          CDMA
 iPad2,4    iPad 2          WiFi Rev A
 iPad2,5    iPad mini 1G    WiFi
 iPad2,6    iPad mini 1G    GSM
 iPad2,7    iPad mini 1G    GSM+CDMA
 iPad3,1    iPad 3          WiFi        Retina
 iPad3,2    iPad 3          GSM+CDMA    Retina
 iPad3,3    iPad 3          GSM         Retina
 iPad3,4    iPad 4          WiFi        Retina
 iPad3,5    iPad 4          GSM         Retina
 iPad3,6    iPad 4          GSM+CDMA    Retina
 iPad4,1    iPad Air        WiFi        Retina
 iPad4,2    iPad Air        Cellular    Retina
 iPad4,4    iPad mini 2G    WiFi        Retina
 iPad4,5    iPad mini 2G    Cellular    Retina
 
 */

#ifdef __cplusplus
extern "C" {
#endif

///-------------------------------
/// Device compatibility
///-------------------------------

NSString *TKDeviceIdentifier();

NSString *TKDeviceName();

NSString *TKDeviceFamily();


///-------------------------------
/// SDK compatibility
///-------------------------------

BOOL TKIsRetina();

BOOL TKIsPad();

BOOL TKIsPhone();

#ifdef __cplusplus
}
#endif
