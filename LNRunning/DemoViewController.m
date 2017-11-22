//
//  DemoViewController.m
//  LNRunning
//
//  Created by Lix on 17/2/10.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *paceLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *strideLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIButton *pause1Button;
@property (nonatomic, weak) IBOutlet UIButton *continue1Button;
@property (nonatomic, weak) IBOutlet UIButton *end1Button;
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self ln_updateConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self ln_updateConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)ln_updateConstraints {
    self.mainView.backgroundColor = clear_color;
    [self.lnMapView bringSubviewToFront:self.mainView];
    [self.lnMapView setFrame:Rect(self.mainView.x, self.mainView.y, self.mainView.width, self.mainView.height)];
    [self.timerLabel setFrame:Rect(self.timeLabel.x, self.timeLabel.y, self.timeLabel.width, self.timeLabel.height)];
    [self.timeLabel setHidden:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.timerLabel setFrame:self.timeLabel.frame];
        self.timerLabel.textColor = self.timeLabel.textColor;
//        self.pause1Button = self.pauseButton;
//        self.continue1Button = self.continueButton;
//        self.end1Button = self.endButton;
//        [self.pause1Button setHidden:true];
//        [self.continue1Button setHidden:true];
//        [self.end1Button setHidden:true];
        
        [self.pauseButton setFrame:self.pause1Button.frame];
        [self.continueButton setFrame:self.continue1Button.frame];
        [self.endButton setFrame:self.end1Button.frame];
    });
//    [self.timerLabel setFrame:self.timeLabel.frame];
//    self.timerLabel.textColor = self.timeLabel.textColor;
//    self.pause1Button = self.pauseButton;
//    self.continue1Button = self.continueButton;
//    self.end1Button = self.endButton;
//    [self.pauseButton setHidden:true];
//    [self.continueButton setHidden:true];
//    [self.endButton setHidden:true];
}

- (void)ln_bindRunData {
    self.distanceLabel.text = [NSString stringWithFormat:@"%f", self.distance];
    self.paceLabel.text = [NSString stringWithFormat:@"%@", self.pace];
    self.speedLabel.text = [NSString stringWithFormat:@"%@", self.speedString];
}

- (void)ln_bindStepData {
    self.stepLabel.text = [NSString stringWithFormat:@"%ld", self.step];
    self.strideLabel.text = [NSString stringWithFormat:@"%ld", self.stepStride];
    self.frequencyLabel.text = [NSString stringWithFormat:@"%ld", self.stepFrequency];
}


@end
