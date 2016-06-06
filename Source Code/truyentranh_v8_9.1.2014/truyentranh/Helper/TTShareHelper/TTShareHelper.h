//
//  TTShareHelper.h
//  TruyenTranh
//
//  Created by LuuNN on 12/26/13.
//  Copyright (c) 2013 LuuNN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>
#import <FacebookSDK/FacebookSDK.h>

@protocol TTShareHelperDelegate <NSObject>

@required

- (void)didShareWithType:(TTShareType)shareType result:(TTShareResult)result errorMessage:(NSString*)error;

@end

@interface TTShareHelper : NSObject<MFMailComposeViewControllerDelegate>

+ (TTShareHelper*)shareInstant;

- (void)shareOverEmailWithSubject:(NSString*)subject
                          message:(NSString*)message
                        pathImage:(NSString*)pathImage
               fromViewController:(UIViewController*)viewController
                         delegate:(id<TTShareHelperDelegate>)delegate;

- (void)shareOverTwitterWithMessage:(NSString*)message
                          pathImage:(NSString*)pathImage
                 fromViewController:(UIViewController*)viewController
                           delegate:(id<TTShareHelperDelegate>)delegate;

- (void)shareOverFacebookWithSubject:(NSString *)subject
                             message:(NSString *)message
                           pathImage:(NSString *)pathImage
                  fromViewController:(UIViewController *)viewController
                            delegate:(id<TTShareHelperDelegate>)delegate;

@end
