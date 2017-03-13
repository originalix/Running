//
//  LNDBManager.m
//  LNRunning
//
//  Created by Lix on 17/2/10.
//  Copyright © 2017年 Lix. All rights reserved.
//

#import "LNDBManager.h"
#import "LNSportsInfoModel.h"
#import "LNSportsDetailModel.h"
#import "LNRunning.h"
#import "LNGetPaceModel.h"

@interface LNDBManager()

@end

@implementation LNDBManager

#pragma mark - 单例管理
static LNDBManager *_lnDBManager = nil;

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
        BLYLogDebug(@"DBPath = %@", [LNDBManager dbPath]);
    }
    return self;
}

#pragma mark - SQL

#pragma mark - 建表
- (void)createTable {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[LNDBManager dbPath]]) {
        BLYLogWarn(@"!!!!数据库文件不存在!!!!");
        return;
    }
    if ([self.db open]) {
        if (![self tableExists:[LNDBManager SPORT_INFO_TABLE]]) {
            BOOL resultSportInfo = [self.db executeUpdate:[LNDBManager createInfoTable]];
            if (resultSportInfo) {
                BLYLogWarn(@"create sportinfo table success");
            } else {
                BLYLogWarn(@"error when create table");
            }
            BOOL foreignKey =  [self.db executeUpdate:@"PRAGMA foreign_keys=on;"];
            if (foreignKey) {
                BLYLogWarn(@"设置外键成功");
            } else {
                BLYLogWarn(@"设置外键失败");
            }
        }
        if (![self tableExists:[LNDBManager SPORT_DETAIL_TABLE]]) {
            BOOL resultSportDetail = [self.db executeUpdate:[LNDBManager createDetailTable]];
            if (resultSportDetail) {
                BLYLogWarn(@"create sport detail table success");
            } else {
                BLYLogWarn(@"error when create table");
            }
        }
        
        [self.db close];
    }
}

#pragma mark - 删除表
- (void)deleteTable {
    if ([self.db open]) {
        BOOL resultSportInfo = [self.db executeUpdate:[LNDBManager deleteTable:[LNDBManager SPORT_INFO_TABLE]]];
        BOOL resultSportDetail = [self.db executeUpdate:[LNDBManager deleteTable:[LNDBManager SPORT_DETAIL_TABLE]]];
        if (resultSportDetail && resultSportInfo) {
            BLYLogWarn(@"delete table success");
        } else {
            BLYLogWarn(@"delete table error");
        }
        [self.db close];
    }
}

#pragma mark - 插入Info表数据
- (void)insertInfoModel:(LNSportsInfoModel *)model {
    NSString *insertInfoModel = [NSString stringWithFormat:@"INSERT INTO %@ (id, runCount, uid, startTime, endTime, inputTime, targetType, target, duration, distance, steps, points, invalidPoints) VALUES (%ld, %ld, %ld, %ld, %ld, %ld, %ld, %ld, %ld, %ld, %ld, %ld, %ld)", [LNDBManager SPORT_INFO_TABLE], model.id, model.runCount, model.uid, model.startTime, model.endTime, model.inputTime, model.targetType, model.target, model.duration, model.distance, model.steps, model.points, model.invalidPoints];
    if ([self.db open]) {
        BOOL result = [self.db executeUpdate:insertInfoModel];
        if (result) {
            BLYLogWarn(@"插入INFO数据成功");
        } else {
            BLYLogWarn(@"插入INFO数据失败");
        }
        [self.db close];
    }
}

#pragma mark - 插入点的数据
- (void)insertDetailModel:(LNSportsDetailModel *)model {
    NSString *insertDetailModel = [NSString stringWithFormat:@"INSERT INTO %@ (runID, uid, startTime, latitude, longitude, altitude, steps, accuration, distance, duration, type, done, isValid) VALUES (%ld, %ld, %ld, %f, %f, %f, %ld, %ld, %ld, %ld, %@, %ld, %ld)", [LNDBManager SPORT_DETAIL_TABLE], model.runID, model.uid, model.startTime, model.latitude, model.longitude, model.altitude, model.steps, model.accuration, model.distance, model.duration, model.type, model.done, model.isValid];
    if ([self.db open]) {
        BOOL result = [self.db executeUpdate:insertDetailModel];
        if (result) {
            BLYLogWarn(@"插入Detail数据成功");
        } else {
            BLYLogWarn(@"插入Detail数据失败");
        }
        [self.db close];
    }
}

