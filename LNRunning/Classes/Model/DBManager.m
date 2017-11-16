//
//  DBManager.m
//  LNRunning
//
//  Created by Lix on 2017/11/16.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import "DBManager.h"
#import "WHC_ModelSqlite.h"

@implementation DBManager

#pragma mark - 单例管理
static DBManager *_lnDBManager = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _lnDBManager = [super allocWithZone:zone];
    });
    return _lnDBManager;
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _lnDBManager = [[self alloc] init];
    });
    return _lnDBManager;
}

- (id)copyWithZone:(NSZone *)zone {
    return _lnDBManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        BLYLogDebug(@"DBPath = %@", [LNDBManager dbPath]);
    }
    return self;
}

- (void)insertInfoModel:(LNRunModel *)model {
    [WHC_ModelSqlite insert:model];
}

@end
