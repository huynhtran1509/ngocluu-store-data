//
//  TTReadingViewController.m
//  TruyenTranh
//
//  Created by LuuNN on 12/23/13.
//  Copyright (c) 2013 LuuNN. All rights reserved.
//

#import "TTReadingViewController.h"
#import "TTModel.h"

static NSString *reuseIdentifier = @"RGMPageReuseIdentifier";

@interface TTReadingViewController ()
{
    NSArray *listPathImage;
    NSString *dirPath;
    
    WYPopoverController *popoverController;
    BOOL isSliderScroll;
    
    NSTimer *timer;
}

@end


@implementation TTReadingViewController

@synthesize currentPage = _currentPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    _topBar.hidden = YES;
    _slider.hidden = YES;
    _label.hidden = YES;
    
    _pageingScrollview.scrollDirection = RGMScrollDirectionHorizontal;
    [_pageingScrollview registerClass:[TTImageView class] forCellReuseIdentifier:reuseIdentifier];
    
    [self updateTable];
}


// reload
- (void)updateTable
{
    listPathImage = [[TTModel shareModel] getListPathImageAtBookIndex:_index];
    dirPath = [[TTModel shareModel] getDirPathAtBookIndex:_index];

    if (!listPathImage || listPathImage.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"File error" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.isViewLoaded) {
        isSliderScroll = NO;

        [self updateSliderAndLabel];
        [self fixedContentOffsetShouldAnimated:NO];

        _slider.value = _currentPage;
        [_pageingScrollview reloadData];
    }
}

