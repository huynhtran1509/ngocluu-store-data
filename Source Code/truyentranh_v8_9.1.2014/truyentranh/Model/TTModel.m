//
//  TTModel.m
//  TruyenTranh
//
//  Created by LuuNN on 12/23/13.
//  Copyright (c) 2013 LuuNN. All rights reserved.
//

#import "TTModel.h"
#include<sys/xattr.h>

@implementation TTModel{
    NSMutableDictionary *listDownloadBar;
}

+ (TTModel *)shareModel{
    
    static TTModel *modelShare;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        modelShare = [[TTModel alloc] init];
    });
    
    return modelShare;
}

- (id)init{
    if (self = [super init]) {
        NSString *filePath = [self pathPlistFile];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            _listBook = [NSMutableArray arrayWithContentsOfFile:filePath];
        }
        
        if (!_listBook) {
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"book" ofType:@"plist"];
            NSArray *listBookFromFile = [NSArray arrayWithContentsOfFile:path];

            _listBook = [[NSMutableArray alloc] init];
            for (NSDictionary *bookDic in listBookFromFile) {
                NSMutableDictionary *book = [bookDic mutableCopy];
                [_listBook addObject:book];
            }
            
            [self saveListBook];
        }
        
        _listBookmark = [[NSUserDefaults standardUserDefaults] valueForKey:KEY_BOOKMARK];
        
        if (!_listBookmark) {
            _listBookmark = [[NSMutableArray alloc] init];
        }
        
        listDownloadBar = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (BOOL)isDownloadedEbookAtIndext:(NSInteger)index{
    NSMutableDictionary *book = _listBook[index];
    return [[book valueForKey:KEY_BOOK_IS_DOWNLOADED] boolValue];
}

- (UIDownloadBar *)createDownloadBarForBookAtIndext:(NSInteger)index completeBlock:(TTDownloadBarBlock)block frame:(CGRect)frame{
    
    NSString *link = [_listBook[index] objectForKey:KEY_BOOK_LINK];
    NSURL *url = [NSURL URLWithString:link];
    
    UIDownloadBar *downloadBar = [[UIDownloadBar alloc] initWithURL:url progressBarFrame:frame timeout:60*60*5 delegate:self];
    downloadBar.tag = index;
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0){
        int scale = 5;
        CGAffineTransform transform = CGAffineTransformMake(1, 0, 0, scale, 0, -scale);// you can change the sy as you want
        downloadBar.transform = transform;
    }
    
    ///----------------------
    [downloadBar setTrackTintColor:[UIColor colorWithRed:59.0/255.0 green:35.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [downloadBar setProgressTintColor:[UIColor colorWithRed:156.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0]];
    ///----------------------

    [downloadBar.layer setValue:block forKey:KEY_BLOCK];
    
    NSString *key = [NSString stringWithFormat:@"%d", index];
    [listDownloadBar setValue:downloadBar forKey:key];
    
    return downloadBar;
}

- (UIDownloadBar*)downloadBarForBookAtIndext:(NSInteger)index {
    NSString *key = [NSString stringWithFormat:@"%d", index];
    return listDownloadBar[key];
}

- (NSArray *)getListPathImageAtBookIndex:(NSInteger)index{
    NSString *fullPath = [self getDirPathAtBookIndex:index];
    
    NSError *error;
    NSArray *listPath = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fullPath error:&error];
    if(error){
        NSLog(@"error : %@", error);
//        [book setValue:[NSNumber numberWithBool:NO] forKey:KEY_BOOK_IS_DOWNLOADED];
//        [self saveListBook];
//        book setValue:[ns] forKey:<#(NSString *)#>
        return nil;
    }

    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self != '.DS_Store'"];
    listPath = [listPath filteredArrayUsingPredicate:fltr];

    NSArray *listPathSorted = [listPath sortedArrayUsingComparator:^NSComparisonResult(NSString *s1, NSString *s2) {
        return [s1 localizedStandardCompare:s2];
    }];

    return listPathSorted;
}


