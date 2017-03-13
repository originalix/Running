//
//  LNRunBaseViewController.m
//  LNRunning
//
//  Created by Lix on 17/2/9.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import "LNRunBaseViewController.h"
#import "LNMapView.h"

@interface LNRunBaseViewController ()

@end

@implementation LNRunBaseViewController

#pragma mark - initialize
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    LNRunBaseViewController *viewController = [super allocWithZone:zone];
    
    @weakify(viewController)
    
    [[viewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        
        @strongify(viewController)
        [viewController ln_layoutNavigation];
    }];
    
    [[viewController rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        
        @strongify(viewController)
        [viewController ln_addSubviews];
    }];
    
    [[viewController rac_signalForSelector:@selector(viewWillDisappear:)] subscribeNext:^(id x) {
        
        @strongify(viewController)
        [viewController ln_dealloc];
    }];
    
    return viewController;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.timer timingStart];
    [self.stepCounter startStepCounting];
    [self.runManager initializeRunning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    // 当前状态为未开始跑步，不记录
    if (self.sportTracking.sportState != LNSportStateContinue) {
        return;
    }
    if (!updatingLocation) {
        return;
    }
//    NSLog(@"location = %@", userLocation.location);
    if (!self.startLocation) {
        self.startLocation = userLocation.location;
        self.runManager.startLocation = self.startLocation;
        self.lastUpdate = [[NSDate date] timeIntervalSince1970];
        MAPointAnnotation *annotaion = [MAPointAnnotation new];
        annotaion.coordinate = userLocation.location.coordinate;
        [mapView addAnnotation:annotaion];
        [mapView setCenterCoordinate:userLocation.location.coordinate animated:true];
    }
    if ([[NSDate date] timeIntervalSince1970] - self.lastUpdate < kPointSpace) {
        return;
    }
    
    @weakify(self)
    [self.runManager runningDataWithStartLocation:userLocation.location
                                            Time:self.timer.timeNumber
                                         RunData:^(double distance, NSString *speedString, NSString *pace) {
                                             
                                             @strongify(self)
                                             DLog(@"distance = %f \n speedString = %@ \n pace = %@", distance, speedString, pace);
                                             self.distance = distance;
                                             self.speedString = speedString;
                                             self.pace = pace;
                                             [self ln_bindRunData];
                                             if (userLocation.location.horizontalAccuracy <= kMaxAccuracy) {
                                                 [self.lnMapView.mapView addOverlay:[self.sportTracking appendLocation:userLocation.location]];
                                                 [self.lnMapView.mapView setCenterCoordinate:userLocation.location.coordinate animated:true];
                                             }
                                         }];
    self.lastLocation = userLocation.location;
    self.lastUpdate = [[NSDate date] timeIntervalSince1970];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    static NSString *annotaionId = @"annotaionId";
    MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotaionId];
    if (annotationView == nil) {
        annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotaionId];
    }
    UIImage *image = [UIImage imageNamed:@"map_annotation_run"];
    annotationView.image = image;
    annotationView.centerOffset = CGPointMake(0, -image.size.height * 0.5);
    mapView.showsUserLocation = YES;
    return annotationView;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if (![overlay isKindOfClass:[MAPolyline class]]) {
        return nil;
    }
    LNPolyLine *polyline = (LNPolyLine *)overlay;
    MAPolylineRenderer *renderer = [[MAPolylineRenderer alloc] initWithPolyline:polyline];
    renderer.lineWidth = 5;
    renderer.strokeColor = polyline.color;
    return renderer;
}

#pragma mark - Step Count Delegate
- (void)didUpdateSteps:(NSInteger)numberOfSteps {
    
    @weakify(self)
    [self.runManager calculateStep:numberOfSteps LNStepData:^(NSInteger step, NSInteger stride, NSInteger frequency) {
        
        @strongify(self)
            DLog(@"步数 = %ld,\n 步频 = %ld,\n 步幅 = %ld,\n", step, frequency, stride);
        self.step = step;
        self.stepFrequency = frequency;
        self.stepStride = stride;
        [self ln_bindStepData];
    }];
}

#pragma mark - setup Views
- (void)ln_addSubviews {
    [self ln_setupViews];
    [self.view addSubview:self.lnMapView];
    [self.view addSubview:self.timerLabel];
    [self.view addSubview:self.pauseButton];
    [self.view addSubview:self.continueButton];
    [self.view addSubview:self.endButton];
    [self changeButtonHidden:NO];
}

