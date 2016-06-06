//
//  NSUserDefaults+Setting.m
//  TekTalk_NSUserDefaults
//
//  Created by luu on 6/3/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import "NSUserDefaults+Setting.h"

NSString *const kUSER_NAME      = @"kUSER_NAME";
NSString *const kSOUND          = @"kSOUND";
NSString *const kLEVEL          = @"kLEVEL";
NSString *const kAUTO_UPDATE    = @"kAUTO_UPDATE";

NSString *const kSettingChangedNotifycation = @"kSettingChangedNotifycation";

@implementation NSUserDefaults (Setting)

#pragma mark - user name
- (void)setUserName:(NSString *)userName
{
    [self setValue:userName forKey:kUSER_NAME];
}

- (NSString *)userName
{
    return [self stringForKey:kUSER_NAME];
}

#pragma mark - sound
- (void)setSound:(float)sound
{
    [self setFloat:sound forKey:kSOUND];
}

- (float)sound
{
    return [self floatForKey:kSOUND];
}

#pragma mark - level
- (NSInteger)level
{
    return [self integerForKey:kLEVEL];
}

- (void)setLevel:(NSInteger)level
{
    [self setInteger:level forKey:kLEVEL];
}

#pragma mark - auto update
- (BOOL)autoUpdate
{
    return [self boolForKey:kAUTO_UPDATE];
}

- (void)setAutoUpdate:(BOOL)autoUpdate
{
    [self setBool:autoUpdate forKey:kAUTO_UPDATE];
}

#pragma mark - save setting
- (void)save
{
    [self synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSettingChangedNotifycation object:self];
}

@end
