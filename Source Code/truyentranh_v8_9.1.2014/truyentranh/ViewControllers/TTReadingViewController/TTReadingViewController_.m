//
//  TTReadingViewController.m
//  TruyenTranh
//
//  Created by LuuNN on 12/23/13.
//  Copyright (c) 2013 LuuNN. All rights reserved.
//

#import "TTReadingViewController.h"
#import "TTModel.h"
#import "EasyTableView.h"

@interface TTReadingViewController ()
{
    NSArray *listPathImage;
    NSString *dirPath;
    __weak UIImageView *currentImage;
    
    EasyTableView *tableView;
}

@end


@implementation TTReadingViewController

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
//    [self customGridView];
    // Do any additional setup after loading the view from its nib.
    _topBar.hidden = YES;
    _slider.hidden = YES;
    _label.hidden = YES;

    listPathImage = [[TTModel shareModel] getListPathImageAtBookIndex:_index];
    dirPath = [[TTModel shareModel] getDirPathAtBookIndex:_index];
//    [_gridView reloadData];
}

- (void)viewDidLayoutSubviews{
    [self initTableView];
}

- (void)initTableView{
    
//    NSLog(@"%@", self.view);
    tableView = [[EasyTableView alloc] initWithFrame:self.view.frame numberOfColumns:[listPathImage count] ofWidth:self.view.frame.size.width];
    
    tableView.delegate = self;
    tableView.tableView.pagingEnabled = YES;
//    [self.view insertSubview:tableView atIndex:0];
    
    _slider.minimumValue = 0;
    _slider.maximumValue = [listPathImage count] - 1;
//    [tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onDoubleTap:(id)sender {
    NSLog(@"call onDoubleTap");
    CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
    currentImage.transform = transform;
}
- (IBAction)onTap:(id)sender {
//    NSLog(@"%i", _label.hidden);
    NSLog(@"call tap");

    float alpha = _topBar.hidden ? 0.0 : 1.0;
    
    _slider.alpha = _topBar.alpha = _label.alpha = alpha;
    _topBar.hidden = NO;
    _slider.hidden = NO;
    _label.hidden = NO;
    
    [UIView animateWithDuration:0.7 animations:^{
        _slider.alpha = _topBar.alpha = _label.alpha = 1.0 - alpha;
    }completion:^(BOOL finished) {
        if(_slider.alpha == 0){
            _topBar.hidden = YES;
            _slider.hidden = YES;
            _label.hidden = YES;
        }
    }];
}

- (IBAction)homeButtonPressed:(id)sender
{
//    _menuBar.hidden = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onPinch:(UIPinchGestureRecognizer*)gesture {
    NSLog(@"Pinch.. %@", tableView.selectedIndexPath);
    if (gesture.state == UIGestureRecognizerStateEnded
        || gesture.state == UIGestureRecognizerStateChanged) {
//        currentImage.image = [UIImage imageNamed:@"close_x"];
        
        CGFloat currentScale = currentImage.frame.size.width / currentImage.bounds.size.width;
        CGFloat newScale = currentScale * gesture.scale;
        
        static float MINIMUM_SCALE = 0.3;
        static float MAXIMUM_SCALE = 3.0;
        
        if (newScale < MINIMUM_SCALE) {
            newScale = MINIMUM_SCALE;
        }
        if (newScale > MAXIMUM_SCALE) {
            newScale = MAXIMUM_SCALE;
        }
        
        CGAffineTransform transform = CGAffineTransformMakeScale(newScale, newScale);
        currentImage.transform = transform;
        
        NSLog(@"%@ = %f", currentImage, newScale);
        gesture.scale = 1;
    }
}

- (IBAction)onTap1:(id)sender{
    NSLog(@"tap 1");
}

#pragma mark - EasyTableViewDelegate

- (UIView *)easyTableView:(EasyTableView *)easyTableView viewForRect:(CGRect)rect{
    
//    NSLog(@"call viewfor rec %f %f %f %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
//    imageView.userInteractionEnabled = YES;
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

- (void)easyTableView:(EasyTableView *)easyTableView setDataForView:(UIView *)view forIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"call set data for view %@ - %@", indexPath, view);
    
    UIImageView *imageView =(UIImageView*)view;
    NSString *fileName = [listPathImage objectAtIndex:indexPath.row];
    
    imageView.image = [UIImage imageWithContentsOfFile:[dirPath stringByAppendingPathComponent:fileName]];
    
    imageView.transform = CGAffineTransformMakeScale(1, 1);
    _label.text = [NSString stringWithFormat:@"%d/%d", indexPath.row + 1, easyTableView.numberOfCells];
    _slider.value = indexPath.row;
    currentImage = imageView;
    
    NSLog(@"value : %f / %f", _slider.value, _slider.maximumValue);
}

- (IBAction)SliderBarValueChanged:(id)sender {
    int value = (int)(_slider.value + 0.5);
    _slider.value = value;
    [tableView selectCellAtIndexPath:[NSIndexPath indexPathForRow:value inSection:0] animated:YES];
}
@end
