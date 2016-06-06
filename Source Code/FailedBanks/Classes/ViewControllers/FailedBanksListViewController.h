//
//  FailedBanksListViewController.h
//  FailedBanks
//
//  Created by Ray Wenderlich on 4/5/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FailedBanksDetailViewController;

@interface FailedBanksListViewController : UITableViewController {
    NSArray *_failedBankInfos;
    FailedBanksDetailViewController *_details;
}

@property (nonatomic, strong) NSArray *failedBankInfos;
@property (nonatomic, strong) FailedBanksDetailViewController *details;

@end
