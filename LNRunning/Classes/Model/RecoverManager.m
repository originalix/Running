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

#define halfHourTimestamp  1800

@implementation RecoverManager

- (void)checkNeedRecoverRun {
    NSArray *array = [WHC_ModelSqlite query:[LNRunModel class] where:@"LENGTH(endTime) < 1" order:@"by _id desc" limit:@"1"];
    if ([array count] == 0) {
        return;
    }
    
    LNRunModel *runModel = array.firstObject;
    NSLog(@"%@", runModel);
    NSInteger startTimestamp = [runModel dateStringToTimestamp:runModel.startTime];
    NSInteger nowTimestamp = [[NSDate date] timeIntervalSince1970];
    if ((nowTimestamp - startTimestamp) <= halfHourTimestamp) {
        NSLog(@"您有需要恢复的跑步");
        
        // 给LNRunManager赋值 并恢复Controller
        
    } else {
        NSLog(@"未结束的跑步已经超时");
    }
}

@end
