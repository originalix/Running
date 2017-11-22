//
//  DBManager.m
//  LNRunning
//
//  Created by Lix on 2017/11/16.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import "DBManager.h"
#import "WHC_ModelSqlite.h"
#import "LNRunModel.h"

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

- (NSInteger)queryRunIDBy:(NSString *)startTime {
    NSString *sql = [NSString stringWithFormat:@"startTime = '%@'", startTime];
    NSArray *arr = [WHC_ModelSqlite query:[LNRunModel class]];
    NSLog(@"%@", arr);
    NSArray *result = [WHC_ModelSqlite query:[LNRunModel class] where:sql];
    if ([result count] > 0) {
        LNRunModel *model = [result firstObject];
        return model._id;
    }
    return 0;
}

- (void)insertDetailModel:(LNRunPointModel *)model {
    [WHC_ModelSqlite insert:model];
}

- (void)updateInfoModel:(LNRunModel *)model {
    NSString *sql = [NSString stringWithFormat:@"startTime = '%@'", model.startTime];
    [WHC_ModelSqlite update:model where:sql];
}

- (void)deleteInfoData:(LNRunModel *)model {
    NSString *sql = [NSString stringWithFormat:@"startTime = '%@'", model.startTime];
    [WHC_ModelSqlite delete:[LNRunModel class] where:sql];
}

@end
