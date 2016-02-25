//
//  DirectoryViewController.m
//  FileManagerTest
//
//  Created by Nikolay Berlioz on 05.02.16.
//  Copyright © 2016 Nikolay Berlioz. All rights reserved.
//

#import "DirectoryViewController.h"
#import "FileCell.h"
#import "UIView+UITableViewCell.h"

@interface DirectoryViewController ()


@property (strong, nonatomic) NSArray *contents;
@property (strong, nonatomic) NSString *selectedPath;

@end

@implementation DirectoryViewController

- (id) initWithFolderPath:(NSString*) path
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.path = path;
    }
    //@"/Users/Berlioz/Desktop/ObjectiveC/GitHub
    return self;
}

- (void) setPath:(NSString *)path
{
    NSError *error = nil;
    
    _path = path;
    self.contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:&error];
    
    if (error)
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    self.navigationItem.title = [self.path lastPathComponent];
    
    [self.tableView reloadData];
}

- (void) dealloc
{
    NSLog(@"controller with path %@ has been deallocated", self.path);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.path)
    {
        self.path = @"/Users/Berlioz/Desktop/ObjectiveC/GitHub";
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.navigationController.viewControllers count] > 1)
    {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Back to Root"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(actionBackToRoot:)];
        self.navigationItem.rightBarButtonItem = item;
        
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"path = %@", self.path);
    NSLog(@"view controllers on stack = %lu", [self.navigationController.viewControllers count]);
    NSLog(@"index on stack = %lu", [self.navigationController.viewControllers indexOfObject:self]);
}

- (BOOL) isDirectoryAtIndexPath:(NSIndexPath*)indexPath
{
    NSString *filaName = [self.contents objectAtIndex:indexPath.row];
    
    NSString *filaPath = [self.path stringByAppendingPathComponent:filaName];
    
    BOOL isDirectory = NO;
    
    [[NSFileManager defaultManager] fileExistsAtPath:filaPath isDirectory:&isDirectory];
    
    return isDirectory;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *fileIdentifier = @"FileCell";
    static NSString *folderIdentifier = @"FolderCell";
    
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    
    if ([self isDirectoryAtIndexPath:indexPath])
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:folderIdentifier];
        
        cell.textLabel.text = fileName;
        
        return cell;
    }
    else
    {
        NSString *path = [self.path stringByAppendingPathComponent:fileName];
        
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        
        FileCell *cell = [tableView dequeueReusableCellWithIdentifier:fileIdentifier];
        
        cell.nameLabel.text = fileName;
        cell.sizeLabel.text = [self fileSizeFromValue:[attributes fileSize]];
        
        static NSDateFormatter *dateFormatter = nil;
        
        if (!dateFormatter)
        {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
        }
        
        cell.dateLabel.text = [dateFormatter stringFromDate:[attributes fileModificationDate]];
        
        return cell;
    }

    return nil;
}

#pragma mark - Action

- (IBAction)actionInfoCell:(UIButton*)sender
{
    NSLog(@"actionInfoCell");
    
    UITableViewCell *cell = [sender superCell];
    
    if (cell)
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Yahoo!"
                                      message:[NSString stringWithFormat:@"action %ld %ld", (long)indexPath.section, (long)indexPath.row]
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                    }];
       
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void) actionBackToRoot:(UIBarButtonItem*)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSString*) fileSizeFromValue:(unsigned long long) size
{
    static NSString *units[] = {@"B", @"KB", @"MB", @"GB", @"TB"};
    static int unitsCount = 5;
    
    int index = 0;
    double fileSize = (double)size;
    
    while (fileSize > 1024 && index < unitsCount)
    {
        fileSize /= 1024;
        index++;
    }
    return [NSString stringWithFormat:@"%.2f %@", fileSize, units[index]];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isDirectoryAtIndexPath:indexPath])
    {
        return 44.f;
    }
    else
    {
        return 80.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self isDirectoryAtIndexPath:indexPath])
    {
        NSString *filaName = [self.contents objectAtIndex:indexPath.row];
        
        NSString *path = [self.path stringByAppendingPathComponent:filaName];
        
//        DirectoryViewController *vc = [[DirectoryViewController alloc] initWithFolderPath:path];
//        [self.navigationController pushViewController:vc animated:YES];
        
        //Лучше сделать так, чем третий вариант
        
//        DirectoryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DirectoryViewController"];
//        vc.path = path;
//        [self.navigationController pushViewController:vc animated:YES];
        
        self.selectedPath = path;
        
        [self performSegueWithIdentifier:@"navigateDeep" sender:nil];
        
    }
    
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
    
    DirectoryViewController *vc = segue.destinationViewController;
    vc.path = self.selectedPath;
}


@end









