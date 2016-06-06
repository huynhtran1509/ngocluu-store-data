//
//  PostViewController.m
//  TekTalk_CoreData
//
//  Created by luu on 6/4/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import "PostViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#include "PostTableViewCell.h"
#include "Post.h"
#include "User.h"

NSString *const kCellPostIdentifier = @"kCellPostIdentifier";

@interface PostViewController () <NSFetchedResultsControllerDelegate, PostTableViewCellDelegate>
{
    NSManagedObjectContext *_managedObjectContext;
    NSFetchedResultsController *_fetchedResultsController;
    NSDateFormatter *_dataFormatter;
}

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    _managedObjectContext = appDelegate.managedObjectContext;
    
    _dataFormatter = [[NSDateFormatter alloc] init];
    _dataFormatter.dateFormat = @"yyyy/MM/dd HH:mm";
    
    [self fetchData];
}

- (void)fetchData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:description];
    
    if (_predicateFetchData) {
        [fetchRequest setPredicate:_predicateFetchData];
    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"dateCreate" ascending:NO];
    [fetchRequest setSortDescriptors:@[sort]];
    
    // Initialize Fetched Results Controller
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    // Configure Fetched Results Controller
    [_fetchedResultsController setDelegate:self];
    
    // Perform Fetch
    NSError *error = nil;
    [_fetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return _fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    id<NSFetchedResultsSectionInfo> sectionInfo = _fetchedResultsController.sections[section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellPostIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(PostTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Fetch Record
    Post *post = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    // Update Cell
    cell.titleLabel.text = post.title;
    cell.detailLabel.text = post.detail;
    cell.userLabel.text = post.user.name;
    cell.dateCreateLabel.text = [_dataFormatter stringFromDate:post.dateCreate];
    cell.flowButton.selected = [post.flow boolValue];
}

#pragma mark - PostTableViewCellDelegate
- (void)postTableViewCellDidClickFlow:(PostTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Post *post = [_fetchedResultsController objectAtIndexPath:indexPath];
    BOOL newFlowValue = ![post.flow boolValue];
    post.flow = [NSNumber numberWithBool:newFlowValue];
    
    NSError *error;
    [post.managedObjectContext save:&error];
    if (error) {
        NSLog(@"Error %@", error);
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSLog(@"Tag %@ %ld", _predicateFetchData.predicateFormat, indexPath.row);
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self configureCell:(PostTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

@end
