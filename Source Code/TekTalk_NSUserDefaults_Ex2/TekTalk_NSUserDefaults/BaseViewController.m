//
//  BaseViewController.m
//  TekTalk_NSUserDefaults
//
//  Created by luu on 6/3/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma - hiden keyboard

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
