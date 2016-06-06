//
//  AppDelegate.m
//  TruyenTranh
//
//  Created by LuuNN on 12/19/13.
//  Copyright (c) 2013 LuuNN. All rights reserved.
//

#import "AppDelegate.h"
#import "TTHomeViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation AppDelegate
{
    TTHomeViewController *homeViewController;
    UINavigationController *navigationController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    application.backgroundTimeRemaining = 12;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@", paths[0]);
//    NSLog(@"%@", NSHomeDirectory());
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    homeViewController = [[TTHomeViewController alloc] initWithNibName:@"TTHomeViewController" bundle:Nil];
    navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    navigationController.navigationBarHidden  = YES;
    
    self.window.rootViewController = navigationController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    [application beginBackgroundTaskWithName:@"hii" expirationHandler:^{
        NSLog(@"resogma actove");
//    }];
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"did enter bag");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if (homeViewController == navigationController.topViewController) {
        [homeViewController showBookmarkMessage];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"app ter");
    [FBSession.activeSession close];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        NSLog(@"In fallback handler");
                    }];
}

@end
