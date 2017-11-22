//
//  AppDelegate.m
//  LNRunning
//
//  Created by Lix on 17/2/9.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import "AppDelegate.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "LNRunBaseViewController.h"
#import "LixFoundation.h"

@interface AppDelegate ()<BuglyDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[AMapServices sharedServices] setApiKey:@"6c02a76e78dd08e1808136f58d07c439"];
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.debugMode = true;
    config.unexpectedTerminatingDetectionEnable = true;
    config.blockMonitorEnable = true;
    config.blockMonitorTimeout = 3;
    config.viewControllerTrackingEnable = true;
    config.reportLogLevel = BuglyLogLevelVerbose;
    config.consolelogEnable = true;
    config.delegate = self;
    [Bugly startWithAppId:@"99753fac8d" config:config];
    
//    LNRunBaseViewController *viewController = [[LNRunBaseViewController alloc] init];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
//    self.window = [[UIWindow alloc] initWithFrame:kUIScreen_Bounds];
//    self.window.rootViewController = navigationController;
//    [self.window makeKeyAndVisible];
    return YES;
}

- (NSString *)attachmentForException:(NSException *)exception {
    return @"携带信息";
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
