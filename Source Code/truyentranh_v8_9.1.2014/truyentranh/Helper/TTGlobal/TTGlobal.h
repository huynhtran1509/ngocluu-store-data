//
//  TTGlobal.h
//  TruyenTranh
//
//  Created by LuuNN on 12/23/13.
//  Copyright (c) 2013 LuuNN. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *KEY_BLOCK;

extern NSString *KEY_BOOK;
extern NSString *KEY_BOOKMARK;

extern NSString *KEY_BOOK_PATH;
extern NSString *KEY_BOOK_NAME;
extern NSString *KEY_BOOK_LINK;
extern NSString *KEY_BOOK_IS_DOWNLOADED;

typedef enum {
    TTShareTypeEmail = 0,
    TTShareTypeFacebook = 1,
    TTShareTypeTwitter = 2
} TTShareType;

typedef enum {
    TTShareResultUserCancel = 0,
    TTShareResultError = 1,
    TTShareResultSuccess = 2
} TTShareResult;

@interface TTGlobal : NSObject

+ (BOOL)isIphone;
+ (BOOL)isMultitaskingSupported;

@end