- (void)ln_setupViews {
    self.lnMapView.mapView.delegate = self;
    self.stepCounter.delegate = self;
    [self.endButton addTarget:self action:@selector(endButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.pauseButton addTarget:self action:@selector(pauseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.continueButton addTarget:self action:@selector(continueButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)ln_layoutNavigation {
}

- (void)ln_dealloc {
    [self.pauseButton removeFromSuperview];
    [self.continueButton removeFromSuperview];
    [self.endButton removeFromSuperview];
    self.pauseButton = nil;
    self.continueButton = nil;
    self.endButton = nil;
    [self.lnMapView removeFromSuperview];
    self.lnMapView.mapView.delegate = nil;
    self.lnMapView.mapView = nil;
    self.lnMapView = nil;
    self.stepCounter.delegate = nil;
    self.runManager = nil;
    self.timer = nil;
    self.stepCounter = nil;
}

#pragma mark - button Action
- (void)pauseButtonAction:(UIButton *)sender {
    [self changeButtonHidden:YES];
    self.sportTracking.sportState = LNSportStatePause;
    [self.runManager updateRunningInfo];
    [self.timer timingPause];
    [self.stepCounter pause];
}

- (void)continueButtonAction:(UIButton *)sender {
    [self changeButtonHidden:NO];
    self.sportTracking.sportState = LNSportStateContinue;
    [self.timer timingContinue];
    [self.stepCounter continueCounting];
}

- (void)endButtonAction:(UIButton *)sender {
//    if (self.distance < 0.1) {
//        [LixAlertUtil presentAlertViewWithTitle:@"提示" message:@"此次距离太短，不会保存数据，您是否要结束跑步" cancelTitle:@"继续" defaultTitle:@"退出" distinct:YES cancel:^{
//            BLYLogInfo(@"取消结束跑步");
//        } confirm:^{
//            [self cancelRunning];
//        }];
//    } else {
//        [LixAlertUtil presentAlertViewWithTitle:@"提示" message:@"您是否要结束跑步" cancelTitle:@"取消" defaultTitle:@"结束跑步" distinct:YES cancel:^{
//        } confirm:^{
//            [self finishRunning];
//        }];
//    }
    self.sportTracking.sportState = LNSportStateFinish;

    [LixAlertUtil presentAlertViewWithTitle:@"提示" message:@"您是否要结束跑步" cancelTitle:@"取消" defaultTitle:@"结束跑步" distinct:YES cancel:^{
    } confirm:^{
        [self finishRunning];
    }];
}

#pragma mark - 结束跑步
- (void)cancelRunning {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.runManager cancelRunning];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.timer resetToStart];
        [self.stepCounter resetToStart];
        [self.navigationController popViewControllerAnimated:true];
        BLYLogInfo(@"------>2 重置Model");
    });
}

- (void)finishRunning {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.runManager finishRunning];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.timer resetToStart];
        [self.stepCounter resetToStart];
        [self.navigationController popViewControllerAnimated:true];
        BLYLogInfo(@"------>2 重置Model");

    });
}

#pragma mark - privite
- (void)ln_priviteMethod {
}

- (void)ln_bindRunData{
}

- (void)ln_bindStepData {
}

- (void)changeButtonHidden:(BOOL)hidden {
    [self.pauseButton setHidden:hidden];
    [self.endButton setHidden:!hidden];
    [self.continueButton setHidden:!hidden];
}

#pragma mark - lazy Var
- (LNMapView *)lnMapView {
    if (!_lnMapView) {
        _lnMapView = [[LNMapView alloc] initWithFrame:CGRectZero];
    }
    return _lnMapView;
}

- (LNSportTracking *)sportTracking {
    if (!_sportTracking) {
        _sportTracking = [[LNSportTracking alloc] initWithType:LNSportTypeRun state:LNSportStateContinue];
    }
    return _sportTracking;
}

- (LNRunManager *)runManager {
    if (!_runManager) {
        _runManager = [LNRunManager shareInstance];
    }
    return _runManager;
}


- (LNRunningTimer *)timer {
    if (!_timer) {
        _timer = [[LNRunningTimer alloc] initWithTimeLabel:self.timerLabel];
    }
    return _timer;
}

- (LNStepCounter *)stepCounter {
    if (!_stepCounter) {
        _stepCounter = [[LNStepCounter alloc] init];
    }
    return _stepCounter;
}

- (UILabel *)timerLabel {
    if (!_timerLabel) {
        _timerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _timerLabel;
}

- (UIButton *)pauseButton {
    if (!_pauseButton) {
        _pauseButton = [[UIButton alloc] initWithFrame:Rect(SCREEN_WIDTH - 100, SCREEN_HEIGHT - 150, 80, 50)];
        [_pauseButton setTitle:@"暂停" forState:UIControlStateNormal];
    }
    return _pauseButton;
}

- (UIButton *)continueButton {
    if (!_continueButton) {
        _continueButton = [[UIButton alloc] initWithFrame:Rect(SCREEN_WIDTH - 100, SCREEN_HEIGHT - 60, 80, 50)];
        [_continueButton setTitle:@"继续" forState:UIControlStateNormal];
    }
    return _continueButton;
}

- (UIButton *)endButton {
    if (!_endButton) {
        _endButton = [[UIButton alloc] initWithFrame:Rect(SCREEN_WIDTH - 100, SCREEN_HEIGHT - 100, 80, 50)];
        [_endButton setTitle:@"结束" forState:UIControlStateNormal];
    }
    return  _endButton;
}

@end
