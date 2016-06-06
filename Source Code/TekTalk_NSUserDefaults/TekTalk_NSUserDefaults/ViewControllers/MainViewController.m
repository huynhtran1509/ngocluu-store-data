//
//  MainViewController.m
//  TekTalk_NSUserDefaults
//
//  Created by luu on 6/3/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import "MainViewController.h"
#import "NSUserDefaults+Setting.h"

@interface MainViewController ()

@property (nonatomic, weak) IBOutlet UILabel *welcomeLabel;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateWelcomeLabel:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWelcomeLabel:) name:kSettingChangedNotifycation object:nil];
}

- (void)updateWelcomeLabel:(NSNotification*)notification
{
    NSString *userName = [NSUserDefaults standardUserDefaults].userName;
    if (userName.length > 0) {
        _welcomeLabel.text = [NSString stringWithFormat:@"Welcome %@", userName];
        _welcomeLabel.hidden = NO;
    }else{
        _welcomeLabel.hidden = YES;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
