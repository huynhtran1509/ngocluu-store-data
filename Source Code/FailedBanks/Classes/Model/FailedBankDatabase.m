//
//  FailedBankDatabase.m
//  FailedBanks
//
//  Created by Ray Wenderlich on 4/5/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "FailedBankDatabase.h"
#import "FailedBankInfo.h"
#import "FailedBankDetails.h"
#import "FMDB.h"

@implementation FailedBankDatabase

static FailedBankDatabase *_database;

+ (FailedBankDatabase*)database {
    if (_database == nil) {
        _database = [[FailedBankDatabase alloc] init];
    }
    return _database;
}

- (id)init {
    if ((self = [super init])) {
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"banklist" ofType:@"sqlite3"];
        _database = [[FMDatabase alloc] initWithPath:sqLiteDb];
        if (![_database open]) {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}

- (void)dealloc {
    [_database close];
}

- (NSArray *)failedBankInfos {
    
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    
    FMResultSet *s = [_database executeQuery:@"SELECT id, name, city, state FROM failed_banks ORDER BY close_date DESC"];
    while ([s next]) {
        int uniqueId = [s intForColumnIndex:0];
        NSString *name = [s stringForColumnIndex:1];
        NSString *city = [s stringForColumnIndex:2];
        NSString *state = [s stringForColumnIndex:3];
        FailedBankInfo *info = [[FailedBankInfo alloc] initWithUniqueId:uniqueId name:name city:city state:state];
        [retval addObject:info];
    }
    return retval;
}

- (FailedBankDetails *)failedBankDetails:(int)uniqueId {
    FailedBankDetails *retval = nil;
    NSString *query = [NSString stringWithFormat:@"SELECT id, name, city, state, zip, close_date, updated_date FROM failed_banks WHERE id=%d", uniqueId];
    FMResultSet *s = [_database executeQuery:query];
    while ([s next]) {
        int uniqueId = [s intForColumnIndex:0];
        NSString *name = [s stringForColumnIndex:1];
        NSString *city = [s stringForColumnIndex:2];
        NSString *state = [s stringForColumnIndex:3];
        int zip = [s intForColumnIndex:4];
        NSString *closeDateString = [s stringForColumnIndex:5];
        NSString *updatedDateString = [s stringForColumnIndex:6];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSDate *closeDate = [formatter dateFromString:closeDateString];
        NSDate *updateDate = [formatter dateFromString:updatedDateString];
        
        retval = [[FailedBankDetails alloc] initWithUniqueId:uniqueId name:name city:city state:state zip:zip closeDate:closeDate updatedDate:updateDate];
        
        break;
    }
    return retval;
}

@end