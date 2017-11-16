//
//  LNRunPointModel.h
//  LNRunning
//
//  Created by Lix on 2017/11/16.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNRunPointModel : NSObject

@property (nonatomic, assign) NSInteger runId;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) NSInteger accuration;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger steps;

@end
