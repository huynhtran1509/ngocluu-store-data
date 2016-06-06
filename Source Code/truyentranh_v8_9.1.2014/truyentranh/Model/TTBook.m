//
//  TTBook.m
//  TruyenTranh
//
//  Created by LuuNN on 12/25/13.
//  Copyright (c) 2013 LuuNN. All rights reserved.
//

#import "TTBook.h"

@implementation TTBook

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    if(self = [super init]){
        _url = [NSURL URLWithString:[dictionary valueForKey:KEY_BOOK_LINK]];
        _title = [dictionary valueForKey:KEY_BOOK_NAME];
        
        _isDownloaded = NO;
    }
    
    return self;
}


@end
