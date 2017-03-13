//
//  ViewController.m
//  LNRunning
//
//  Created by Lix on 17/2/9.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import "ViewController.h"
#import "LNRunning.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[LNDBManager shareInstance] checkNotUpdateRunInfo];
    [[LNDBManager shareInstance] createTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - lazy var

@end
