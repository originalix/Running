//
//  LNSportsInfoModel.h
//  LNRunning
//
//  Created by Lix on 17/2/10.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNSportsInfoModel : NSObject

//速度换算成m/s
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, assign) NSInteger inputTime;
@property (nonatomic, assign) NSInteger targetType;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) NSInteger steps;
@property (nonatomic, assign) NSInteger target;
@property (nonatomic, assign) NSInteger runCount;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, assign) NSInteger invalidPoints;

@end
