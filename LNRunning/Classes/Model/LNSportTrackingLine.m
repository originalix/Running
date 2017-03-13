//
//  LNSportTrackingLine.m
//  LNTS
//
//  Created by Lix on 16/12/15.
//  Copyright © 2016年 济南欧迅体育科技发展有限公司. All rights reserved.
//

#import "LNSportTrackingLine.h"

@implementation LNSportTrackingLine

#pragma mark - initialize
- (instancetype)initWithStartLocation:(CLLocation *)startLocation endLocation:(CLLocation *)endLocation {
    self = [super init];
    if (self) {
        _startLocation = startLocation;
        _endLocation = endLocation;
    }
    return self;
}

#pragma mark - lazy var
- (LNPolyLine *)polyline {
    
    CLLocationCoordinate2D coords[2];
    coords[0] = _startLocation.coordinate;
    coords[1] = _endLocation.coordinate;
    CGFloat factor = 8;
    CGFloat red = factor * self.speed / 255.0;
    UIColor *color = [UIColor colorWithRed:red green:1 blue:0 alpha:1];
    return [LNPolyLine polylineWithCoordinates:coords count:2 color:color];
}

- (double)speed {
    return (_startLocation.speed + _endLocation.speed) * 0.5 * 3.6;
}

- (NSTimeInterval)time {
    return [_endLocation.timestamp timeIntervalSinceDate:_startLocation.timestamp];
}

- (double)distance {
    return [_endLocation distanceFromLocation:_startLocation] * 0.001;
}

@end
