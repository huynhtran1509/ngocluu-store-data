//
//  UsersViewController.m
//  TekTalk_CoreData
//
//  Created by luu on 6/4/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import "UsersViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "PostViewController.h"
#import "User.h"
#import "Post.h"

NSString *const kCellUserIdentifier = @"kCellUserIdentifier";

typedef enum : NSUInteger {
    SHOW_TYPE_ALL,
    SHOW_TYPE_HAS_POST,
} SHOW_TYPE;

@interface UsersViewController ()
{
    NSIndexPath *_currentSelectPath;
    
    NSManagedObjectContext *_managedObjectContext;
    NSMutableArray *_users;
    SHOW_TYPE _showType;
}

@property (nonatomic, weak) IBOutlet UIBarButtonItem *sortBarButton;

@end

@implementation UsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    _managedObjectContext = appDelegate.managedObjectContext;
    
    _showType = SHOW_TYPE_ALL;
    
    [self insertTestData];
    [self fetchData];
}

- (void)deleteAllData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"User" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:description];
    NSError *error = nil;
    NSArray *result = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (User *user in result) {
        [_managedObjectContext deleteObject:user];
    }
    
    [_managedObjectContext save:nil];
}

- (void)insertTestData
{
    [self deleteAllData];
    
    // hard code insert some test value
    NSEntityDescription *userDescription = [NSEntityDescription entityForName:@"User" inManagedObjectContext:_managedObjectContext];
    User *user = [[User alloc] initWithEntity:userDescription insertIntoManagedObjectContext:_managedObjectContext];
    user.name = @"Ly Van Nghia";
    
    User *user2 = [[User alloc] initWithEntity:userDescription insertIntoManagedObjectContext:_managedObjectContext];
    user2.name = @"Tran Thi Buoi";
    
    User *user3 = [[User alloc] initWithEntity:userDescription insertIntoManagedObjectContext:_managedObjectContext];
    user3.name = @"Chung Tu Dan";
    
    User *user4 = [[User alloc] initWithEntity:userDescription insertIntoManagedObjectContext:_managedObjectContext];
    user4.name = @"Pham Van Bach";
    
    NSEntityDescription *postDescription = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:_managedObjectContext];
    Post *post1 = [[Post alloc] initWithEntity:postDescription insertIntoManagedObjectContext:_managedObjectContext];
    post1.title = @"Hanh vi ninh trong tieng viet";
    post1.detail = @"Hanh vi ninh trong tieng viet detaill........";
    post1.dateCreate = [[NSDate date] dateByAddingTimeInterval:-35003];
    [user addPostsObject:post1];
    
    Post *post2 = [[Post alloc] initWithEntity:postDescription insertIntoManagedObjectContext:_managedObjectContext];
    post2.title = @"Ung xu cua can bo cap xa voi nguoi dan";
    post2.detail = @"Ung xu cua can bo cap xa voi nguoi dan detaill........";
    post2.dateCreate = [[NSDate date] dateByAddingTimeInterval:-35403];
    [user addPostsObject:post2];
    
    Post *post3 = [[Post alloc] initWithEntity:postDescription insertIntoManagedObjectContext:_managedObjectContext];
    post3.title = @"An toan giao thong va bien doi khi hau";
    post3.detail = @"An toan giao thong va bien doi khi hau detaill........";
    post3.dateCreate = [[NSDate date] dateByAddingTimeInterval:-36393];
    [user addPostsObject:post3];
    
    Post *post4 = [[Post alloc] initWithEntity:postDescription insertIntoManagedObjectContext:_managedObjectContext];
    post4.title = @"Ban ve so do 3 vong cua Ngoc Trinh";
    post4.detail = @"Ban ve so do 3 vong cua Ngoc Trinh detaill........";
    post4.dateCreate = [[NSDate date] dateByAddingTimeInterval:-36363];
    [user2 addPostsObject:post4];
    
    Post *post5 = [[Post alloc] initWithEntity:postDescription insertIntoManagedObjectContext:_managedObjectContext];
    post5.title = @"Nganh IT bac beo?";
    post5.detail = @"Nganh IT bac beo? detaill........";
    post5.dateCreate = [[NSDate date] dateByAddingTimeInterval:-36363];
    [user3 addPostsObject:post5];
    
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    //-------
}

- (void)fetchData {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"User" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:description];

    if (_showType == SHOW_TYPE_HAS_POST) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K.@count > 0", @"posts"];
        [fetchRequest setPredicate:predicate];
    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    
    NSError *error = nil;
    NSArray *result = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    } else {
//        NSLog(@"%@", result);
        _users = [result mutableCopy];
    }
    
    [self.tableView reloadData];
}

- (IBAction)onSortChange:(id)sender
{
    if (_showType == SHOW_TYPE_ALL) {
        _showType = SHOW_TYPE_HAS_POST;
        _sortBarButton.title = @"Show all";
    } else {
        _showType = SHOW_TYPE_ALL;
        _sortBarButton.title = @"User has post";
    }
    
    [self fetchData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellUserIdentifier forIndexPath:indexPath];
    User *user = _users[indexPath.row];
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld Post", user.posts.count];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        User *user = _users[indexPath.row];
        [_users removeObject:user];
        [_managedObjectContext deleteObject:user];
        
        NSError *error;
        [_managedObjectContext save:&error];
        if (error) {
            NSLog(@"Error %@", error);
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _currentSelectPath = indexPath;
    [self performSegueWithIdentifier:@"list_post" sender:self];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"list_post"]) {
        PostViewController *postViewController = [segue destinationViewController];
        if (_currentSelectPath) {
            User *user = _users[_currentSelectPath.row];
            postViewController.predicateFetchData = [NSPredicate predicateWithFormat:@"user = %@", user];
            _currentSelectPath = nil;
        }
    }
}

@end
