//
//  LNSportsDetailModel.h
//  LNRunning
//
//  Created by Lix on 17/2/10.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNSportsDetailModel : NSObject

@property (nonatomic, assign) NSInteger runID;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double altitude;
@property (nonatomic, assign) NSInteger accuration;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger steps;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger done;
@property (nonatomic, assign) NSInteger isValid;

@end
