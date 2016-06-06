//
//  TTReadingViewController.h
//  TruyenTranh
//
//  Created by LuuNN on 12/23/13.
//  Copyright (c) 2013 LuuNN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"
#import "GMGridViewLayoutStrategies.h"
#import "TTBookMarkViewController.h"
#import "WYPopoverController.h"
#import "TTSlider.h"
#import "TTImageView.h"

#import "RGMPagingScrollView.h"
#import "TTShareHelper.h"
#import "TTShareViewController.h"

@interface TTReadingViewController : TTBaseViewController<TTSliderTrackDelegate, TTBookMarkViewControllerDelegate, TTShareViewControllerDelegate, TTShareHelperDelegate, RGMPagingScrollViewDatasource,RGMPagingScrollViewDelegate, TTImageViewDelegate, WYPopoverControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet TTSlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet RGMPagingScrollView *pageingScrollview;

- (IBAction)SliderBarValueChanged:(id)sender;

@property (assign, nonatomic) NSInteger index;
@property (assign,nonatomic) NSInteger currentPage;

- (IBAction)homeButtonPressed:(id)sender;
- (IBAction)bookmarkButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;

- (void)updateTable;

@end
