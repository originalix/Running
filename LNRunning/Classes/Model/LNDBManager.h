//
//  LNDBManager.h
//  LNRunning
//
//  Created by Lix on 17/2/10.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@class LNSportsInfoModel, LNSportsDetailModel;

@interface LNDBManager : NSObject

@property (nonatomic, strong) FMDatabase *db;

+ (instancetype)shareInstance;

- (void)createTable;

- (void)deleteTable;

+ (NSString *)SPORT_INFO_TABLE;

+ (NSString *)SPORT_DETAIL_TABLE;

/**
 插入info模型数据
 
 @param model MODEL
 */
- (void)insertInfoModel:(LNSportsInfoModel *)model;
- (void)updateInfoModel:(LNSportsInfoModel *)model;
- (void)updateInputTime:(NSString *)runID;

/**
 插入Detail点模型数据
 
 @param model MODEL
 */
- (void)insertDetailModel:(LNSportsDetailModel *)model;

/**
 获取到RunID后 更新Info表中的Runid
 
 @param runID runid
 @param id id
 */
- (void)updateRunID:(NSString *)runID id:(NSString *)id;

/**
 根据id删除Info表中以及Detail表中 外键关联数据
 
 @param tableName TABLENAME
 @param id  ID
 */
- (void)deleteInfoData:(NSString *)tableName id:(NSString *)id;

/**
 获取列表条数
 
 @param tableName TABLENAME
 @return COUNT
 */
- (NSInteger)getTableItemCount:(NSString *)tableName;


/**
 检查未上传的数据
 
 @return array
 */
- (NSMutableArray *)checkNotUpdateData;
- (NSMutableArray *)checkNotUpdateRunInfo;

/**
 读取点的坐标数据
 
 @param runID RUNID
 @return ARRAY
 */
- (NSMutableArray *)loadPoint:(NSInteger)runID;

- (NSString *)packagePointData:(NSInteger)runID;

/**
 获取一次跑步的详情
 
 @param runID RUNIR
 @return INFO
 */
- (NSMutableDictionary *)loadOnceRun:(NSInteger)runID;

- (NSMutableArray *)getPerKilometerPace:(NSInteger)runID;

- (NSMutableArray *)getPaceInfo:(NSInteger)runID;

- (LNSportsInfoModel *)getInfoModelWithID:(NSInteger)id;

- (void)deleteDB;


@end