#pragma mark - UIDownloadBarDelegate
- (void)downloadBar:(UIDownloadBar *)downloadBar didFinishWithData:(NSData *)fileData suggestedFilename:(NSString *)filename{

    NSString *key = [NSString stringWithFormat:@"%d", downloadBar.tag];
    [listDownloadBar removeObjectForKey:key];
    
    NSString *dataDirectory = [[self documentPath] stringByAppendingPathComponent:@"data"];
    
    BOOL isExitFile;
    BOOL isDir;
    
    isExitFile = [[NSFileManager defaultManager] fileExistsAtPath:dataDirectory isDirectory:&isDir];
    
    if (isExitFile) {
        if (!isDir) {
            [[NSFileManager defaultManager] removeItemAtPath:dataDirectory error:nil];
        }
    }else{
        [[NSFileManager defaultManager] createDirectoryAtPath:dataDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        NSURL *url = [NSURL fileURLWithPath:dataDirectory];

        [self addSkipBackupAttributeToItemAtURL:url];
    }

    NSString *errorMessage = [self saveAndUnzipData:fileData fileName:filename toPath:dataDirectory];
    
    if(!errorMessage){
        NSMutableDictionary *book = _listBook[downloadBar.tag];
        [book setValue:[NSNumber numberWithBool:YES] forKey:KEY_BOOK_IS_DOWNLOADED];
        NSString *path = [@"data" stringByAppendingPathComponent:[filename stringByDeletingPathExtension]];
        
        [book setValue:path forKey:KEY_BOOK_PATH];
        [self saveListBook];
    }
    
    TTDownloadBarBlock block = [downloadBar.layer valueForKey:KEY_BLOCK];
    block(downloadBar, !errorMessage, errorMessage);
}

- (void)downloadBarUpdated:(UIDownloadBar *)downloadBar{
//    NSLog(@"update : %f", downloadBar.percentComplete);
}

- (void)downloadBar:(UIDownloadBar *)downloadBar didFailWithError:(NSError *)error{
    NSString *key = [NSString stringWithFormat:@"%d", downloadBar.tag];
    [listDownloadBar removeObjectForKey:key];
    
    TTDownloadBarBlock block = [downloadBar.layer valueForKey:KEY_BLOCK];
    block(downloadBar, NO, @"Can't download file.");
}

////////////////////////Save File
- (NSString*)saveAndUnzipData:(NSData*)fileData fileName:(NSString*)fileName toPath:(NSString*)path {
    
    NSArray *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *fullPath = [[cachePath objectAtIndex:0] stringByAppendingPathComponent:fileName];
//    [ns]
    if([fileData writeToFile:fullPath atomically:YES]){
        BOOL complete = [self unzipFileWithPath:fullPath toPath:path];
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
        if(!complete){
            return @"Can't unzip file.";
        }else
        {
            return nil;
        }
    }
    
    return @"Can't save zip file.";
}

////////////////////////UnzipFile
-(BOOL)unzipFileWithPath:(NSString *)zipFilePath toPath:(NSString *)pathOut
{
    ZipArchive* za = [[ZipArchive alloc] init];
    
    if( [za UnzipOpenFile:zipFilePath] ) {
        if( [za UnzipFileTo:pathOut overWrite:YES]) {
            NSLog(@"unzip success");
            return YES;
        }
        
        [za UnzipCloseFile];
    }
    
    return NO;
    
}

- (NSString*)pathPlistFile
{
    return [[self documentPath] stringByAppendingPathComponent:@"books.plist"];
}

- (NSString*)documentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths.firstObject;
}

- (void)saveListBook{
    [_listBook writeToFile:[self pathPlistFile] atomically:YES];
}

- (void)saveListBookmark{
    [[NSUserDefaults standardUserDefaults] setValue:_listBookmark forKey:KEY_BOOKMARK];
}

- (NSString*)getDirPathAtBookIndex:(NSInteger)index{
    NSDictionary *book = _listBook[index];
    NSString *path = [book valueForKey:KEY_BOOK_PATH];
    return [[self documentPath] stringByAppendingPathComponent:path];
}

- (void)deleteBookmarkAtIndex:(NSInteger)index
{
    [_listBookmark removeObjectAtIndex:index];
    [self saveListBookmark];
}

- (void)addBookmarkWithBook:(NSInteger)bookIndex page:(NSInteger)page
{
    NSString *title = [NSString stringWithFormat:@"Tập %d,trang %d", bookIndex +1, page +1];
    NSArray *bookmark = @[[NSNumber numberWithInteger:bookIndex], [NSNumber numberWithInteger:page], title];
    [_listBookmark insertObject:bookmark atIndex:0];
    [self saveListBookmark];
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    if (&NSURLIsExcludedFromBackupKey == nil) { // iOS <= 5.0.1
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    } else { // iOS >= 5.1
        NSError *error = nil;
        [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
        return error == nil;
    }
}

@end