#pragma mark - 更新Info表数据
- (void)updateInfoModel:(LNSportsInfoModel *)model {
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET id = %ld, runCount = %ld, uid = %ld, startTime= %ld, endTime = %ld, inputTime = %ld, targetType = %ld, target = %ld, duration = %ld, distance = %ld, steps = %ld, points = %ld, invalidPoints = %ld WHERE id = '%ld'", [LNDBManager SPORT_INFO_TABLE], model.id, model.runCount, model.uid, model.startTime, model.endTime, model.inputTime, model.targetType, model.target, model.duration, model.distance, model.steps, model.points, model.invalidPoints, model.id];
        BLYLogWarn(@"UPDATE SQL = %@", sql);
        BOOL result = [self.db executeUpdate:sql];
        if (result) {
            BLYLogWarn(@"更新info数据成功");
        } else {
            BLYLogWarn(@"更新info数据失败");
        }
        [self.db close];
    }
}

#pragma mark - 当网络请求成功后，更新Info表的Runid
- (void)updateRunID:(NSString *)runID id:(NSString *)id {
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET runCount = '%@' WHERE id = '%@'", [LNDBManager SPORT_INFO_TABLE], runID, id];
        BLYLogWarn(@"UPDATE SQL = %@", sql);
        BOOL result = [self.db executeUpdate:sql];
        if (result) {
            BLYLogWarn(@"更新RunID成功");
        } else {
            BLYLogWarn(@"更新RunID失败");
        }
        [self.db close];
    }
}

- (void)updateInputTime:(NSString *)runID {
    if ([self.db open]) {
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval interval = [date timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%0.f", interval];
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET inputTime = '%@' WHERE runCount = '%@'", [LNDBManager SPORT_INFO_TABLE], timeString, runID];
        BLYLogWarn(@"UPDATE SQL = %@", sql);
        BOOL result = [self.db executeUpdate:sql];
        if (result) {
            BLYLogWarn(@"更新inputTime成功");
        } else {
            BLYLogWarn(@"更新inputTime失败");
        }
        [self.db close];
    }
}

#pragma mark - 删除Info表中数据
- (void)deleteInfoData:(NSString *)tableName id:(NSString *)id {
    if ([self.db open]) {
        BOOL foreignKey =  [self.db executeUpdate:@"PRAGMA foreign_keys=ON;"];
        BOOL result = [self.db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE id = %@", tableName, id]];
        if (foreignKey && result) {
            BLYLogWarn(@"INFO数据删除成功");
        } else {
            BLYLogWarn(@"INFO数据删除失败");
        }
        [self.db close];
    }
}

#pragma mark - 检测表中数据条数
- (NSInteger)getTableItemCount:(NSString *)tableName {
    NSInteger count = 0;
    if ([self.db open]) {
        NSString *sqlstr = [NSString stringWithFormat:@"SELECT count(id) as 'count' FROM %@", tableName];
        FMResultSet *result = [self.db executeQuery:sqlstr];
        while ([result next]) {
            count = [result intForColumn:@"count"];
            BLYLogWarn(@"TableItemCount %ld", count);
        }
        [self.db close];
        return count;
    } else {
        return 0;
    }
}

#pragma mark - 删除数据库
- (void)deleteDB {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) firstObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:DB_NAME];
    BOOL isSuccess = [fileManager removeItemAtPath:dbPath error:nil];
    if (isSuccess) {
        BLYLogWarn(@"delete success");
    }else{
        BLYLogWarn(@"delete fail");
    }
}

