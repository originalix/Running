//
//  LNGetPaceModel.m
//  LNRunning
//
//  Created by Lix on 17/2/10.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import "LNGetPaceModel.h"

@implementation LNGetPaceModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"paces" : [GetPaceModel class],
             };
}

@end

@implementation GetPaceModel

@end
