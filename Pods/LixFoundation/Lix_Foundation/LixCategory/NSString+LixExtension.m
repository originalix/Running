//
//  NSString+NEUExtension.m
//  Neuron
//
//  Created by Lix on 16/9/10.
//  Copyright © 2016年 Lix. All rights reserved.
//

#import "NSString+LixExtension.h"

@implementation NSString (LixExtension)

- (CGSize)lix_sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize textSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return textSize;
}

+ (NSString *)timeIntervalToTime:(NSString *)interval {
    NSTimeInterval time=[interval doubleValue];//如果不使用本地时区,因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];//设置本地时区
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

+ (NSString *)timeFormatted:(NSInteger)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = (int)(totalSeconds / 3600);
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

+ (NSString *)rangeHour:(NSString *)time {
    NSString *timeString = time;
    NSRange hourRange = NSMakeRange(0,2);
    NSString* hourStr = [timeString substringWithRange:hourRange];
    NSInteger hour = [hourStr integerValue];
    if (hour <= 0) {
        return @"";
    }else {
        return [NSString stringWithFormat:@"%ld小时", hour];
    }
}

+ (NSString *)rangeMinute:(NSString *)time {
    NSString *timeString = time;
    NSRange minRange = NSMakeRange(3, 2);
    NSString* minStr = [timeString substringWithRange:minRange];
    NSInteger min = [minStr integerValue];
    if (min <= 0) {
        return @"";
    }else {
        return [NSString stringWithFormat:@"%ld分", min];
    }
}

+ (NSString *)rangeSecond:(NSString *)time {
    NSString *timeString = time;
    NSRange secRange = NSMakeRange(6, 2);
    NSString* secStr = [timeString substringWithRange:secRange];
    NSInteger sec = [secStr integerValue];
    if (sec <= 0) {
        return @"";
    }else {
        return [NSString stringWithFormat:@"%ld秒", sec];
    }
}

+ (NSString *)ToPaceWithSpeed:(double)speed {
    double meterSpeed = speed;
    double secondTime = 1000 / meterSpeed;
    NSInteger secondNumber;
    NSInteger minuteNumber;
    if (meterSpeed <= 0 || isnan(meterSpeed)) {
        secondNumber = 00;
        minuteNumber = 00;
    } else {
        secondNumber = (NSInteger)secondTime % 60;
        minuteNumber = (NSInteger)(secondTime / 60);
    }
    NSString *secondText = secondNumber < 10 ? [NSString stringWithFormat:@"0%ld", secondNumber] : [NSString stringWithFormat:@"%ld", secondNumber];
    NSString *minuteText = minuteNumber < 10 ? [NSString stringWithFormat:@"0%ld", minuteNumber] : [NSString stringWithFormat:@"%ld", minuteNumber];
    return [NSString stringWithFormat:@"%@\'%@\"", minuteText, secondText];
}

@end
