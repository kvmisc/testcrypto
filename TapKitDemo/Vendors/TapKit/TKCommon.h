//
//  TKCommon.h
//  TapKit
//
//  Created by Kevin on 5/21/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifdef __cplusplus
extern "C" {
#endif

///-------------------------------
/// System message
///-------------------------------

void TKPresentSystemMessage(NSString *message);


///-------------------------------
/// Bundle image
///-------------------------------

UIImage *TKCreateImage(NSString *name);

UIImage *TKCreateResizableImage(NSString *name, UIEdgeInsets insets);


NSString *TKDeviceSpecificImageName(NSString *name, BOOL screenLevel);


///-------------------------------
/// Keyboard
///-------------------------------

BOOL TKIsKeyboardVisible();

UIView *TKFindFirstResponderInView(UIView *topView);


///-------------------------------
/// Version
///-------------------------------

NSComparisonResult TKCompareVersion(NSString *version1, NSString *version2);

NSInteger TKMajorVersion(NSString *version);

NSInteger TKMinorVersion(NSString *version);

NSInteger TKBugfixVersion(NSString *version);


///-------------------------------
/// System paths
///-------------------------------

NSString *TKPathForBundleResource(NSBundle *bundle, NSString *relativePath);

NSString *TKPathForDocumentResource(NSString *relativePath);

NSString *TKPathForLibraryResource(NSString *relativePath);

NSString *TKPathForCachesResource(NSString *relativePath);


///-------------------------------
/// Weak collections
///-------------------------------

NSMutableArray *TKCreateWeakMutableArray();

NSMutableDictionary *TKCreateWeakMutableDictionary();

NSMutableSet *TKCreateWeakMutableSet();


///-------------------------------
/// Object validity
///-------------------------------

BOOL TKIsInstance(id object, Class cls);


BOOL TKIsStringWithText(id object);

BOOL TKIsDataWithBytes(id object);

BOOL TKIsArrayWithItems(id object);

BOOL TKIsDictionaryWithItems(id object);

BOOL TKIsSetWithItems(id object);


///-------------------------------
/// Internet date
///-------------------------------

NSDateFormatter *TKInternetDateFormatter();

NSDate *TKInternetDateObject(NSString *string);

NSString *TKInternetDateString(NSDate *date);

#ifdef __cplusplus
}
#endif
