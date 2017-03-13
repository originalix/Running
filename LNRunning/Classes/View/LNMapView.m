//
//  LNMapView.m
//  LNRunning
//
//  Created by Lix on 17/2/9.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import "LNMapView.h"
#import "LNRunning.h"

@interface LNMapView()

@end

@implementation LNMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configMapView];
    }
    return self;
}

#pragma mark - config MapView
- (void)configMapView {
    self.mapView.showsUserLocation = true;
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow  animated:true];
    self.mapView.pausesLocationUpdatesAutomatically = false;
    self.mapView.allowsBackgroundLocationUpdates = true;
    //比例尺
    self.mapView.showsScale = false;
    self.mapView.compassOrigin = CGPointMake(self.mapView.compassOrigin.x, 22);
    //手势
    self.mapView.zoomEnabled = true;
    self.mapView.scrollEnabled = true;
    self.mapView.rotateEnabled = true;
    self.mapView.rotateCameraEnabled = false;
    //缩放级别
    [self.mapView setZoomLevel:17 animated:true];
    self.mapView.distanceFilter = 0;
    self.mapView.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self addSubview:self.mapView];
}

#pragma mark - lazy Var
- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:Rect(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height)];
    }
    return _mapView;
}

@end
