//
//  CityTableViewController.m
//  TekTalk_Plist
//
//  Created by luu on 6/3/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import "CityTableViewController.h"

NSString *const kCITY = @"CITY";
NSString *const kZIP_CODE = @"ZIP_CODE";
NSString *const kCellIdentifier = @"kCellIdentifier";

@interface CityTableViewController ()
{
    NSArray *_citys;
}

@end

@implementation CityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *pathPlistFile = [[NSBundle mainBundle] pathForResource:@"City" ofType:@"plist"];
    _citys = [NSArray arrayWithContentsOfFile:pathPlistFile];
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onDone:(id)sender
{
    NSString *message = @"";
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        NSString *zipCode = [_citys[indexPath.row] valueForKey:kZIP_CODE];
        message = [message stringByAppendingFormat:@" %@", zipCode];
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Zipcode" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _citys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [_citys[indexPath.row] valueForKey:kCITY];
    cell.detailTextLabel.text = [_citys[indexPath.row] valueForKey:kZIP_CODE];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

@end
