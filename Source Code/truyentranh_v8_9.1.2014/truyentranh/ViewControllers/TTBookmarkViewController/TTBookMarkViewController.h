//
//  TTBookMarkViewController.h
//  TruyenTranh
//
//  Created by LuuNN on 12/26/13.
//  Copyright (c) 2013 LuuNN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTBookMarkViewController;

@protocol TTBookMarkViewControllerDelegate <NSObject>

@optional
- (void)TTBookMarkViewController:(TTBookMarkViewController *)bookMarkViewController didselectBookmard:(NSArray*)bookmark;

- (BOOL)TTBookMarkViewControllerSelectedAddBookmark:(TTBookMarkViewController*)bookMarkViewController;

- (BOOL)TTBookMarkViewController:(TTBookMarkViewController*)bookMarkViewController didDeleteRow:(NSInteger)index;

- (void)TTBookMarkViewController:(TTBookMarkViewController*)bookMarkViewController updateContentSize:(CGSize)size;

@end

@interface TTBookMarkViewController : UITableViewController

@property (nonatomic, weak) id<TTBookMarkViewControllerDelegate> bookMarkDelegate;
@property (nonatomic, strong) NSMutableArray *listBookMark;
- (void)setListBookMark:(NSMutableArray *)listBookMark shouldShowAddButton:(BOOL)showAddButton;

@end
