//
//  TTHomeViewController.h
//  TruyenTranh
//
//  Created by LuuNN on 12/19/13.
//  Copyright (c) 2013 LuuNN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"
#import "UIDownloadBar.h"
#import "ZipArchive.h"
#import "WYPopoverController.h"
#import "TTBookMarkViewController.h"

@interface TTHomeViewController : TTBaseViewController<GMGridViewDataSource, GMGridViewActionDelegate, WYPopoverControllerDelegate, TTBookMarkViewControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet GMGridView *gridView;

- (IBAction)bookmarkButtonPressed:(UIButton *)sender;
- (void)showBookmarkMessage;

@property (nonatomic, strong) NSTimer *updateTimer;
//@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;

@end
