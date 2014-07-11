//
//  UIScrollViewAdditions.m
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "UIScrollViewAdditions.h"

@implementation UIScrollView (TapKit)

#pragma mark - Content size

- (void)makeHorizontalScrollable
{
  self.contentSize = CGSizeMake(MAX((self.bounds.size.width+1.0), self.contentSize.width),
                                MAX(self.bounds.size.height, self.contentSize.height));
}

- (void)makeVerticalScrollable
{
  self.contentSize = CGSizeMake(MAX(self.bounds.size.width, self.contentSize.width),
                                MAX((self.bounds.size.height+1.0), self.contentSize.height));
}



#pragma mark - Scrolling

- (void)scrollToTopAnimated:(BOOL)animated
{
  [self setContentOffset:CGPointZero animated:animated];
}

- (void)scrollToCenterAnimated:(BOOL)animated
{
  CGPoint offset = CGPointZero;
  offset.y = (self.contentSize.height - self.bounds.size.height) / 2.0;
  if ( offset.y>=0.0 ) {
    [self setContentOffset:offset animated:animated];
  }
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
  CGPoint offset = CGPointZero;
  offset.y = self.contentSize.height - self.bounds.size.height;
  if ( offset.y>=0.0 ) {
    [self setContentOffset:offset animated:animated];
  }
}


- (void)stopScrollingAnimated:(BOOL)animated
{
  CGPoint offset = self.contentOffset;
  [self setContentOffset:offset animated:animated];
}

@end
