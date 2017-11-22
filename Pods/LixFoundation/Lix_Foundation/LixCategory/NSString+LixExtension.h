//
//  NSString+NEUExtension.h
//  Neuron
//
//  Created by Lix on 16/9/10.
//  Copyright © 2016年 Lix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LixExtension)

/**
 *  计算字符串长度
 *
 *  @param font    字体大小
 *
 *  @return 字符串长度
 */
- (CGSize)lix_sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 时间戳转换时间格式

 @param interval 时间戳
 @return time Formatted
 */
+ (NSString *)timeIntervalToTime:(NSString *)interval;

/**
 秒数转标准时间格式

 @param totalSeconds 秒数
 @return time Formatted
 */
+ (NSString *)timeFormatted:(NSInteger)totalSeconds;

/**
 截取时分秒中的秒数

 @param time 标准时间格式
 @return 秒数
 */
+ (NSString *)rangeHour:(NSString *)time;

/**
 截取时分秒中的分钟
 
 @param time 标准时间格式
 @return 分钟
 */
+ (NSString *)rangeMinute:(NSString *)time;

/**
 截取时分秒中的小时
 
 @param time 标准时间格式
 @return 小时
 */
+ (NSString *)rangeSecond:(NSString *)time;


/**
 速度换算成运动配速

 @param speed 速度 单位 米/秒
 @return 配速
 */
+ (NSString *)ToPaceWithSpeed:(double)speed;


@end
