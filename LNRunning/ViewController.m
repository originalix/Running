//
//  ViewController.m
//  LNRunning
//
//  Created by Lix on 17/2/9.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import "ViewController.h"
#import "LNRunning.h"
#import "DemoViewController.h"
#import "LNRunning-Swift.h"

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

- (IBAction)go2RunView:(id)sender {
    
    DemoViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DemoViewController"];
    UIViewController *vc1 = [TinyObject createMainVCWithVc:vc];
    [self.navigationController pushViewController:vc1 animated:true];
}

#pragma mark - lazy var

@end
