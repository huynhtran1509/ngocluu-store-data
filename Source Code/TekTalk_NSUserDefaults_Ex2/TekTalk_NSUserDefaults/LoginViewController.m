//
//  LoginViewController.m
//  TekTalk_NSUserDefaults
//
//  Created by luu on 6/2/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import "LoginViewController.h"

NSString *const kREMEMBER = @"kREMEMBER";
NSString *const kUSER = @"kUSER";

@interface LoginViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *userTextField;
@property (nonatomic, weak) IBOutlet UITextField *passTextField;

@property (nonatomic, weak) IBOutlet UIButton *rememberButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL didRemember = YES; // default = YES
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kREMEMBER]) {
        // did setting
        didRemember = [[NSUserDefaults standardUserDefaults] boolForKey:kREMEMBER];
    }
    
    // update UI, selected state = did remember, normal = not remember
    _rememberButton.selected = didRemember;
    
    if (didRemember) {
        _userTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kUSER];
    }
}

- (void)login:(NSString*)user password:(NSString*)pass complete:(void (^)(BOOL))complete{
    // process login..
    // call complete(succes) when finish
    // hard code login admin/admin
//    BOOL succes = [user isEqualToString:@"admin"] && [pass isEqualToString:@"admin"];
    complete(YES);
}

- (IBAction)onLoginClick:(id)sender {
    BOOL shouldRemember = _rememberButton.selected;
    NSString *user = _userTextField.text;
    NSString *pass = _passTextField.text;
    
    [self login:user password:pass complete:^(BOOL succes) {
        if (succes) {
            // save remember value + user(if user check remember)
            [[NSUserDefaults standardUserDefaults] setBool:shouldRemember forKey:kREMEMBER];
            if (shouldRemember) {
                [[NSUserDefaults standardUserDefaults] setValue:user forKey:kUSER];
            }else{
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUSER];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // push main view
            [self performSegueWithIdentifier:@"pus_main" sender:self];
        }else{
            // message to user
            [[[UIAlertView alloc] initWithTitle:@"Login" message:@"Login false" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
        }
    }];
}

- (IBAction)onRememberClick:(id)sender {
    _rememberButton.selected = !_rememberButton.selected;
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
