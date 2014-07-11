//
//  UIScrollViewAdditions.h
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIScrollView (TapKit)

///-------------------------------
/// Content size
///-------------------------------

- (void)makeHorizontalScrollable;

- (void)makeVerticalScrollable;


///-------------------------------
/// Scrolling
///-------------------------------

- (void)scrollToTopAnimated:(BOOL)animated;

- (void)scrollToCenterAnimated:(BOOL)animated;

- (void)scrollToBottomAnimated:(BOOL)animated;


- (void)stopScrollingAnimated:(BOOL)animated;

@end
