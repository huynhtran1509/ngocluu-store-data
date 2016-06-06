//
//  TTHomeViewController.m
//  TruyenTranh
//
//  Created by LuuNN on 12/19/13.
//  Copyright (c) 2013 LuuNN. All rights reserved.
//

#import "TTHomeViewController.h"
#import "TTModel.h"
#import "TTReadingViewController.h"

@interface TTHomeViewController ()
{
    NSArray *listBook;
    WYPopoverController *popoverController;
}
@end

@implementation TTHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSInteger spacing;
    if ([TTGlobal isIphone]) {
        spacing = 20;
    }else
    {
        spacing = 60;
    }
    
    _gridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gridView.itemSpacing = spacing;
    _gridView.clipsToBounds = YES;
    
    listBook = [[TTModel shareModel] listBook];
//    [_gridView reloadData];
    
    [self showBookmarkMessage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_gridView reloadData];
}

- (void)showBookmarkMessage
{
    NSArray *listBookmark = [[TTModel shareModel] listBookmark];
    if (listBookmark.count > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Do you want to go to last bookmark ?" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Yes", nil];
        alert.tag = -1;
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// bookmark button pressed
- (IBAction)bookmarkButtonPressed:(UIButton*)sender {
    TTBookMarkViewController *bookMarkViewController;
    
    bookMarkViewController = [[TTBookMarkViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [bookMarkViewController setListBookMark:[[TTModel shareModel] listBookmark] shouldShowAddButton:NO];
    
    bookMarkViewController.bookMarkDelegate = self;
    
    popoverController = [[WYPopoverController alloc] initWithContentViewController:bookMarkViewController];
    popoverController.delegate = self;
    
    [popoverController presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:(WYPopoverArrowDirectionUp) animated:YES];
}

- (void)readBookAtIndex:(NSInteger)index page:(NSInteger)page
{
    TTReadingViewController *readingViewController = [[TTReadingViewController alloc] initWithNibName:@"TTReadingViewController" bundle:nil];
    
    readingViewController.index = index;
    readingViewController.currentPage = page;

    [self.navigationController pushViewController:readingViewController animated:YES];
}

#pragma mark - GMGridViewDataSource

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView{
    return [listBook count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation{
    if ([TTGlobal isIphone]) {
        return CGSizeMake(100, 100);
    }
    
    return CGSizeMake(200, 200);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index{
    
    GMGridViewCell *cell = [_gridView dequeueReusableCell];
    UILabel *label;
    UIImageView *imageViewDownload;
    UIImageView *backgroundImage;
    UIDownloadBar *downloadBar;
    
    if (!cell)
    {
        CGSize size = [self GMGridView:_gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        cell = [[GMGridViewCell alloc] initWithFrame:rect];
        
        backgroundImage = [[UIImageView alloc] initWithFrame:rect];
        backgroundImage.image = [UIImage imageNamed:@"cell_backgound"];
        
        label = [[UILabel alloc] initWithFrame:rect];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 3;
        
        label.textAlignment = UITextAlignmentCenter;
        
        imageViewDownload = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_download"]];
        imageViewDownload.transform = CGAffineTransformMakeTranslation((size.width - imageViewDownload.frame.size.width)/2, size.height - imageViewDownload.frame.size.height);
        
        [backgroundImage addSubview:label];
        [backgroundImage addSubview:imageViewDownload];
        
        cell.contentView = backgroundImage;
    }else{
        backgroundImage = (UIImageView*)cell.contentView;
        label = [[backgroundImage subviews] objectAtIndex:0];
        imageViewDownload = [[backgroundImage subviews] objectAtIndex:1];
        
        if ([backgroundImage subviews].count > 2) {
            [[[backgroundImage subviews] objectAtIndex:2] removeFromSuperview];
        }
    }
    
    
    NSDictionary* book = [listBook objectAtIndex:index];
    
    downloadBar = [[TTModel shareModel] downloadBarForBookAtIndext:index];
    
    label.text = [book valueForKey:KEY_BOOK_NAME];
    
    if (downloadBar) {
        imageViewDownload.hidden = YES;
        [backgroundImage addSubview:downloadBar];
    } else {
        imageViewDownload.hidden = [[book valueForKey:KEY_BOOK_IS_DOWNLOADED] boolValue];
    }
    
    return cell;
}

- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index{
    return NO;
}


#pragma mark - GMGridViewActionDelegate

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position{

    if([[TTModel shareModel] isDownloadedEbookAtIndext:position]){
        NSLog(@"downloaded .");
        [self readBookAtIndex:position page:0];
        return;
    }

    if(![[TTModel shareModel] downloadBarForBookAtIndext:position]){
        
        GMGridViewCell *cell = [gridView cellForItemAtIndex:position];
        
        UIImageView *backgroundImage = (UIImageView*)cell.contentView;
        UIImageView *imageView = [[backgroundImage subviews] objectAtIndex:1];;
        imageView.hidden = YES;

        __block UIBackgroundTaskIdentifier backgroundTask;

        if ([TTGlobal isMultitaskingSupported]) {
            backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
                backgroundTask = UIBackgroundTaskInvalid;
                NSLog(@"ended");
            }];
        }
        
        UIDownloadBar *downloadBar = [[TTModel shareModel] createDownloadBarForBookAtIndext:position completeBlock:^(UIDownloadBar *downloadBar, BOOL success, NSString *errorMessage) {
            
            if ([TTGlobal isMultitaskingSupported] && backgroundTask != UIBackgroundTaskInvalid)
            {
                [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
                backgroundTask = UIBackgroundTaskInvalid;
            }

            [downloadBar removeFromSuperview];
            
            NSString *message;
            UIAlertView *alert;
            if(success){
                message = @"Download hoàn tất 100%\
                Bạn có muốn xem ngay tập này ?";
                
                alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:message delegate:self cancelButtonTitle:@"Đóng" otherButtonTitles:@"Xem", nil];
                alert.tag = position;
                NSLog(@"Down xong : %d", position);
            }else{
                imageView.hidden = NO;
                message = errorMessage;
                alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:message delegate:self cancelButtonTitle:@"Đóng" otherButtonTitles:nil, nil];
                NSLog(@"Down error : %@", errorMessage);
            }
            
            [alert show];
        } frame:cell.bounds];
        
        [backgroundImage addSubview:downloadBar];
    }
//    else
//    {
//        NSLog(@"dang down roi");
//    }
}

#pragma mark - TTBookMarkViewControllerDelegate

- (void)TTBookMarkViewController:(TTBookMarkViewController *)bookMarkViewController didselectBookmard:(NSArray *)bookmark
{
    [popoverController dismissPopoverAnimated:NO];
    int _index = [bookmark[0] integerValue];
    int _currentPage = [bookmark[1] integerValue];
    [self readBookAtIndex:_index page:_currentPage];
}

- (BOOL)TTBookMarkViewController:(TTBookMarkViewController *)bookMarkViewController didDeleteRow:(NSInteger)index
{
    [[TTModel shareModel] deleteBookmarkAtIndex:index];
    return YES;
}

- (void)TTBookMarkViewController:(TTBookMarkViewController *)bookMarkViewController updateContentSize:(CGSize)size
{
    bookMarkViewController.contentSizeForViewInPopover = size;
    [popoverController setPopoverContentSize:size];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (alertView.tag != -1) {
            if (self.navigationController.topViewController == self) {
                [self readBookAtIndex:alertView.tag page:0];
            } else {
                TTReadingViewController *readingViewController = (TTReadingViewController*)self.navigationController.topViewController;
                if ([readingViewController isMemberOfClass:[TTReadingViewController class]]) {
                    readingViewController.index = alertView.tag;
                    readingViewController.currentPage = 0;
                    [readingViewController updateTable];
                }
            }
        } else {
            NSArray *listBookmark = [[TTModel shareModel] listBookmark];
            NSArray *bookmark = [listBookmark firstObject];
            int _index = [bookmark[0] integerValue];
            int _currentPage = [bookmark[1] integerValue];
            [self readBookAtIndex:_index page:_currentPage];
        }
    }
}

@end