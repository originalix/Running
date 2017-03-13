//
//  LNGetPaceModel.h
//  LNRunning
//
//  Created by Lix on 17/2/10.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GetPaceModel;

@interface LNGetPaceModel : NSObject

@property (nonatomic, strong) NSNumber *code;

@property (nonatomic, strong) NSArray<GetPaceModel *> *paces;

@end

@interface GetPaceModel : NSObject

@property (nonatomic, strong) NSNumber *miles;

@property (nonatomic, strong) NSNumber *seconds;

@property (nonatomic, strong) NSNumber *current_total_time;

@end

