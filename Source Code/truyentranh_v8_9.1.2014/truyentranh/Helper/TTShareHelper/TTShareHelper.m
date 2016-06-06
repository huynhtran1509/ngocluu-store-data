//
//  TTShareHelper.m
//  TruyenTranh
//
//  Created by LuuNN on 12/26/13.
//  Copyright (c) 2013 LuuNN. All rights reserved.
//

#import "TTShareHelper.h"

@implementation TTShareHelper
{
    __weak id<TTShareHelperDelegate> shareDelegate;
}

+ (TTShareHelper*)shareInstant
{
    static TTShareHelper *shareInstant;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstant = [[TTShareHelper alloc] init];
    });
    
    return shareInstant;
}

- (void)shareOverEmailWithSubject:(NSString*)subject
                          message:(NSString*)message
                        pathImage:(NSString*)pathImage
               fromViewController:(UIViewController*)viewController
                         delegate:(id<TTShareHelperDelegate>)delegate
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        [mailViewController setMessageBody:message isHTML:NO];
        [mailViewController setSubject:subject];
        [mailViewController addAttachmentData:[NSData dataWithContentsOfFile:pathImage] mimeType:@"jpg" fileName:pathImage.lastPathComponent];
        mailViewController.mailComposeDelegate = self;
        
        [viewController presentViewController:mailViewController animated:YES completion:nil];
        shareDelegate = delegate;
    }else{
        if ([delegate respondsToSelector:@selector(didShareWithType:result:errorMessage:)]) {
            [delegate didShareWithType:TTShareTypeEmail result:(TTShareResultError) errorMessage:@"Device can't send email."];
        }
        
        NSLog(@"Can't send mail, note : simulator can't send email");
    }
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:^{
        
        if ([shareDelegate respondsToSelector:@selector(didShareWithType:result:errorMessage:)]) {
            NSString *errorMessage;
            TTShareResult shareResult;
            switch (result) {
                case MFMailComposeResultSaved:
                case MFMailComposeResultCancelled:
                    shareResult = TTShareResultUserCancel;
                    break;
                case MFMailComposeResultFailed:
                    shareResult = TTShareResultError;
                    errorMessage = @"Error, can't send email";
                    break;
                case MFMailComposeResultSent:
                    shareResult = TTShareResultSuccess;
                    
                default:
                    break;
            }
            
            [shareDelegate didShareWithType:TTShareTypeEmail result:shareResult errorMessage:errorMessage];
        }
        NSLog(@"send mail with error %@", error);
    }];
}

- (void)shareOverTwitterWithMessage:(NSString*)message
                          pathImage:(NSString*)pathImage
                 fromViewController:(UIViewController*)viewController
                           delegate:(id<TTShareHelperDelegate>)delegate
{
    if([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *shareTwitterViewController = [[TWTweetComposeViewController alloc] init];
        [shareTwitterViewController setInitialText:message];
        [shareTwitterViewController addImage:[UIImage imageWithContentsOfFile:pathImage]];
        [shareTwitterViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
            
            [viewController dismissViewControllerAnimated:YES completion:^{
                
                if ([delegate respondsToSelector:@selector(didShareWithType:result:errorMessage:)]) {
                    TTShareResult shareResult;

                    switch (result) {
                        case TWTweetComposeViewControllerResultCancelled:
                            shareResult = TTShareResultUserCancel;
                            break;
                        case TWTweetComposeViewControllerResultDone:
                            shareResult = TTShareResultSuccess;
                            break;
                        default:
                            break;
                    }
                    
                    [delegate didShareWithType:(TTShareTypeTwitter) result:shareResult errorMessage:nil];
                }
            }];
            
        }];
        
        [viewController presentViewController:shareTwitterViewController animated:YES completion:nil];
    }else{
        NSLog(@"can't share twitter because no account");
    }
}


#pragma mark -

