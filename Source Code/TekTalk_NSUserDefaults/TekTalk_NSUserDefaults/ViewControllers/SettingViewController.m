//
//  SettingViewController.m
//  TekTalk_NSUserDefaults
//
//  Created by luu on 6/3/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import "SettingViewController.h"
#import "NSUserDefaults+Setting.h"

@interface SettingViewController ()

@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UISlider *soundSlider;
@property (nonatomic, weak) IBOutlet UISegmentedControl *levelSegmented;
@property (nonatomic, weak) IBOutlet UISwitch *updateSwitch;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSetting];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self saveSetting];
}

#pragma mark - Load/Save Setting
- (void)loadSetting
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _nameTextField.text = [userDefault userName];
    _soundSlider.value = [userDefault sound];
    _levelSegmented.selectedSegmentIndex = [userDefault level];
    _updateSwitch.selected = [userDefault autoUpdate];
}

- (void)saveSetting
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    userDefault.userName = _nameTextField.text;
    userDefault.sound = _soundSlider.value;
    userDefault.level = _levelSegmented.selectedSegmentIndex;
    userDefault.autoUpdate = _updateSwitch.selected;
    [userDefault save];
}

#pragma mark - hiden keyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self hidenKeyboard];
    return YES;
}

- (IBAction)onBackgroundTap:(id)sender {
    [self hidenKeyboard];
}

- (void)hidenKeyboard {
    [self.view endEditing:YES];
}

@end
