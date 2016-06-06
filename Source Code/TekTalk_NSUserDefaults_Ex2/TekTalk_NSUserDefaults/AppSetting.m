//
//  AppSetting.m
//  TekTalk_NSUserDefaults
//
//  Created by luu on 6/3/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import "AppSetting.h"

NSString *const kUSER_NAME      = @"kUSER_NAME";
NSString *const kSOUND          = @"kSOUND";
NSString *const kLEVEL          = @"kLEVEL";
NSString *const kAUTO_UPDATE    = @"kAUTO_UPDATE";

NSString *const kSettingChangedNotifycation = @"kSettingChangedNotifycation";

@implementation AppSetting

+ (instancetype)shareInstance
{
    static AppSetting *_shareSetting;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareSetting = [[AppSetting alloc] init];
        
        // load from NSUserDefaults
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        _shareSetting.userName = [userDefault stringForKey:kUSER_NAME];
        _shareSetting.sound = [userDefault floatForKey:kSOUND];
        _shareSetting.level = [userDefault integerForKey:kLEVEL];
        _shareSetting.autoUpdate = [userDefault boolForKey:kAUTO_UPDATE];
    });
    
    return _shareSetting;
}

- (void)save
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:_userName forKey:kUSER_NAME];
    [userDefault setFloat:_sound forKey:kSOUND];
    [userDefault setInteger:_level forKey:kLEVEL];
    [userDefault setBool:_autoUpdate forKey:kAUTO_UPDATE];
    [userDefault synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSettingChangedNotifycation object:self];
}

@end
