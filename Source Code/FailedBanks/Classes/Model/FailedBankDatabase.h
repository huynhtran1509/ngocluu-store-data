//
//  FailedBankDatabase.h
//  FailedBanks
//
//  Created by Ray Wenderlich on 4/5/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FailedBankDetails;
@class FMDatabase;

@interface FailedBankDatabase : NSObject {
    FMDatabase *_database;
}

+ (FailedBankDatabase*)database;
- (NSArray *)failedBankInfos;
- (FailedBankDetails *)failedBankDetails:(int)uniqueId;

@end
