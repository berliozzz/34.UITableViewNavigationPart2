//
//  DummyTableViewController.m
//  FileManagerTest
//
//  Created by Nikolay Berlioz on 21.02.16.
//  Copyright © 2016 Nikolay Berlioz. All rights reserved.
//

#import "DummyTableViewController.h"


@interface DummyTableViewController ()

@end

@implementation DummyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Seque

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"shouldPerformSegueWithIdentifier: %@", identifier);
    
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier);

}

@end
