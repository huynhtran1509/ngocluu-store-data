//
//  LoginViewController.m
//  TekTalk_NSUserDefaults
//
//  Created by luu on 6/2/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import "LoginViewController.h"
#import "Keychain.h"

NSString *const kREMEMBER       = @"kREMEMBER";

NSString *const kUSER           = @"kUSER";
NSString *const kPASSWORD       = @"kPASSWORD";
NSString *const kServiceName    = @"tektalk.account.login";

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
        NSString *user = [[NSUserDefaults standardUserDefaults] stringForKey:kUSER];
        _userTextField.text = user;
        if (user.length > 0) {
            Keychain *keychain = [[Keychain alloc] initWithService:kServiceName withGroup:nil];
            NSData *userData = [keychain find:kUSER];
            if (userData) {
                _userTextField.text = [[NSString alloc] initWithData:userData encoding:NSUTF8StringEncoding];
            }
            NSData *passwordData = [keychain find:kPASSWORD];
            if (passwordData) {
                _passTextField.text = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
            }
        }
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
            Keychain *keychain = [[Keychain alloc] initWithService:kServiceName withGroup:nil];
            if (shouldRemember) {
                // save user
                [[NSUserDefaults standardUserDefaults] setValue:user forKey:kUSER];
                
                // save password
                NSData *userData = [user dataUsingEncoding:NSUTF8StringEncoding];
                NSData *passwordData = [pass dataUsingEncoding:NSUTF8StringEncoding];
                if ([keychain find:kUSER]) {
                    // update
                    [keychain update:kUSER :userData];
                }else{
                    // save new
                    [keychain insert:user :passwordData];
                }
                
                if ([keychain find:kPASSWORD]) {
                    // update
                    [keychain update:kPASSWORD :passwordData];
                }else{
                    // save new
                    [keychain insert:kPASSWORD :passwordData];
                }
            }else{
                [keychain remove:kUSER];
                [keychain remove:kPASSWORD];
            }
            
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
