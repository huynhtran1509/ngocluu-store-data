//
//  AppSetting.h
//  TekTalk_NSUserDefaults
//
//  Created by luu on 6/3/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kSettingChangedNotifycation;

@interface AppSetting : NSObject

+ (instancetype)shareInstance;
@property (nonatomic) NSString *userName;
@property (nonatomic) float sound;
@property (nonatomic) NSInteger level;
@property (nonatomic) BOOL autoUpdate;

- (void)save;

@end
