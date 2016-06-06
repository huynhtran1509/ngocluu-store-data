//
//  FailedBanksAppDelegate.m
//  FailedBanks
//
//  Created by Ray Wenderlich on 4/5/10.
//  Copyright Ray Wenderlich 2010. All rights reserved.
//

#import "FailedBanksAppDelegate.h"
#import "FailedBankDatabase.h"
#import "FailedBankInfo.h"

@implementation FailedBanksAppDelegate
@synthesize navController = _navController;
@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

//    NSArray *failedBankInfos = [FailedBankDatabase database].failedBankInfos;
//    for (FailedBankInfo *info in failedBankInfos) {
//        NSLog(@"%d: %@, %@, %@", info.uniqueId, info.name, info.city, info.state);
//    }
    
    [window addSubview:_navController.view];
    
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}




@end
