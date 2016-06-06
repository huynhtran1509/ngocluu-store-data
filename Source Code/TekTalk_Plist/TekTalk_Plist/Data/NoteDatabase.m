//
//  NoteManager.m
//  TekTalk_Plist
//
//  Created by luu on 6/3/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import "NoteDatabase.h"
#import "Note.h"

NSString *const kNOTE      = @"kNOTE";

@implementation NoteDatabase
{
    NSMutableArray *_allNotes;
}

+ (instancetype)shareInstance
{
    static NoteDatabase *_shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [NoteDatabase new];
        [_shareInstance loadDB];
    });
    
    return _shareInstance;
}

- (void)loadDB
{
    NSString *pathFolder = [self dataFolder];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathFolder]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:pathFolder withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"error : %@", error);
        }
    }
    
    NSError *error;
    NSArray *allFile = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathFolder error:&error];
    if(error){
        NSLog(@"error : %@", error);
        return;
    }
    
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self != '.DS_Store'"];
    allFile = [allFile filteredArrayUsingPredicate:fltr];
    
    NSArray *allFileSorted = [allFile sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    _allNotes = [NSMutableArray array];
    for (NSString *fileName in allFileSorted) {
        NSString *fullPath = [[self dataFolder] stringByAppendingPathComponent:fileName];
        NSData *data = [NSData dataWithContentsOfFile:fullPath];
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        Note *note = [unarchiver decodeObjectForKey:kNOTE];
        
        if (note) {
            note.fileName = fileName;
            [_allNotes addObject:note];
        }
        
        [unarchiver finishDecoding];
    }
}

- (NSArray *)allNote
{
    return [NSArray arrayWithArray:_allNotes];
}

- (Note *)newNote
{
    Note *newNote = [[Note alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    newNote.fileName = [[dateFormatter stringFromDate:[NSDate date]] stringByAppendingPathExtension:@"plist"];
    [_allNotes insertObject:newNote atIndex:0];
    
    return newNote;
}

- (void)deleteNote:(Note *)note
{
    [_allNotes removeObject:note];
    NSError *error;
    if(![[NSFileManager defaultManager] removeItemAtPath:[self pathForNote:note] error:&error]){
        NSLog(@"Remove error %@", error);
    }
}

- (void)saveChange:(Note *)note
{
    NSString *dataPath = [self pathForNote:note];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:note forKey:kNOTE];
    [archiver finishEncoding];
    
    [data writeToFile:dataPath atomically:YES];
}

#pragma mark - Helper method

- (NSString*)pathForNote:(Note*)note
{
    return [[self dataFolder] stringByAppendingPathComponent:note.fileName];
}

- (NSString*)dataFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths.firstObject stringByAppendingPathComponent:@"data"];
}

@end
