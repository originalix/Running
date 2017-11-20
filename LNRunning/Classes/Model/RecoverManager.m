//
//  RecoverManager.m
//  LNRunning
//
//  Created by Lix on 2017/11/20.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import "RecoverManager.h"
#import "WHC_ModelSqlite.h"
#import "LNRunModel.h"

@implementation RecoverManager

- (void)checkNeedRecoverRun {
    NSArray *array = [WHC_ModelSqlite query:[LNRunModel class] where:@"LENGTH(endTime) < 1" order:@"by _id desc" limit:@"1"];
    if ([array count] == 0) {
        return;
    }
    
    LNRunModel *runModel = array.firstObject;
    NSLog(@"%@", runModel);
    
}

@end
