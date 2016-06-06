//
//  PostTableViewCell.h
//  TekTalk_CoreData
//
//  Created by luu on 6/4/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Post;
@class PostTableViewCell;

@protocol PostTableViewCellDelegate <NSObject>

@optional
- (void)postTableViewCellDidClickFlow:(PostTableViewCell*)cell;

@end

@interface PostTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;
@property (nonatomic, weak) IBOutlet UILabel *userLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateCreateLabel;
@property (nonatomic, weak) IBOutlet UIButton *flowButton;

@property (nonatomic, weak) IBOutlet id<PostTableViewCellDelegate> postCellDelegate;

@end