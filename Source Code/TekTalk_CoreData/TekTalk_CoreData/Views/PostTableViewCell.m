//
//  PostTableViewCell.m
//  TekTalk_CoreData
//
//  Created by luu on 6/4/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import "PostTableViewCell.h"

@implementation PostTableViewCell

- (IBAction)onFlowClick:(id)sender
{
    if ([_postCellDelegate respondsToSelector:@selector(postTableViewCellDidClickFlow:)]) {
        [_postCellDelegate postTableViewCellDidClickFlow:self];
    }
}

@end
