//
//  User.m
//  TekTalk_CoreData
//
//  Created by luu on 6/4/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import "User.h"
#import "Post.h"


@implementation User

@dynamic name;
@dynamic posts;

- (NSInteger)numberPost
{
    return self.posts.count;
}

@end
