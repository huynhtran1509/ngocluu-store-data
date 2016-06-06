//
//  TTModel.h
//  TruyenTranh
//
//  Created by LuuNN on 12/23/13.
//  Copyright (c) 2013 LuuNN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIDownloadBar.h"
#import "ZipArchive.h"

typedef void(^TTDownloadBarBlock)(UIDownloadBar *downloadBar, BOOL success, NSString *errorMessage);

@interface TTModel : NSObject<UIDownloadBarDelegate>

+ (TTModel*)shareModel;

@property (strong, readonly) NSMutableArray *listBook;
@property (strong, readonly) NSMutableArray *listBookmark;

- (BOOL)isDownloadedEbookAtIndext:(NSInteger)index;
- (UIDownloadBar *)createDownloadBarForBookAtIndext:(NSInteger)index completeBlock:(TTDownloadBarBlock)block frame:(CGRect)frame;
- (UIDownloadBar*)downloadBarForBookAtIndext:(NSInteger)index;
    
- (NSArray*)getListPathImageAtBookIndex:(NSInteger)index;
- (NSString*)getDirPathAtBookIndex:(NSInteger)index;

- (void)addBookmarkWithBook:(NSInteger)bookIndex page:(NSInteger)page;
- (void)deleteBookmarkAtIndex:(NSInteger)index;

@end