//
//  UITableViewAdditions.h
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITableView (TapKit)

///-------------------------------
/// Querying
///-------------------------------

- (UITableViewCell *)dequeueReusableCellWithClass:(Class)cls;


///-------------------------------
/// Selection
///-------------------------------

- (void)deselectAllRowsAnimated:(BOOL)animated;

@end


@interface UITableViewCell (TapKit)

///-------------------------------
/// Cell height
///-------------------------------

+ (CGFloat)heightForTableView:(UITableView *)tableView object:(id)object;

@end