#pragma mark - 加载点的轨迹
- (NSMutableArray *)loadPoint:(NSInteger)runID {
    if (![self.db open]) {
        return nil;
    }
    NSMutableArray *pointArray = [NSMutableArray array];
    NSString *queryIDSQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE runCount = '%ld'", [LNDBManager SPORT_INFO_TABLE], runID];
    FMResultSet *idResult = [self.db executeQuery:queryIDSQL];
    while ([idResult next]) {
        NSInteger id = [idResult intForColumn:@"id"];
        NSString *queryPoint = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE runID = '%ld'", [LNDBManager SPORT_DETAIL_TABLE], id];
        FMResultSet *pointResult = [self.db executeQuery:queryPoint];
        while ([pointResult next]) {
            double latitude = [pointResult doubleForColumn:@"latitude"];
            double longitude = [pointResult doubleForColumn:@"longitude"];
            double accuration = [pointResult doubleForColumn:@"accuration"];
            if (accuration < 65) {
                CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
                [pointArray addObject:location];
            }
        }
    }
    [self.db close];
    return pointArray;
}

#pragma mark - 从数据库读取跑步详情
- (NSMutableDictionary *)loadOnceRun:(NSInteger)runID {
    if (![self.db open]) {
        return nil;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *queryIDSQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE runCount = '%ld'", [LNDBManager SPORT_INFO_TABLE], runID];
    FMResultSet *idResult = [self.db executeQuery:queryIDSQL];
    while ([idResult next]) {
        NSNumber *startTime = [NSNumber numberWithInteger:[idResult intForColumn:@"startTime"]];
        NSNumber *duration = [NSNumber numberWithInteger:[idResult intForColumn:@"duration"]];
        NSNumber *steps = [NSNumber numberWithInteger:[idResult intForColumn:@"steps"]];
        NSNumber *distance = [NSNumber numberWithInteger:[idResult intForColumn:@"distance"]];
        NSNumber *stride = [NSNumber numberWithInteger:[idResult intForColumn:@"stride"]];
        NSNumber *stepFrequency = [NSNumber numberWithInteger:[idResult intForColumn:@"stepFrequency"]];
        NSNumber *calories = [NSNumber numberWithInteger:[idResult intForColumn:@"calories"]];
        NSNumber *minSpeed = [NSNumber numberWithDouble:[idResult intForColumn:@"minSpeed"]];
        NSNumber *maxSpeed = [NSNumber numberWithDouble:[idResult intForColumn:@"maxSpeed"]];
        NSNumber *avgSpeed = [NSNumber numberWithDouble:[idResult intForColumn:@"avgSpeed"]];
        NSNumber *speed = [NSNumber numberWithDouble:[idResult intForColumn:@"speed"]];
        NSData *speedData = [idResult dataForColumn:@"speedArray"];
        id array = [[NSString alloc] initWithData:speedData encoding:NSUTF8StringEncoding];
        BLYLogWarn(@"array = %@", array);
        [dic setObject:startTime forKey:@"startTime"];
        [dic setObject:duration forKey:@"duration"];
        [dic setObject:steps forKey:@"steps"];
        [dic setObject:distance forKey:@"distance"];
        [dic setObject:stride forKey:@"stride"];
        [dic setObject:stepFrequency forKey:@"stepFrequency"];
        [dic setObject:calories forKey:@"calories"];
        [dic setObject:minSpeed forKey:@"minSpeed"];
        [dic setObject:maxSpeed forKey:@"maxSpeed"];
        [dic setObject:avgSpeed forKey:@"avgSpeed"];
        [dic setObject:speed forKey:@"speed"];
        BLYLogWarn(@"speedData = %@", speedData);
    }
    [self.db close];
    BLYLogWarn(@"dic = %@", dic);
    return dic;
}

#pragma mark - 获取每千米配速
- (NSMutableArray *)getPerKilometerPace:(NSInteger)runID {
    if (![self.db open]) {
        return nil;
    }
    NSMutableArray *paceArray = [NSMutableArray array];
    double totalDistance = 0;
    double speed = 0;
    NSString *queryIDSQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE runCount = '%ld'", [LNDBManager SPORT_INFO_TABLE], runID];
    FMResultSet *idResult = [self.db executeQuery:queryIDSQL];
    while ([idResult next]) {
        NSInteger id = [idResult intForColumn:@"id"];
        double startTime = [idResult doubleForColumn:@"startTime"];
        double duration = [idResult doubleForColumn:@"duration"];
        NSInteger sumDistance = [idResult intForColumn:@"distance"];
        NSString *queryPoint = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE runID = '%ld'", [LNDBManager SPORT_DETAIL_TABLE], id];
        FMResultSet *pointResult = [self.db executeQuery:queryPoint];
        while ([pointResult next]) {
            double distance = [pointResult doubleForColumn:@"distance"];
            totalDistance += distance;
            if (totalDistance / 1000 >= 1) {
                double endTime = [pointResult doubleForColumn:@"startTime"];
                speed = (totalDistance / (endTime - startTime));
                if (speed > 0) {
                    [paceArray addObject:[NSNumber numberWithDouble:speed]];
                } else {
                    [paceArray addObject:[NSNumber numberWithDouble:0]];
                }
                startTime = endTime;
                totalDistance = 0;
            }
        }
        if (sumDistance % 1000 > 0) {
            speed = (double)sumDistance / duration;
            [paceArray addObject:[NSNumber numberWithDouble:speed]];
        }
    }
    BLYLogWarn(@"paceArray = %@", paceArray);
    [self.db close];
    return paceArray;
}

#pragma mark - 获取配速和耗时
- (NSMutableArray *)getPaceInfo:(NSInteger)runID {
    if (![self.db open]) {
        return nil;
    }
    NSMutableArray *paceArray = [NSMutableArray array];
    double totalDistance = 0;
    double totalDuration = 0;
    double seconds = 0;
    NSInteger miles = 1;
    NSString *queryIDSQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE runCount = '%ld'", [LNDBManager SPORT_INFO_TABLE], runID];
    FMResultSet *idResult = [self.db executeQuery:queryIDSQL];
    while ([idResult next]) {
        NSInteger id = [idResult intForColumn:@"id"];
        double startTime = [idResult doubleForColumn:@"startTime"];
        double duration = [idResult doubleForColumn:@"duration"];
        NSInteger sumDistance = [idResult intForColumn:@"distance"];
        NSString *queryPoint = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE runID = '%ld'", [LNDBManager SPORT_DETAIL_TABLE], id];
        FMResultSet *pointResult = [self.db executeQuery:queryPoint];
        while ([pointResult next]) {
            double distance = [pointResult doubleForColumn:@"distance"];
            totalDistance += distance;
            if (totalDistance / 1000 >= 1) {
                double endTime = [pointResult doubleForColumn:@"startTime"];
                seconds = (endTime - startTime);
                totalDuration += seconds;
                GetPaceModel *model = [[GetPaceModel alloc] init];
                model.miles = [NSNumber numberWithInteger:miles];
                model.seconds = [NSNumber numberWithDouble:seconds];
                model.current_total_time = [NSNumber numberWithDouble:totalDuration];
                [paceArray addObject:model];
                startTime = endTime;
                totalDistance = 0;
                seconds = 0;
                miles += 1;
            }
        }
        if (sumDistance % 1000 > 0) {
            GetPaceModel *model = [[GetPaceModel alloc] init];
            if (paceArray.count < 1) {
                model.seconds = [NSNumber numberWithDouble:duration];
                model.miles = [NSNumber numberWithInteger:miles];
                model.current_total_time = [NSNumber numberWithDouble:duration];
            } else {
                double endTime = [idResult doubleForColumn:@"endTime"];
                double time = endTime - startTime;
                double lastDistance = sumDistance % 1000;
                double speed = lastDistance / time;
                double lastPace = 1000 / speed;
                model.seconds = [NSNumber numberWithDouble:lastPace];
                model.miles = [NSNumber numberWithInteger:miles];
                model.current_total_time = [NSNumber numberWithDouble:duration];
            }
            [paceArray addObject:model];
        }
    }
    BLYLogWarn(@"paceArray = %@", paceArray);
    [self.db close];
    return paceArray;
}

#pragma mark - 打包所有点的数据
- (NSString *)packagePointData:(NSInteger)runID{
    if (![self.db open]) {
        return nil;
    }
    NSMutableArray *pointArray = [NSMutableArray array];
    NSString *queryIDSQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE runCount = '%ld'", [LNDBManager SPORT_INFO_TABLE], runID];
    FMResultSet *idResult = [self.db executeQuery:queryIDSQL];
    while ([idResult next]) {
        NSInteger id = [idResult intForColumn:@"id"];
        NSString *queryPoint = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE runID = '%ld'", [LNDBManager SPORT_DETAIL_TABLE], id];
        FMResultSet *pointResult = [self.db executeQuery:queryPoint];
        while ([pointResult next]) {
            NSInteger starttime = [pointResult intForColumn:@"startTime"];
            NSInteger steps = [pointResult intForColumn:@"steps"];
            double latitude = [pointResult doubleForColumn:@"latitude"];
            double longitude = [pointResult doubleForColumn:@"longitude"];
            double altitude = [pointResult doubleForColumn:@"altitude"];
            NSInteger distance = [pointResult intForColumn:@"distance"];
            NSInteger duration = [pointResult intForColumn:@"duration"];
            NSInteger accuration = [pointResult intForColumn:@"accuration"];
            NSInteger valid = [pointResult intForColumn:@"isValid"];
            NSDictionary *point = @{
                                    @"starttime" : [NSNumber numberWithInteger:starttime],
                                    @"steps" : [NSNumber numberWithInteger:steps],
                                    @"latitude" : [NSNumber numberWithDouble:latitude],
                                    @"longitude" : [NSNumber numberWithDouble:longitude],
                                    @"altitude" : [NSNumber numberWithDouble:altitude],
                                    @"distance" : [NSNumber numberWithInteger:distance],
                                    @"duration" : [NSNumber numberWithInteger:duration],
                                    @"accuration" : [NSNumber numberWithInteger:accuration],
                                    @"type" : @"gps",
                                    @"valid" : [NSNumber numberWithInteger:valid]
                                    };
            [pointArray addObject:point];
        }
    }
    NSString *JSONArray = [pointArray yy_modelToJSONString];
    BLYLogWarn(@"JSONArray = %@", JSONArray);
    [self.db close];
    return JSONArray;
}

#pragma mark - 返回单条跑步信息模型
- (LNSportsInfoModel *)getInfoModelWithID:(NSInteger)id {
    if (![self.db open]) {
        return nil;
    }
    LNSportsInfoModel *model = [[LNSportsInfoModel alloc] init];
    NSString *queryIDSQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE id = '%ld'", [LNDBManager SPORT_INFO_TABLE], id];
    FMResultSet *idResult = [self.db executeQuery:queryIDSQL];
    while ([idResult next]) {
        model.id = [idResult intForColumn:@"id"];
        model.startTime = [idResult intForColumn:@"startTime"];
        model.endTime = [idResult intForColumn:@"endTime"];
        model.targetType = [idResult intForColumn:@"targetType"];
        model.target = [idResult intForColumn:@"target"];
        model.duration = [idResult intForColumn:@"duration"];
        model.steps = [idResult intForColumn:@"steps"];
        model.points = [idResult intForColumn:@"points"];
        model.invalidPoints = [idResult intForColumn:@"invalidPoints"];
    }
    [self.db close];
    return model;
}

#pragma mark - 遍历所有数据 返回没上传的点的RunID
- (NSMutableArray *)checkNotUpdateRunInfo {
    if (![self.db open]) {
        return nil;
    }
    NSMutableArray *idArray = [NSMutableArray array];
    NSString *queryIDSQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE runCount = '0'", [LNDBManager SPORT_INFO_TABLE]];
    FMResultSet *idResult = [self.db executeQuery:queryIDSQL];
    while ([idResult next]) {
        double distance = [idResult doubleForColumn:@"distance"];
        NSInteger id = [idResult intForColumn:@"id"];
        if (distance > 100) {
            [idArray addObject: [NSNumber numberWithInteger:id]];
        } else {
            BOOL foreignKey =  [self.db executeUpdate:@"PRAGMA foreign_keys=ON;"];
            BOOL result = [self.db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE id = %ld", [LNDBManager SPORT_INFO_TABLE], id]];
            if (foreignKey && result) {
                BLYLogWarn(@"INFO数据删除成功");
            } else {
                BLYLogWarn(@"INFO数据删除失败");
            }
        }
    }
    [self.db close];
    return idArray;
}

- (NSMutableArray *)checkNotUpdateData {
    if (![self.db open]) {
        return nil;
    }
    NSMutableArray *runIDArray = [NSMutableArray array];
    NSString *queryIDSQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE inputTime = '0'", [LNDBManager SPORT_INFO_TABLE]];
    FMResultSet *idResult = [self.db executeQuery:queryIDSQL];
    while ([idResult next]) {
        NSInteger runID = [idResult intForColumn:@"runCount"];
        if (runID != 0) {
            [runIDArray addObject: [NSNumber numberWithInteger:runID]];
        }
    }
    [self.db close];
    return runIDArray;
}

#pragma mark - private Method
+ (NSString *)dbPath {
    NSString *PATH_OF_DOCUMENT = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) firstObject];
    return [NSString stringWithFormat:@"%@%@", PATH_OF_DOCUMENT, DB_NAME];
}

