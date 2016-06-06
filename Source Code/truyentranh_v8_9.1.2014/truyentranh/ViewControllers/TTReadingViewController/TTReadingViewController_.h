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

#import "EasyTableView.h"

@interface TTReadingViewController : UIViewController<EasyTableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *label;

- (IBAction)SliderBarValueChanged:(id)sender;
@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) IBOutlet GMGridView *gridView;

- (IBAction)onTap:(id)sender;
- (IBAction)onTap1:(id)sender;
- (IBAction)homeButtonPressed:(id)sender;
- (IBAction)onPinch:(UIPinchGestureRecognizer*)gesture;

@end
