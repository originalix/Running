//
//  LNSportTracking.m
//  LNTS
//
//  Created by Lix on 16/12/15.
//  Copyright © 2016年 济南欧迅体育科技发展有限公司. All rights reserved.
//

#import "LNSportTracking.h"

@implementation LNSportTracking {
    CLLocation *_startLocation;
    NSMutableArray <LNSportTrackingLine *>*_trackingLines;
}

#pragma mark - initialize
- (instancetype)initWithType:(LNSportType)type state:(LNSportState)state {
    self = [super init];
    if (self) {
        _sportType = type;
        _sportState = state;
        _trackingLines = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 设置数据
- (void)setSportState:(LNSportState)sportState {
    _sportState = sportState;
    if (_sportState != LNSportStateContinue) {
        _startLocation = nil;
    }
}

#pragma mark - 计算型属性&公共方法
- (UIImage *)sportImage {
    
    UIImage *image;
    switch (_sportType) {
        case LNSportTypeRun:
            image = [UIImage imageNamed:@"map_annotation_run"];
            break;
        case LNSportTypeWalk:
            image = [UIImage imageNamed:@"map_annotation_walk"];
            break;
        case LNSportTypeBike:
            image = [UIImage imageNamed:@"map_annotation_bike"];
            break;
    }
    
    return image;
}

- (LNPolyLine *)appendLocation:(CLLocation *)location {
//    if (location.speed <= 0) {
//        return nil;
//    }
    if (_startLocation == nil) {
        _startLocation = location;
        return nil;
    }

    LNSportTrackingLine *trackingLine = [[LNSportTrackingLine alloc] initWithStartLocation:_startLocation endLocation:location];
    [_trackingLines addObject:trackingLine];
    _startLocation = location;
    return trackingLine.polyline;
}

- (LNPolyLine *)appendTracking:(CLLocation *)location {
    if (_startLocation == nil) {
        _startLocation = location;
        return nil;
    }
    LNSportTrackingLine *trackingLine = [[LNSportTrackingLine alloc] initWithStartLocation:_startLocation endLocation:location];
    [_trackingLines addObject:trackingLine];
    _startLocation = location;
    return trackingLine.polyline;
}

- (double)avgSpeed {
    return [[_trackingLines valueForKeyPath:@"@avg.speed"] doubleValue];
}

- (double)maxSpeed {
    return [[_trackingLines valueForKeyPath:@"@max.speed"] doubleValue];
}

- (double)totalTime {
    return [[_trackingLines valueForKeyPath:@"@sum.time"] doubleValue];
}

- (double)totalDistance {
    return [[_trackingLines valueForKeyPath:@"@sum.distance"] doubleValue];
}
@end
