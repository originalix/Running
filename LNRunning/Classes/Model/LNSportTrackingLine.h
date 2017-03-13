//
//  LNSportTrackingLine.h
//  LNTS
//
//  Created by Lix on 16/12/15.
//  Copyright © 2016年 济南欧迅体育科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import "LNPolyLine.h"

@interface LNSportTrackingLine : NSObject

///通过起点终点实例化追踪模型
- (instancetype)initWithStartLocation:(CLLocation *)startLocation endLocation:(CLLocation *)endLocation;

//起点
@property (nonatomic, strong, readonly) CLLocation *startLocation;

//停止点
@property (nonatomic, strong, readonly) CLLocation *endLocation;

//划线模型
@property (nonatomic, readonly) LNPolyLine *polyline;

/**
 起始点和结束点之间的平均速度，单位是 `公里/小时`
 */
@property (nonatomic, readonly) double speed;

//时间
@property (nonatomic, readonly) NSTimeInterval time;

//距离
@property (nonatomic, readonly) double distance;

@end