// Post Status Update button handler; will attempt different approaches depending upon configuration.
- (void)shareOverFacebookWithSubject:(NSString *)subject
                             message:(NSString *)message
                           pathImage:(NSString *)pathImage
                  fromViewController:(UIViewController *)viewController
                            delegate:(id<TTShareHelperDelegate>)delegate
{
    FBAppCall *appCall = [FBDialogs presentShareDialogWithLink:nil
                                                          name:@"Truyen Tranh"
                                                       caption:subject
                                                   description:message
                                                       picture:[NSURL URLWithString:pathImage]
                                                   clientState:nil
                                                       handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                           
                                                           NSLog(@"share face with error : %@", error);
                                                           
                                                           if ([delegate respondsToSelector:@selector(didShareWithType:result:errorMessage:)]) {
                                                               
                                                               NSString *errorMessage;
                                                               TTShareResult shareResult;
                                                               if (error) {
                                                                   shareResult = TTShareResultError;
                                                                   errorMessage = @"Can't share facebook";
                                                               } else {
                                                                   shareResult = TTShareResultSuccess;
                                                               }
                                                               [delegate didShareWithType:TTShareTypeFacebook result:shareResult errorMessage:errorMessage];
                                                           }
                                                       }];
    
    if (!appCall) {
        // Next try to post using Facebook's iOS6 integration
        //        if ([FBSession activeSession].state != FBSessionStateOpen) {
        //            [[FBSession openActiveSessionWithAllowLoginUI:YES
        //        }
        
        BOOL displayedNativeDialog = [FBDialogs canPresentOSIntegratedShareDialogWithSession:nil];
        
        if (displayedNativeDialog) {
            [FBDialogs presentOSIntegratedShareDialogModallyFrom:viewController initialText:message image:[UIImage imageWithContentsOfFile:pathImage] url:nil handler:^(FBOSIntegratedShareDialogResult result, NSError *error) {
                
                
                if ([delegate respondsToSelector:@selector(didShareWithType:result:errorMessage:)]) {
                    
                    NSString *errorMessage;
                    TTShareResult shareResult;
                    
                    switch (result) {
                        case FBOSIntegratedShareDialogResultSucceeded:
                            shareResult = TTShareResultSuccess;
                            break;
                        case FBOSIntegratedShareDialogResultCancelled:
                            shareResult = TTShareResultUserCancel;
                            break;
                        case FBOSIntegratedShareDialogResultError:
                            shareResult = TTShareResultError;
                            errorMessage = @"Can't share facebook";
                            break;
                        default:
                            break;
                    }
                    
                    [delegate didShareWithType:TTShareTypeFacebook result:shareResult errorMessage:errorMessage];
                }
                
                NSLog(@"error :%@", error);
                
            }];
            
        }else
        {
            
            [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"] defaultAudience:(FBSessionDefaultAudienceEveryone) allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                //1
                
                if (error)
                {
                    // login false -> user cancel
                    if ([delegate respondsToSelector:@selector(didShareWithType:result:errorMessage:)]) {
                        [delegate didShareWithType:TTShareTypeFacebook result:TTShareResultUserCancel errorMessage:nil];
                    }
                    
                    NSLog(@"error :%@", error);
                    return;
                }
                
                [self performPublishAction:^{
                    NSData* imageData = [NSData dataWithContentsOfFile:pathImage];
                    
                    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                    message, @"name",
                                                    imageData, [pathImage lastPathComponent],
                                                    nil];
                    
                    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
                    connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
                    | FBRequestConnectionErrorBehaviorAlertUser
                    | FBRequestConnectionErrorBehaviorRetry;
                    
                    NSLog(@"ispoxy : %d", connection.isProxy);
//                    connection setis;
                    
                    [connection addRequest:[FBRequest requestWithGraphPath:@"me/photos" parameters:params HTTPMethod:@"POST"] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                        
//                        static i = 0;
//                        NSLog(@"%d" , ++i);
                        
                        NSLog(@"share face with error : %@", error.description);
                        if ([delegate respondsToSelector:@selector(didShareWithType:result:errorMessage:)]) {
                            
                            NSString *errorMessage;
                            TTShareResult shareResult;
                            if (error) {
                                shareResult = TTShareResultError;
                                errorMessage = @"Can't share facebook";
                            } else {
                                shareResult = TTShareResultSuccess;
                            }
                            [delegate didShareWithType:TTShareTypeFacebook result:shareResult errorMessage:errorMessage];
                        }

                    }];
                    
                    [connection start];
                } shareDelegate:delegate];
            }];
        }
    }
}

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action shareDelegate:(id<TTShareHelperDelegate>)delegate{
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                } else
//                                                    if (error.fberrorCategory != FBErrorCategoryUserCancelled)
                                                {
                                                    if ([delegate respondsToSelector:@selector(didShareWithType:result:errorMessage:)]) {
                                                        [delegate didShareWithType:TTShareTypeFacebook result:TTShareResultError errorMessage:@"Not permission to share"];
                                                    }
                                                    
                                                    NSLog(@"error :%@", error);

                                                }
                                            }];
    } else {
        action();
    }
}

@end
