//
//  Note.m
//  TekTalk_Plist
//
//  Created by luu on 6/3/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import "Note.h"

NSString *const kTIME      = @"kTIME";
NSString *const kTEXT      = @"kTEXT";

@implementation Note

//- (instancetype)initWithFileName:(NSString *)fileName
//{
//    if (self = [super init]) {
//        _fileName = fileName;
//    }
//    
//    return self;
//}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_text forKey:kTEXT];
    [encoder encodeObject:_time forKey:kTIME];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        _text = [decoder decodeObjectForKey:kTEXT];
        _time = [decoder decodeObjectForKey:kTIME];
    }
    return self;
}

@end
