//
//  UIViewAdditions.m
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "UIViewAdditions.h"
#import "TKCommon.h"

@implementation UIView (TapKit)

#pragma mark - Metric properties

- (CGFloat)leftX
{
  return self.frame.origin.x;
}
- (void)setLeftX:(CGFloat)leftX
{
  self.frame = CGRectMake(leftX, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
}

- (CGFloat)centerX
{
  return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX
{
  self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)rightX
{
  return self.frame.origin.x + self.bounds.size.width;
}
- (void)setRightX:(CGFloat)rightX
{
  self.frame = CGRectMake(rightX-self.bounds.size.width, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
}


- (CGFloat)topY
{
  return self.frame.origin.y;
}
- (void)setTopY:(CGFloat)topY
{
  self.frame = CGRectMake(self.frame.origin.x, topY, self.bounds.size.width, self.bounds.size.height);
}

- (CGFloat)centerY
{
  return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY
{
  self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)bottomY
{
  return self.frame.origin.y + self.bounds.size.height;
}
- (void)setBottomY:(CGFloat)bottomY
{
  self.frame = CGRectMake(self.frame.origin.x, bottomY-self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
}


- (CGFloat)width
{
  return self.bounds.size.width;
}
- (void)setWidth:(CGFloat)width
{
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.bounds.size.height);
}

- (CGFloat)height
{
  return self.bounds.size.height;
}
- (void)setHeight:(CGFloat)height
{
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, height);
}


- (CGPoint)origin
{
  return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin
{
  self.frame = CGRectMake(origin.x, origin.y, self.bounds.size.width, self.bounds.size.height);
}

- (CGSize)size
{
  return self.bounds.size;
}
- (void)setSize:(CGSize)size
{
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}



#pragma mark - Image content

- (UIImage *)imageRep
{
  UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
  [self.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}



#pragma mark - Placing

- (void)occupySuperview
{
  if ( self.superview ) {
    self.frame = self.superview.bounds;
  }
}

- (void)moveToCenterOfSuperview
{
  if ( self.superview ) {
    CGRect frm = CGRectMake((self.superview.bounds.size.width-self.bounds.size.width)/2.0,
                            (self.superview.bounds.size.height-self.bounds.size.height)/2.0,
                            self.bounds.size.width,
                            self.bounds.size.height);
    self.frame = frm;
  }
}

- (void)moveToVerticalCenterOfSuperview
{
  if ( self.superview ) {
    CGRect frm = CGRectMake(self.frame.origin.x,
                            (self.superview.bounds.size.height-self.bounds.size.height)/2.0,
                            self.bounds.size.width,
                            self.bounds.size.height);
    self.frame = frm;
  }
}

- (void)moveToHorizontalCenterOfSuperview
{
  if ( self.superview ) {
    CGRect frm = CGRectMake((self.superview.bounds.size.width-self.bounds.size.width)/2.0,
                            self.frame.origin.y,
                            self.bounds.size.width,
                            self.bounds.size.height);
    self.frame = frm;
  }
}



#pragma mark - Finding

- (UIView *)descendantOrSelfWithClass:(Class)cls
{
  if ( [self isKindOfClass:cls] ) {
    return self;
  }
  
  for ( UIView *child in self.subviews ) {
    UIView *it = [child descendantOrSelfWithClass:cls];
    if ( it ) {
      return it;
    }
  }
  
  return nil;
}

- (UIView *)ancestorOrSelfWithClass:(Class)cls
{
  if ( [self isKindOfClass:cls] ) {
    return self;
  } else if ( self.superview ) {
    return [self.superview ancestorOrSelfWithClass:cls];
  }
  return nil;
}


- (UIView *)findFirstResponder
{
  return TKFindFirstResponderInView(self);
}



#pragma mark - Hierarchy

- (UIViewController *)viewController
{
  for ( UIView *next=self; next; next=next.superview ) {
    UIResponder *nextResponder = [next nextResponder];
    if ( TKIsInstance(nextResponder, [UIViewController class]) ) {
      return ((UIViewController *)nextResponder);
    }
  }
  return nil;
}

- (UIView *)rootView
{
  UIView *view = self;
  while ( view.superview ) {
    view = view.superview;
  }
  return view;
}

- (void)bringToFront
{
  [self.superview bringSubviewToFront:self];
}

- (void)sendToBack
{
  [self.superview sendSubviewToBack:self];
}

- (BOOL)isInFront
{
  return ( [self.superview.subviews lastObject]==self );
}

- (BOOL)isAtBack
{
  NSArray *subviewAry = self.superview.subviews;
  if ( [subviewAry count]>0 ) {
    return ( [subviewAry objectAtIndex:0]==self );
  }
  return NO;
}

@end
