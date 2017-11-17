//
//  RunManager.m
//  LNRunning
//
//  Created by Lix on 2017/11/16.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import "RunManager.h"
#import "LNRunning.h"
#include "LNRunPointModel.h"
//#import "LNSportsDetailModel.h"
#import "DBManager.h"

@interface RunManager()

@property (nonatomic, assign) NSInteger runID;

@end

@implementation RunManager

#pragma mark - 单例管理
static RunManager *_lnRunManager = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _lnRunManager = [super allocWithZone:zone];
    });
    return _lnRunManager;
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _lnRunManager = [[self alloc] init];
    });
    return _lnRunManager;
}

- (id)copyWithZone:(NSZone *)zone {
    return _lnRunManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - 运动数据处理
- (void)runningDataWithStartLocation:(CLLocation *)userLocation Time:(NSInteger)time RunData:(LNRunData)runData {
    if (!self.startLocation || !self.lastLocation) {
        self.lastLocation = userLocation;
        return;
    }
    self.time = time;
    self.pointDuration = [userLocation.timestamp timeIntervalSinceDate:self.lastLocation.timestamp];
    self.pointDistance = [userLocation distanceFromLocation:self.lastLocation];
    self.pointStep = self.step - self.lastStep;
    self.lastStep = self.step;
    if (userLocation.horizontalAccuracy >= kMaxAccuracy || self.lastLocation.horizontalAccuracy >= kMaxAccuracy) {
        self.pointDistance = self.pointStep * kStepDistance;
    }
    [self runningDistance:self.pointDistance];
    [self runningPace:self.time];
    self.invalid = [self checkRunningStatus:self.step Distance:self.distance];
    self.pointIndex++;
    self.lastLocation = userLocation;
    if (runData) {
        runData(self.distance, self.speedString, self.pace);
    }
    [self savePointData:userLocation];
    DLog(@"时间 = %ld,\n 点耗时 = %ld,\n 点距离 = %ld,\n 点步数 = %ld,\n lastStep = %ld,\n 距离 = %f,\n 配速 = %@, \n 速度 = %@,\n 点数 = %ld,\n 错误点数 = %ld,\n", self.time, self.pointDuration, self.pointDistance, self.pointStep, self.lastStep, self.distance, self.pace, self.speedString,self.pointIndex, self.invalidPointIndex);
}

//运动距离
- (void)runningDistance:(CLLocationDistance)distance {
    self.distance += (distance / 1000);
    if (self.distance < 0) {
        self.distance = 0.00;
    }
}

//运动配速
- (void)runningPace:(NSInteger)time {
    double meterSpeed = self.distance * 1000 / time;
    self.pace = [NSString ToPaceWithSpeed:meterSpeed];
    if (isnan(meterSpeed) || meterSpeed < 0) {
        self.speed = 0;
    } else {
        self.speed = 3.6 * meterSpeed;
    }
    self.speedString = self.speed < 10 ? [NSString stringWithFormat:@"0%.2f", self.speed] : [NSString stringWithFormat:@"%.2f", self.speed];
}

//校验运动合理性
- (BOOL)checkRunningStatus:(NSInteger)step Distance:(double)distance {
    double path = distance * 1000;
    if (path > 200) {
        if ((double)step * 10 < path) {
            self.invalidPointIndex++;
            return false;
        }
    }
    return true;
}
//步数 步幅 步频计算
- (void)calculateStep:(NSInteger)step LNStepData:(LNStepData)stepData {
    self.step = step;
    double centimeter = self.distance * 100000;
    self.stride = (NSInteger)(centimeter / (double)self.step);
    double minute = (double)self.time / 60.0;
    if (minute < 1) {
        minute = 1;
    }
    self.frequency = (NSInteger)((double)step / minute);
    if (self.step <= 0) {
        self.stride = 0;
        self.frequency = 0;
    }
    if (stepData) {
        stepData(self.step, self.stride, self.frequency);
    }
    DLog(@"步数 = %ld,\n 步频 = %ld,\n 步幅 = %ld,\n", self.step, self.frequency, self.stride);
}

#pragma mark - 跑步初始化
- (void)initializeRunning {
#warning +++++++
//    self.infoModel.id = [[LNDBManager shareInstance] getTableItemCount:[LNDBManager SPORT_INFO_TABLE]];
//    self.infoModel.startTime = (NSInteger)[[NSDate date] timeIntervalSince1970];
//    self.infoModel.targetType = 0;
//    self.infoModel.target = 0;
//    [[LNDBManager shareInstance] insertInfoModel:self.infoModel];
//    [[DBManager shareInstance] insertInfoModel:self.infoModel];
    self.infoModel.startTime = [LNRunModel dateToString];
    [[DBManager shareInstance] insertInfoModel:self.infoModel];
    self.runID = [[DBManager shareInstance] queryRunIDBy:self.infoModel.startTime];
    NSLog(@"%ld", self.runID);
}

#pragma mark - 更新跑步信息
- (void)updateRunningInfo {
#warning +++++++++
//    self.infoModel.endTime = [self.lastLocation.timestamp timeIntervalSince1970];
//    self.infoModel.inputTime = 0;
//    self.infoModel.duration = self.infoModel.endTime - self.infoModel.startTime;
//    self.infoModel.distance = self.distance * 1000;
//    self.infoModel.steps = self.step;
//    self.infoModel.points = self.pointIndex;
//    self.infoModel.invalidPoints = self.invalidPointIndex;
//    [[LNDBManager shareInstance] updateInfoModel:self.infoModel];
    
    self.infoModel.endTime = [LNRunModel dateToString];
    self.infoModel.duration = [self.infoModel getDuration];
    self.infoModel.distance = self.distance * 1000;
    self.infoModel.steps = self.step;
    self.infoModel.all_points = self.pointIndex;
    [[DBManager shareInstance] updateInfoModel:self.infoModel];
}

#pragma mark - 存储运动数据
- (void)savePointData:(CLLocation *)location {
#warning ++++++++++++=
    while (self.runID == 0) {
        self.runID = [[DBManager shareInstance] queryRunIDBy:self.infoModel.startTime];
    }
    
    LNRunPointModel *model = [[LNRunPointModel alloc] init];
    model.runId = self.runID;
    model.time = [LNRunPointModel timestampToString:[[NSDate date] timeIntervalSince1970] - self.pointDuration];
    model.latitude = location.coordinate.latitude;
    model.longitude = location.coordinate.longitude;
    model.accuration = (NSInteger)location.horizontalAccuracy;
    model.distance = self.pointDistance;
    model.duration = self.pointDuration;
    model.steps = self.pointStep;
    [[DBManager shareInstance] insertDetailModel:model];
    
    
//    LNSportsDetailModel *model = [[LNSportsDetailModel alloc] init];
//    model.runID = self.runID;
//    model.uid = self.infoModel.uid;
//    model.startTime = [[NSDate date] timeIntervalSince1970] - self.pointDuration;
//    model.latitude = location.coordinate.latitude;
//    model.longitude = location.coordinate.longitude;
//    model.altitude = location.altitude;
//    model.accuration = (NSInteger)location.horizontalAccuracy;
//    model.distance = self.pointDistance;
//    model.duration = self.pointDuration;
//    model.steps = self.pointStep;
//    model.type = @"0";
//    model.done = 0;
//    model.isValid = self.invalid ? 1 : 0;
//    [[LNDBManager shareInstance] insertDetailModel:model];
}

#pragma mark - 结束跑步
- (void)cancelRunning {
#warning +++++++++++
    [[DBManager shareInstance] updateInfoModel:self.infoModel];
    [[DBManager shareInstance] deleteInfoData:self.infoModel];
//    [[LNDBManager shareInstance] updateInfoModel:self.infoModel];
//    [[LNDBManager shareInstance] deleteInfoData:[LNDBManager SPORT_INFO_TABLE]  id:[NSString stringWithFormat:@"%ld", self.infoModel.id]];
    BLYLogInfo(@"------>1 删除数据");
}

- (void)finishRunning {
#warning +++++++++++++++
    self.infoModel.endTime = [LNRunModel dateToString];
    self.infoModel.duration = [self.infoModel getDuration];
    self.infoModel.distance = self.distance * 1000;
    self.infoModel.steps = self.step;
    self.infoModel.all_points = self.pointIndex;
    [[DBManager shareInstance] updateInfoModel:self.infoModel];
//    self.infoModel.endTime = (NSInteger)[[NSDate date] timeIntervalSince1970];
//    self.infoModel.inputTime = 0;
//    self.infoModel.duration = self.infoModel.endTime - self.infoModel.startTime;
//    self.infoModel.distance = self.distance * 1000;
//    BLYLogDebug(@"%@", [NSString stringWithFormat:@"finial Distance = %f", self.distance]);
//    BLYLogDebug(@"%@", [NSString stringWithFormat:@"infoModel.distance = %ld",self.infoModel.distance]);
//    self.infoModel.steps = self.step;
//    self.infoModel.points = self.pointIndex;
//    self.infoModel.invalidPoints = self.invalidPointIndex;
//    [[LNDBManager shareInstance] updateInfoModel:self.infoModel];
    //上传跑步信息
    BLYLogDebug(@"----->1 保存上传跑步信息");
}

#pragma mark - lazy var
//- (LNSportsInfoModel *)infoModel {
//    if (!_infoModel) {
//        _infoModel = [[LNSportsInfoModel alloc] init];
//    }
//    return _infoModel;
//}

- (LNRunModel *)infoModel {
    if (!_infoModel) {
        _infoModel = [[LNRunModel alloc] init];
    }
    
    return _infoModel;
}

@end
