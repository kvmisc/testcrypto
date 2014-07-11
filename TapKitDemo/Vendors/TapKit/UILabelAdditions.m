//
//  UILabelAdditions.m
//  TapKitDemo
//
//  Created by Kevin on 7/8/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "UILabelAdditions.h"

@implementation UILabel (TapKit)

#pragma mark - Handy methods

+ (id)singleLineLabelWithFont:(UIFont *)font
                    textColor:(UIColor *)textColor
{
  return [self labelWithFont:font
                   textColor:textColor
               textAlignment:NSTextAlignmentLeft
               lineBreakMode:NSLineBreakByTruncatingTail
               numberOfLines:1
             backgroundColor:[UIColor clearColor]];
}

+ (id)multipleLineLabelWithFont:(UIFont *)font
                      textColor:(UIColor *)textColor
{
  return [self labelWithFont:font
                   textColor:textColor
               textAlignment:NSTextAlignmentLeft
               lineBreakMode:NSLineBreakByWordWrapping
               numberOfLines:0
             backgroundColor:[UIColor clearColor]];
}

+ (id)labelWithFont:(UIFont *)font
          textColor:(UIColor *)textColor
      textAlignment:(NSTextAlignment)textAlignment
      lineBreakMode:(NSLineBreakMode)lineBreakMode
      numberOfLines:(NSInteger)numberOfLines
    backgroundColor:(UIColor *)backgroundColor
{
  UILabel *label = [[self alloc] init];
  label.font            = font;
  label.textColor       = ((textColor==nil)       ? ([UIColor blackColor])      : (textColor));
  label.textAlignment   = ((textAlignment==0)     ? (NSTextAlignmentLeft)       : (textAlignment));
  label.lineBreakMode   = ((lineBreakMode==0)     ? (NSLineBreakByWordWrapping) : (lineBreakMode));
  label.numberOfLines   = ((numberOfLines<0)      ? (0)                         : (numberOfLines));
  label.backgroundColor = ((backgroundColor==nil) ? ([UIColor clearColor])      : (backgroundColor));
  label.adjustsFontSizeToFitWidth = NO;
  return label;
}

@end
