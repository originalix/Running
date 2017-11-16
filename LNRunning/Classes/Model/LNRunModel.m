//
//  LNRunModel.m
//  LNRunning
//
//  Created by Lix on 2017/11/16.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import "LNRunModel.h"
#import "WHC_ModelSqlite.h"

@interface LNRunModel() <WHC_SqliteInfo>

@end

@implementation LNRunModel

+ (NSString *)whc_SqliteMainkey {
    return @"_id";
}

@end
