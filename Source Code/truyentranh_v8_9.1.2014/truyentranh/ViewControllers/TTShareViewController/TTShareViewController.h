//
//  TTShareViewController.h
//  TruyenTranh
//
//  Created by LuuNN on 12/26/13.
//  Copyright (c) 2013 LuuNN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTShareViewController;

@protocol TTShareViewControllerDelegate <NSObject>

@optional
- (void)TTShareViewController:(TTShareViewController *)bookMarkViewController didselectSharetype:(TTShareType)sharetype;

@end

@interface TTShareViewController : UITableViewController

@property (nonatomic, weak) id<TTShareViewControllerDelegate> shareDelegate;

@end
