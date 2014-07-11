//
//  UITableViewAdditions.m
//  TapKit
//
//  Created by Kevin on 5/22/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#import "UITableViewAdditions.h"

@implementation UITableView (TapKit)

#pragma mark - Querying

- (UITableViewCell *)dequeueReusableCellWithClass:(Class)cls
{
  if ( cls ) {
    
    NSString *identifier = NSStringFromClass(cls);
    
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    
    if ( !cell ) {
      cell = [[cls alloc] init];
    }
    
    return cell;
  }
  
  return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
}



#pragma mark - Selection

- (void)deselectAllRowsAnimated:(BOOL)animated
{
  NSArray *indexPathAry = [self indexPathsForSelectedRows];
  for ( NSIndexPath *indexPath in indexPathAry ) {
    [self deselectRowAtIndexPath:indexPath animated:animated];
  }
}

@end



@implementation UITableViewCell (TapKit)

#pragma mark - Cell height

+ (CGFloat)heightForTableView:(UITableView *)tableView object:(id)object
{
  return 44.0;
}

@end
