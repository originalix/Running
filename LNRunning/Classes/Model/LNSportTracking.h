//
//  LNSportTracking.h
//  LNTS
//
//  Created by Lix on 16/12/15.
//  Copyright © 2016年 济南欧迅体育科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNSportTrackingLine.h"
///运动类型枚举
typedef enum : NSUInteger {
    LNSportTypeRun,
    LNSportTypeWalk,
    LNSportTypeBike,
} LNSportType;

///运动状态枚举
typedef enum : NSUInteger {
    LNSportStateContinue,
    LNSportStatePause,
    LNSportStateFinish,
} LNSportState;

@interface LNSportTracking : NSObject

//使用运动类型和运动状态实例化追踪模型
- (instancetype)initWithType:(LNSportType)type state:(LNSportState)state;

///运动类型
@property (nonatomic, assign, readonly) LNSportType sportType;

//运动状态
@property (nonatomic, assign) LNSportState sportState;

//运动图像
@property (nonatomic, strong, readonly) UIImage *sportImage;

//追加当前位置，返回折线模型
- (LNPolyLine *)appendLocation:(CLLocation *)location;
//画轨迹
- (LNPolyLine *)appendTracking:(CLLocation *)location;

//平均速度
@property (nonatomic, readonly) double avgSpeed;

//最大速度
@property (nonatomic, readonly) double maxSpeed;

//总时长
@property (nonatomic, readonly) double totalTime;

//总距离
@property (nonatomic, readonly) double totalDistance;

@end

