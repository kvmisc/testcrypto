//
//  TKCompatibility.m
//  TapKit
//
//  Created by Kevin on 5/21/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "TKCompatibility.h"
#include <sys/sysctl.h>

#pragma mark - Device compatibility

NSString *TKDeviceIdentifier()
{
  char buffer[128];
  bzero(buffer, 128);
  
  size_t size = 128;
  
  sysctlbyname("hw.machine", buffer, &size, NULL, 0);
  
  return [[NSString alloc] initWithCString:buffer encoding:NSUTF8StringEncoding];
}

NSString *TKDeviceName()
{
  NSString *identifier = TKDeviceIdentifier();
  
  if ( [identifier isEqualToString:@"iPhone1,1"] ) return @"iPhone 2G";
  if ( [identifier isEqualToString:@"iPhone1,2"] ) return @"iPhone 3G";
  if ( [identifier isEqualToString:@"iPhone2,1"] ) return @"iPhone 3GS";
  if ( [identifier isEqualToString:@"iPhone3,1"] ) return @"iPhone 4";
  if ( [identifier isEqualToString:@"iPhone3,2"] ) return @"iPhone 4";
  if ( [identifier isEqualToString:@"iPhone3,3"] ) return @"iPhone 4";
  if ( [identifier isEqualToString:@"iPhone4,1"] ) return @"iPhone 4S";
  if ( [identifier isEqualToString:@"iPhone5,1"] ) return @"iPhone 5";
  if ( [identifier isEqualToString:@"iPhone5,2"] ) return @"iPhone 5";
  if ( [identifier isEqualToString:@"iPhone5,3"] ) return @"iPhone 5C";
  if ( [identifier isEqualToString:@"iPhone5,4"] ) return @"iPhone 5C";
  if ( [identifier isEqualToString:@"iPhone6,1"] ) return @"iPhone 5S";
  if ( [identifier isEqualToString:@"iPhone6,2"] ) return @"iPhone 5S";
  
  if ( [identifier isEqualToString:@"iPod1,1"] ) return @"iPod touch 1G";
  if ( [identifier isEqualToString:@"iPod2,1"] ) return @"iPod touch 2G";
  if ( [identifier isEqualToString:@"iPod3,1"] ) return @"iPod touch 3G";
  if ( [identifier isEqualToString:@"iPod4,1"] ) return @"iPod touch 4G";
  if ( [identifier isEqualToString:@"iPod5,1"] ) return @"iPod touch 5G";
  
  if ( [identifier isEqualToString:@"iPad1,1"] ) return @"iPad 1G";
  if ( [identifier isEqualToString:@"iPad2,1"] ) return @"iPad 2";
  if ( [identifier isEqualToString:@"iPad2,2"] ) return @"iPad 2";
  if ( [identifier isEqualToString:@"iPad2,3"] ) return @"iPad 2";
  if ( [identifier isEqualToString:@"iPad2,4"] ) return @"iPad 2";
  if ( [identifier isEqualToString:@"iPad2,5"] ) return @"iPad mini 1G";
  if ( [identifier isEqualToString:@"iPad2,6"] ) return @"iPad mini 1G";
  if ( [identifier isEqualToString:@"iPad2,7"] ) return @"iPad mini 1G";
  if ( [identifier isEqualToString:@"iPad3,1"] ) return @"iPad 3";
  if ( [identifier isEqualToString:@"iPad3,2"] ) return @"iPad 3";
  if ( [identifier isEqualToString:@"iPad3,3"] ) return @"iPad 3";
  if ( [identifier isEqualToString:@"iPad3,4"] ) return @"iPad 4";
  if ( [identifier isEqualToString:@"iPad3,5"] ) return @"iPad 4";
  if ( [identifier isEqualToString:@"iPad3,6"] ) return @"iPad 4";
  if ( [identifier isEqualToString:@"iPad4,1"] ) return @"iPad Air";
  if ( [identifier isEqualToString:@"iPad4,2"] ) return @"iPad Air";
  if ( [identifier isEqualToString:@"iPad4,4"] ) return @"iPad mini 2G";
  if ( [identifier isEqualToString:@"iPad4,5"] ) return @"iPad mini 2G";
  
  return nil;
}

NSString *TKDeviceFamily()
{
  NSString *identifier = TKDeviceIdentifier();
  
  if ( [identifier hasPrefix:@"iPhone"] ) return @"iPhone";
  if ( [identifier hasPrefix:@"iPod"] ) return @"iPod";
  if ( [identifier hasPrefix:@"iPad"] ) return @"iPad";
  
  return nil;
}



#pragma mark - SDK compatibility

BOOL TKIsRetina()
{
  UIScreen *screen = [UIScreen mainScreen];
  return ( screen.scale==2.0 );
}

BOOL TKIsPad()
{
  UIDevice *device = [UIDevice currentDevice];
  return ( device.userInterfaceIdiom==UIUserInterfaceIdiomPad );
}

BOOL TKIsPhone()
{
  UIDevice *device = [UIDevice currentDevice];
  return ( device.userInterfaceIdiom==UIUserInterfaceIdiomPhone );
}
