//
//  LNRunManager.h
//  LNRunning
//
//  Created by Lix on 17/2/9.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNSportsInfoModel.h"

@class CLLocation;

typedef void(^LNRunData)(double distance, NSString *speedString, NSString *pace);
typedef void(^LNStepData)(NSInteger step, NSInteger stride, NSInteger frequency);

@interface LNRunManager : NSObject

@property (nonatomic, assign) NSInteger pointIndex;
@property (nonatomic, assign) NSInteger pointDistance;
@property (nonatomic, assign) NSInteger pointStep;
@property (nonatomic, assign) double pointSpeed;
@property (nonatomic, assign) NSInteger pointDuration;
@property (nonatomic, assign) NSInteger pointAccuration;
@property (nonatomic, assign) BOOL invalid;
@property (nonatomic, assign) NSInteger invalidPointIndex;
//需要的数据
@property (nonatomic, assign) NSInteger step;
@property (nonatomic, assign) NSInteger stride;
@property (nonatomic, assign) NSInteger frequency;
@property (nonatomic, assign) double distance;
@property (nonatomic, assign) double speed;
@property (nonatomic, copy) NSString *speedString;
@property (nonatomic, copy) NSString *pace;
@property (nonatomic, assign) NSInteger time;

@property (nonatomic, assign) NSInteger lastStep;

@property (nonatomic, strong) CLLocation *startLocation;
@property (nonatomic, strong) CLLocation *lastLocation;

@property (nonatomic, strong) LNSportsInfoModel *infoModel;

+ (instancetype)shareInstance;

- (void)runningDataWithStartLocation:(CLLocation *)userLocation Time:(NSInteger)time RunData:(LNRunData)runData;

- (void)calculateStep:(NSInteger)step LNStepData:(LNStepData)stepData;

- (void)initializeRunning;

- (void)updateRunningInfo;

- (void)cancelRunning;

- (void)finishRunning;

@end
