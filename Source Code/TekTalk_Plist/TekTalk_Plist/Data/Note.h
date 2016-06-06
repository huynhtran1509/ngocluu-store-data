//
//  Note.h
//  TekTalk_Plist
//
//  Created by luu on 6/3/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject <NSCoding>
//
//- (instancetype)initWithFileName:(NSString*)fileName;

@property (nonatomic) NSString *fileName;

@property (nonatomic) NSDate *time;
@property (nonatomic) NSString *text;

@end