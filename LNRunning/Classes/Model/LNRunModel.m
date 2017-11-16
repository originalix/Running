//
//  LNRunModel.m
//  LNRunning
//
//  Created by Lix on 2017/11/16.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import "LNRunModel.h"
#import "WHC_ModelSqlite.h"

@interface LNRunModel() <WHC_SqliteInfo>

@end

@implementation LNRunModel

+ (NSString *)whc_SqliteMainkey {
    return @"_id";
}

+ (NSString *)dateToString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:[NSDate date]];
}

@end
