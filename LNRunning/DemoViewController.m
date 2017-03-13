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

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
