//
//  UIViewControllerAdditions.m
//  TapKitDemo
//
//  Created by Kevin on 7/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "UIViewControllerAdditions.h"

@implementation UIViewController (TapKit)

#pragma mark - Container management

- (void)presentChildViewController:(UIViewController *)childViewController inView:(UIView *)containerView
{
  UIView *boxView = containerView;
  if ( !boxView  ) {
    boxView = self.view;
  }
  [self addChildViewController:childViewController];
  [boxView addSubview:childViewController.view];
  [childViewController didMoveToParentViewController:self];
}

- (void)dismissChildViewController:(UIViewController *)childViewController
{
  [childViewController willMoveToParentViewController:nil];
  [childViewController.view removeFromSuperview];
  [childViewController removeFromParentViewController];
}

@end
