//
//  SettingViewController.m
//  TekTalk_NSUserDefaults
//
//  Created by luu on 6/3/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import "SettingViewController.h"
#import "AppSetting.h"

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
    AppSetting *appSetting = [AppSetting shareInstance];
    _nameTextField.text = [appSetting userName];
    _soundSlider.value = [appSetting sound];
    _levelSegmented.selectedSegmentIndex = [appSetting level];
    _updateSwitch.selected = [appSetting autoUpdate];
}

- (void)saveSetting
{
    AppSetting *appSetting = [AppSetting shareInstance];
    appSetting.userName = _nameTextField.text;
    appSetting.sound = _soundSlider.value;
    appSetting.level = _levelSegmented.selectedSegmentIndex;
    appSetting.autoUpdate = _updateSwitch.selected;
    [appSetting save];
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
