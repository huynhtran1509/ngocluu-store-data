//
//  TTBook.h
//  TruyenTranh
//
//  Created by LuuNN on 12/25/13.
//  Copyright (c) 2013 LuuNN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTBook : NSObject

- (id)initWithDictionary:(NSDictionary*)dictionary;

@property (strong,readonly) NSURL *url;
@property (strong,nonatomic) NSString *title;
@property (assign, nonatomic) BOOL isDownloaded;

@property (strong, nonatomic) NSArray *listPathImage;

@end
