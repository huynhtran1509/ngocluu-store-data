//
//  NoteManager.h
//  TekTalk_Plist
//
//  Created by luu on 6/3/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Note;

@interface NoteDatabase : NSObject

+ (instancetype)shareInstance;

- (NSArray*)allNote;

- (Note*)newNote;
- (void)saveChange:(Note*)note;
- (void)deleteNote:(Note*)note;

@end
