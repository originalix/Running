//
//  LNRunBaseViewController.h
//  LNRunning
//
//  Created by Lix on 17/2/9.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNRunViewControllerProtocol.h"
#import "LNRunManager.h"
#import "LNMapView.h"
#import "LNRunning-Swift.h"
#import "LNRunning.h"

@interface LNRunBaseViewController : UIViewController <LNRunViewControllerProtocol, StepCountingDelegate, MAMapViewDelegate>

/**
 地图
 */
@property (nonatomic, strong) LNMapView *lnMapView;
//运动轨迹追踪模型
@property(nonatomic,strong) LNSportTracking *sportTracking;

/**
 数据Model
 */
@property (nonatomic, strong) LNRunningTimer *timer;
@property (nonatomic, strong) LNStepCounter *stepCounter;
@property (nonatomic, strong) LNRunManager *runManager;

/**
 时间Label
 */
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UIButton *endButton;

/**
 Public Data
 */
@property (nonatomic, assign) NSInteger step;
@property (nonatomic, assign) double distance;
@property (nonatomic, assign) double speed;
@property (nonatomic, copy) NSString *speedString;
@property (nonatomic, copy) NSString *pace;
@property (nonatomic, assign) NSInteger timeNumber;
@property (nonatomic, assign) NSInteger stepStride;
@property (nonatomic, assign) NSInteger stepFrequency;
@property (nonatomic, strong) CLLocation *startLocation;
@property (nonatomic, strong) CLLocation *lastLocation;
@property (nonatomic, assign) NSInteger lastUpdate;

@end
