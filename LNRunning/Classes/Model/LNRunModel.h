//
//  LNRunModel.h
//  LNRunning
//
//  Created by Lix on 2017/11/16.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNRunModel : NSObject

@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) NSInteger steps;
@property (nonatomic, assign) NSInteger all_points;

+ (NSString *)dateToString;

@end
