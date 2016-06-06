//
//  FailedBanksDetailViewController.h
//  FailedBanks
//
//  Created by Ray Wenderlich on 4/5/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FailedBanksDetailViewController : UIViewController {
    UILabel *_nameLabel;
    UILabel *_cityLabel;
    UILabel *_stateLabel;
    UILabel *_zipLabel;
    UILabel *_closedLabel;
    UILabel *_updatedLabel;
    int _uniqueId;
}

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *cityLabel;
@property (nonatomic, strong) IBOutlet UILabel *stateLabel;
@property (nonatomic, strong) IBOutlet UILabel *zipLabel;
@property (nonatomic, strong) IBOutlet UILabel *closedLabel;
@property (nonatomic, strong) IBOutlet UILabel *updatedLabel;
@property (nonatomic, assign) int uniqueId;

@end