- (void)updateSliderAndLabel
{
    NSInteger page = [listPathImage count];
    
    if (page <= 1) {
        _slider.minimumValue = -0.3;
        _slider.maximumValue = 0.3;
    } else {
        _slider.minimumValue = 0;
        _slider.maximumValue = page - 1;
    }
    
    [self updateLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TTSliderTrackDelegate

- (IBAction)SliderBarValueChanged:(id)sender {
    [_pageingScrollview setContentOffset:CGPointMake(_pageingScrollview.bounds.size.width * _slider.value, 0) animated:NO];
}

- (void)TTSliderBeginTrack:(UISlider *)slider
{
    [self cancelHidingTimer];
    isSliderScroll = YES;
}

- (void)TTSliderEndTrack:(UISlider *)slider
{
    isSliderScroll = NO;
    _currentPage = roundf(_slider.value);
    [self fixedContentOffsetShouldAnimated:YES];
}

#pragma mark - button pressed

- (IBAction)homeButtonPressed:(id)sender
{
    [self cancelHidingTimer];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)bookmarkButtonPressed:(id)sender {
    UIButton *button = (UIButton*)sender;
    TTBookMarkViewController *bookMarkViewController;
    
    bookMarkViewController = [[TTBookMarkViewController alloc] initWithStyle:UITableViewStylePlain];
    [bookMarkViewController setListBookMark:[[TTModel shareModel] listBookmark] shouldShowAddButton:YES];
    
    bookMarkViewController.bookMarkDelegate = self;
    
    popoverController = [[WYPopoverController alloc] initWithContentViewController:bookMarkViewController];
    
    popoverController.delegate = self;
    [popoverController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:(WYPopoverArrowDirectionUp) animated:YES];
    
    [self cancelHidingTimer];
}

- (IBAction)shareButtonPressed:(id)sender {
    UIButton *button = (UIButton*)sender;
    TTShareViewController *shareViewController;
    
    
    shareViewController = [[TTShareViewController alloc] initWithStyle:UITableViewStylePlain];
    shareViewController.shareDelegate =self;
    
    popoverController = [[WYPopoverController alloc] initWithContentViewController:shareViewController];
    
    popoverController.delegate = self;
    [popoverController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:(WYPopoverArrowDirectionUp) animated:YES];
    
    [self cancelHidingTimer];
}

- (void)fixedContentOffsetShouldAnimated:(BOOL)shouldAniated
{
    [_pageingScrollview setCurrentPage:_currentPage animated:shouldAniated];
}

- (void)updateLabel
{
    int pageNumber = listPathImage.count >0 ? _currentPage + 1: 0;
    _label.text = [NSString stringWithFormat:@"Tập %d %d/%d", _index +1, pageNumber, listPathImage.count];
}

#pragma mark - TTBookMarkViewControllerDelegate

- (void)TTBookMarkViewController:(TTBookMarkViewController *)bookMarkViewController didselectBookmard:(NSArray*)bookmark
{
    [popoverController dismissPopoverAnimated:YES];
    int index = [bookmark[0] integerValue];
    _currentPage = [bookmark[1] integerValue];
    
    if (_index != index) {
        _index = index;
        [self updateTable];
    }else{
        [self updateLabel];
        [self fixedContentOffsetShouldAnimated:NO];
    }
}

- (BOOL)TTBookMarkViewControllerSelectedAddBookmark:(TTBookMarkViewController *)bookMarkViewController
{
    [[TTModel shareModel] addBookmarkWithBook:_index page:_currentPage];
    return YES;
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

#pragma mark -  TTShareViewControllerDelegate

- (void)TTShareViewController:(TTShareViewController *)bookMarkViewController didselectSharetype:(TTShareType)sharetype
{
    [popoverController dismissPopoverAnimated:YES];

    if ([listPathImage count] == 0) {
        return;
    }
    
    NSString *message = [NSString stringWithFormat:@"Tap %d, trang %d", _index + 1, _currentPage +1];
    NSString *pathImage = [dirPath stringByAppendingPathComponent:listPathImage[_currentPage]];
    
    switch (sharetype) {
        case TTShareTypeEmail:
            [[TTShareHelper shareInstant] shareOverEmailWithSubject:@"App truyen tranh" message:message pathImage:pathImage fromViewController:self delegate:self];
            break;
        case TTShareTypeTwitter:
            [[TTShareHelper shareInstant] shareOverTwitterWithMessage:message pathImage:pathImage fromViewController:self delegate:self];
            break;
        case TTShareTypeFacebook:
            [[TTShareHelper shareInstant] shareOverFacebookWithSubject:@"App truyen tranh" message:message pathImage:pathImage fromViewController:self delegate:self];
            break;
        default:
            break;
    }
}

#pragma mark - TTShareHelperDelegate

- (void)didShareWithType:(TTShareType)shareType result:(TTShareResult)result errorMessage:(NSString *)error
{
    if (result != TTShareResultUserCancel) {
        NSString *shareTypeName;
        switch (shareType) {
            case TTShareTypeEmail:
                shareTypeName = @"email";
                break;
            case TTShareTypeFacebook:
                shareTypeName = @"facebook";
                break;
            case TTShareTypeTwitter:
                shareTypeName = @"twitter";
                break;
            default:
                break;
        }
        NSString *message = (result == TTShareResultError) ? error : [NSString stringWithFormat:@"Share %@ success.", shareTypeName];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [self hideControlsAfterDelay];
}

#pragma mark - RGMPagingScrollViewDatasource

- (NSInteger)pagingScrollViewNumberOfPages:(RGMPagingScrollView *)pagingScrollView
{
    return listPathImage.count;
}

- (UIView *)pagingScrollView:(RGMPagingScrollView *)pagingScrollView viewForIndex:(NSInteger)idx
{
    TTImageView *imageView = (TTImageView*)[pagingScrollView dequeueReusablePageWithIdentifer:reuseIdentifier forIndex:idx];
    
    imageView.frame = _pageingScrollview.bounds;
    imageView.imageviewDelegate = self;
    
    [imageView setPathImage:[dirPath stringByAppendingPathComponent:[listPathImage objectAtIndex:idx]]];
    
    return imageView;
}

#pragma mark - RGMPagingScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!isSliderScroll) {
        _slider.value = _pageingScrollview.contentOffset.x / _pageingScrollview.bounds.size.width;
    }
    
    int currentPageNow = _pageingScrollview.currentPage;
    if (currentPageNow != _currentPage) {
        _currentPage = currentPageNow;
        [self updateLabel];
    }
}

- (void)pagingScrollView:(RGMPagingScrollView *)pagingScrollView scrolledToPage:(NSInteger)idx
{
    [self hideControlsAfterDelay];
}

#pragma mark - TTImageViewDelegate

- (void)didSingalTap
{
    float alpha = _topBar.hidden ? 0.0 : 1.0;
    
    _slider.alpha = _topBar.alpha = _label.alpha = alpha;
    _topBar.hidden = NO;
    _slider.hidden = NO;
    _label.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        _slider.alpha = _topBar.alpha = _label.alpha = 1.0 - alpha;
    }completion:^(BOOL finished) {
        if(_slider.alpha == 0){
            _topBar.hidden = YES;
            _slider.hidden = YES;
            _label.hidden = YES;
            [self cancelHidingTimer];
        }else
        {
            [self hideControlsAfterDelay];
        }
    }];
}

- (void)didDoubleTap
{
    [self hideControlsAfterDelay];
}

- (void)didEndDrag
{
    [self hideControlsAfterDelay];
}

- (void)didEndZoom
{
    [self hideControlsAfterDelay];
}

#pragma mark - timer hide control

- (void)cancelHidingTimer
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)hideControls
{
    if (!_topBar.hidden) {
        [self didSingalTap];
    }
}

- (void)hideControlsAfterDelay {
	if (!_topBar.hidden) {
        [self cancelHidingTimer];
		timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hideControls) userInfo:nil repeats:NO];
	}
}

#pragma mark - WYPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)popoverController
{
    [self hideControlsAfterDelay];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end