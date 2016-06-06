//
//  Post.h
//  TekTalk_CoreData
//
//  Created by luu on 6/4/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Post : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSDate * dateCreate;
@property (nonatomic, retain) NSNumber * flow;
@property (nonatomic, retain) User *user;

@end
