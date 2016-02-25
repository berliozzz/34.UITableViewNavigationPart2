//
//  DirectoryViewController.h
//  FileManagerTest
//
//  Created by Nikolay Berlioz on 05.02.16.
//  Copyright © 2016 Nikolay Berlioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectoryViewController : UITableViewController

@property (strong, nonatomic) NSString *path;

- (id) initWithFolderPath:(NSString*) path;
- (IBAction)actionInfoCell:(id)sender;

@end
