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

- (NSInteger)getDuration {
    NSInteger endTime = [self dateStringToTimestamp:self.endTime];
    NSInteger startTime = [self dateStringToTimestamp:self.startTime];
    NSInteger duration = endTime - startTime;
    return duration > 0 ? duration : 0;
}

- (NSInteger)dateStringToTimestamp:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:dateString];
    return [date timeIntervalSince1970];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"开始时间: %@, 结束时间: %@, 耗时: %ld, 距离: %ld, 步数: %ld, 总点数: %ld", self.startTime, self.endTime, self.duration, self.distance, self.steps, self.all_points];
}

@end
