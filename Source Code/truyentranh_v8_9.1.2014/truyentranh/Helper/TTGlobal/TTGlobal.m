//
//  TTGlobal.m
//  TruyenTranh
//
//  Created by LuuNN on 12/23/13.
//  Copyright (c) 2013 LuuNN. All rights reserved.
//

#import "TTGlobal.h"

NSString *KEY_BLOCK = @"KEY_BLOCK";

NSString *KEY_BOOK = @"KEY_BOOK";
NSString *KEY_BOOKMARK = @"KEY_BOOKMARK";
NSString *KEY_BOOK_PATH = @"KEY_PATH";
NSString *KEY_BOOK_NAME = @"KEY_NAME";
NSString *KEY_BOOK_LINK = @"KEY_LINK";
NSString *KEY_BOOK_IS_DOWNLOADED = @"KEY_IS_DOWNLOADED";

@implementation TTGlobal

+ (BOOL)isIphone
{
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
}

+ (BOOL)isMultitaskingSupported
{
	BOOL multiTaskingSupported = NO;
	if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
		multiTaskingSupported = [(id)[UIDevice currentDevice] isMultitaskingSupported];
	}
	return multiTaskingSupported;
}

@end
