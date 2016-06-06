//
//  UIViewController+LoadXibFile.m
//  TruyenTranh
//
//  Created by LuuNN on 12/29/13.
//  Copyright (c) 2013 LuuNN. All rights reserved.
//

#import "TTBaseViewController.h"

@implementation TTBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (![TTGlobal isIphone]) {
        nibNameOrNil = [nibNameOrNil stringByAppendingString:@"_ipad"];
    }
    
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

@end
