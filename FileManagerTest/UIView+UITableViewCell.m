//
//  UIView+UITableViewCell.m
//  FileManagerTest
//
//  Created by Nikolay Berlioz on 21.02.16.
//  Copyright © 2016 Nikolay Berlioz. All rights reserved.
//

#import "UIView+UITableViewCell.h"

@implementation UIView (UITableViewCell)

- (UITableViewCell*) superCell
{
    if (!self.superview)
    {
        return nil;
    }
    
    if ([self.superview isKindOfClass:[UITableViewCell class]])
    {
        return (UITableViewCell*)self.superview;
    }
    
    return [self.superview superCell];
}

@end