+ (NSString *)SPORT_INFO_TABLE{
    return @"SportsInfo";
}

+ (NSString *)SPORT_DETAIL_TABLE {
    return @"SportsDetail";
}

+ (NSString *)createInfoTable {
    return [NSString stringWithFormat:@"CREATE TABLE if not exists '%@' ('id' INTEGER PRIMARY KEY NOT NULL, 'runCount' INTEGER, 'uid' INTEGER NOT NULL, 'startTime' INTEGER, 'endTime' INTEGER, 'inputTime' INTEGER, 'targetType' INTEGER, 'target' INTEGER, 'distance' INTEGER, 'duration' INTEGER, 'steps' INTEGER, 'points' INTEGER, 'invalidPoints' INTEGER)", [self SPORT_INFO_TABLE]];
}

+ (NSString *)createDetailTable {
    return [NSString stringWithFormat:@"CREATE TABLE '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'runID' INTEGER NOT NULL, 'uid' INTEGER NOT NULL, 'startTime' INTEGER, 'latitude' REAL, 'longitude' REAL, 'altitude' REAL, 'steps' INTEGER, 'accuration' INTEGER, 'distance' INTEGER, 'duration' INTEGER, 'type' TEXT, 'done' INTEGER, 'isValid' INTEGER, CONSTRAINT 'runID' FOREIGN KEY ('runID') REFERENCES '%@' ('id') ON DELETE CASCADE ON UPDATE CASCADE)", [self SPORT_DETAIL_TABLE], [self SPORT_INFO_TABLE]];
}

+ (NSString *)deleteTable:(NSString *)tableName {
    return [NSString stringWithFormat:@"DROP TABLE %@", tableName];
}

+ (NSString *)cleanInfoTable:(NSString *)tableName {
    return [NSString stringWithFormat:@"DELETE FROM %@", tableName];
}

- (BOOL) tableExists:(NSString *)tableName {
    FMResultSet *rs = [self.db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next]) {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        if (0 == count) {
            return NO;
        }
        return YES;
    }
    return NO;
}

#pragma mark - lazy var
- (FMDatabase *)db {
    if (!_db) {
        NSString *pathDocument = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) firstObject];
        NSString *dbPath = [NSString stringWithFormat:@"%@%@", pathDocument, DB_NAME];
        _db = [[FMDatabase alloc] initWithPath:dbPath];
    }
    return _db;
}

@end
