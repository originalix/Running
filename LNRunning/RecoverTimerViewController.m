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
//    self.timer = [[LNRecoverTimer alloc] initWithTimeLabel:self.timeLabel];
    self.timer = [[LNRecoverTimer alloc] initWithTimeLabel:self.timeLabel beforeTimeNumber:60];
    self.timeLabel.text = [NSString timeFormatted:60];
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

@end
