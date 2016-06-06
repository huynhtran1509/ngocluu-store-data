//
//  TTBookMarkViewController.m
//  TruyenTranh
//
//  Created by LuuNN on 12/26/13.
//  Copyright (c) 2013 LuuNN. All rights reserved.
//

#import "TTBookMarkViewController.h"

@interface TTBookMarkViewController ()

@property (assign, nonatomic) BOOL isShowAddButton;

@end

@implementation TTBookMarkViewController
{
    CGFloat popoverWidth;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tableView.allowsSelectionDuringEditing = YES;
        [self.tableView setEditing:YES animated:NO];
        self.tableView.rowHeight = 50;
    }
    return self;
}

- (void)setListBookMark:(NSMutableArray *)listBookMark shouldShowAddButton:(BOOL)showAddButton
{
    _listBookMark = listBookMark;
    _isShowAddButton = showAddButton;
    
    float largestLabelWidth = 0, totalRowsHeight;
    
    totalRowsHeight = [_listBookMark count]*[self tableView:nil heightForRowAtIndexPath:0] + [self tableView:nil heightForFooterInSection:0];//8
    for (NSArray *array in _listBookMark) {
        
        NSString *s = [array objectAtIndex:2];
        
        //Checks size of text using the default font for UITableViewCell's textLabel.
        CGSize labelSize = [s sizeWithFont:[UIFont boldSystemFontOfSize:13.0f]];
        if (labelSize.width > largestLabelWidth) {
            largestLabelWidth = labelSize.width;
        }
    }

    if (totalRowsHeight == 0) {
        totalRowsHeight = [self tableView:nil heightForRowAtIndexPath:nil];
        popoverWidth = 180;
    }else
    {
        popoverWidth = largestLabelWidth + 90;//130;
        
        if (_isShowAddButton) {
            NSString *s = @"Add bookmark";
            
            CGSize labelSize = [s sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]];
            
            if (labelSize.width + 30 > popoverWidth) {
                popoverWidth = labelSize.width + 30;
            }
        }
    }
    
    //Set the property to tell the popover container how big this view will be.
    self.contentSizeForViewInPopover = CGSizeMake(popoverWidth, totalRowsHeight);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_listBookMark count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:13]];
    }
    
    // Configure the cell...
    NSArray *array = _listBookMark[indexPath.row];
    cell.textLabel.text = [array objectAtIndex:2];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_bookMarkDelegate respondsToSelector:@selector(TTBookMarkViewController:didselectBookmard:)])
    {
        [_bookMarkDelegate TTBookMarkViewController:self didselectBookmard:[_listBookMark objectAtIndex:indexPath.row]];
    }
}

- (GLfloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_isShowAddButton) {
        return 60;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!_isShowAddButton) {
        return nil;
    }
    
    UIButton *footer = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, popoverWidth, [self tableView:nil heightForFooterInSection:0]))];
    footer.backgroundColor = [UIColor greenColor];
    
    [footer setTitle:@"Add bookmark" forState:UIControlStateNormal];
    [footer addTarget:self action:@selector(bookmarkAddButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    return footer;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([_bookMarkDelegate respondsToSelector:@selector(TTBookMarkViewController:didDeleteRow:)]) {
            BOOL res = [_bookMarkDelegate TTBookMarkViewController:self didDeleteRow:indexPath.row];
            if (res) {
                
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
                [self.tableView endUpdates];
                
                if([_bookMarkDelegate respondsToSelector:@selector(TTBookMarkViewController:updateContentSize:)])
                {
                    GLfloat rowHeight = [self tableView:nil heightForRowAtIndexPath:nil];
                    CGSize newSize = CGSizeMake(self.contentSizeForViewInPopover.width, self.contentSizeForViewInPopover.height - rowHeight);
                    if (newSize.height < 10) {
                        newSize.height = rowHeight;
                    }
                    
                    [_bookMarkDelegate TTBookMarkViewController:self updateContentSize:newSize];
                }

            }
        }
    }
}


- (void)bookmarkAddButtonPressed
{
    if ([_bookMarkDelegate respondsToSelector:@selector(TTBookMarkViewControllerSelectedAddBookmark:)])
    {
        if ([_bookMarkDelegate TTBookMarkViewControllerSelectedAddBookmark:self])
        {
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationRight)];
            [self.tableView endUpdates];
            
            if([_bookMarkDelegate respondsToSelector:@selector(TTBookMarkViewController:updateContentSize:)])
            {
                GLfloat rowHeight = [self tableView:nil heightForRowAtIndexPath:nil];
                CGSize newSize = CGSizeMake(self.contentSizeForViewInPopover.width, self.contentSizeForViewInPopover.height + rowHeight);
                [_bookMarkDelegate TTBookMarkViewController:self updateContentSize:newSize];
            }
        }
    }
}

//- table

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
