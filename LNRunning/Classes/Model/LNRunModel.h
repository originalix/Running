//
//  LNRunModel.h
//  LNRunning
//
//  Created by Lix on 2017/11/16.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNRunModel : NSObject

@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) NSInteger steps;
@property (nonatomic, assign) NSInteger all_points;

/**
 获取当前时间的String类型
 时间格式： yyyy-MM-dd HH:mm:ss

 @return String
 */
+ (NSString *)dateToString;

/**
 将传入的时间格式返回为时间戳格式
 时间格式： yyyy-MM-dd HH:mm:ss
 @param dateString 时间字符串
 @return 时间戳
 */
- (NSInteger)dateStringToTimestamp:(NSString *)dateString;

- (NSInteger)getDuration;

@end
