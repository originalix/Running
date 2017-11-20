//
//  RecoverTimerViewController.m
//  LNRunning
//
//  Created by Lix on 2017/11/16.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import "RecoverTimerViewController.h"
#import "LNRunning-Swift.h"
#import "NSString+LixExtension.h"
#import "LNRunModel.h"
#import "WHC_ModelSqlite.h"
#import "RecoverManager.h"

@interface RecoverTimerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (nonatomic, strong) LNRecoverTimer *timer;
@end

@implementation RecoverTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
////    self.timer = [[LNRecoverTimer alloc] initWithTimeLabel:self.timeLabel];
//    self.timer = [[LNRecoverTimer alloc] initWithTimeLabel:self.timeLabel beforeTimeNumber:60];
//    self.timeLabel.text = [NSString timeFormatted:60];
////    [LNRecoverTimer test];
//    LNRunModel *model = [[LNRunModel alloc] init];
//    model.startTime = [LNRunModel dateToString];
//    model.endTime = [LNRunModel dateToString];
//    model.duration = 0;
//    for (int i = 0; i < 10; i++) {
//        [WHC_ModelSqlite insert:model];
//    }
//    NSLog(@"db path = %@", [WHC_ModelSqlite localPathWithModel:[LNRunModel class]]);
//
//    NSArray *array = [WHC_ModelSqlite query:[LNRunModel class]];
//    for (LNRunModel *model in array) {
//        NSLog(@"%@", model);
//    }
//
//    [WHC_ModelSqlite removeModel:[LNRunModel class]];
    [self checkNeedRecover];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)start:(id)sender {
    [self.timer timingStart];
}

- (IBAction)pause:(id)sender {
    [self.timer timingPause];
}

- (IBAction)reset:(id)sender {
    [self.timer resetToStart];
}

- (void)checkNeedRecover {
    RecoverManager *recoverManager = [[RecoverManager alloc] init];
    [recoverManager checkNeedRecoverRun];
}

@end
