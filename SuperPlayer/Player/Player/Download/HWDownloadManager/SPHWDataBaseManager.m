//
//  SPHWDataBaseManager.m
//  SPHWProject
//
//  Created by wangqibin on 2018/4/25.
//  Copyright © 2018年 wangqibin. All rights reserved.
//

#import "SPHWDataBaseManager.h"
#import "FMDB.h"
#import "SPHWToolBox.h"

typedef NS_ENUM(NSInteger, SPHWDBGetDateOption) {
    SPHWDBGetDateOptionAllCacheData = 0,      // 所有缓存数据
    SPHWDBGetDateOptionAllDownloadingData,    // 所有正在下载的数据
    SPHWDBGetDateOptionAllDownloadedData,     // 所有下载完成的数据
    SPHWDBGetDateOptionAllUnDownloadedData,   // 所有未下载完成的数据
    SPHWDBGetDateOptionAllWaitingData,        // 所有等待下载的数据
    SPHWDBGetDateOptionModelWithUrl,          // 通过url获取单条数据
    SPHWDBGetDateOptionWaitingModel,          // 第一条等待的数据
    SPHWDBGetDateOptionLastDownloadingModel,  // 最后一条正在下载的数据
};

@interface SPHWDataBaseManager ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation SPHWDataBaseManager

+ (instancetype)shareManager
{
    static SPHWDataBaseManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self creatVideoCachesTable];
    }
    
    return self;
}

// 创表
- (void)creatVideoCachesTable
{
    // 数据库文件路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SPHWDownloadVideoCaches.sqlite"];
    
    // 创建队列对象，内部会自动创建一个数据库, 并且自动打开
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];

    [_dbQueue inDatabase:^(FMDatabase *db) {
        // 创表
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_videoCaches (id integer PRIMARY KEY AUTOINCREMENT, vid text, fileName text, url text, resumeData blob, totalFileSize integer, tmpFileSize integer, state integer, progress float, lastSpeedTime double, intervalFileSize integer, lastStateTime integer)"];
        if (result) {
//            NSLog(@"视频缓存数据表创建成功");
        }else {
//            NSLog(@"视频缓存数据表创建失败");
        }
    }];
}

// 插入数据
- (void)insertModel:(SPHWDownloadModel *)model
{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:@"INSERT INTO t_videoCaches (vid, fileName, url, resumeData, totalFileSize, tmpFileSize, state, progress, lastSpeedTime, intervalFileSize, lastStateTime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", model.vid, model.fileName, model.url, model.resumeData, [NSNumber numberWithInteger:model.totalFileSize], [NSNumber numberWithInteger:model.tmpFileSize], [NSNumber numberWithInteger:model.state], [NSNumber numberWithFloat:model.progress], [NSNumber numberWithDouble:0], [NSNumber numberWithInteger:0], [NSNumber numberWithInteger:0]];
        if (result) {
//            NSLog(@"插入成功：%@", model.fileName);
        }else {
//            NSLog(@"插入失败：%@", model.fileName);
        }
    }];
}

// 获取单条数据
- (SPHWDownloadModel *)getModelWithUrl:(NSString *)url
{
    return [self getModelWithOption:SPHWDBGetDateOptionModelWithUrl url:url];
}

// 获取第一条等待的数据
- (SPHWDownloadModel *)getWaitingModel
{
    return [self getModelWithOption:SPHWDBGetDateOptionWaitingModel url:nil];
}

// 获取最后一条正在下载的数据
- (SPHWDownloadModel *)getLastDownloadingModel
{
    return [self getModelWithOption:SPHWDBGetDateOptionLastDownloadingModel url:nil];
}

// 获取所有数据
- (NSArray<SPHWDownloadModel *> *)getAllCacheData
{
    return [self getDateWithOption:SPHWDBGetDateOptionAllCacheData];
}

// 根据lastStateTime倒叙获取所有正在下载的数据
- (NSArray<SPHWDownloadModel *> *)getAllDownloadingData
{
    return [self getDateWithOption:SPHWDBGetDateOptionAllDownloadingData];
}

// 获取所有下载完成的数据
- (NSArray<SPHWDownloadModel *> *)getAllDownloadedData
{
    return [self getDateWithOption:SPHWDBGetDateOptionAllDownloadedData];
}

// 获取所有未下载完成的数据
- (NSArray<SPHWDownloadModel *> *)getAllUnDownloadedData
{
    return [self getDateWithOption:SPHWDBGetDateOptionAllUnDownloadedData];
}

// 获取所有等待下载的数据
- (NSArray<SPHWDownloadModel *> *)getAllWaitingData
{
   return [self getDateWithOption:SPHWDBGetDateOptionAllWaitingData];
}

// 获取单条数据
- (SPHWDownloadModel *)getModelWithOption:(SPHWDBGetDateOption)option url:(NSString *)url
{
    __block SPHWDownloadModel *model = nil;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet;
        switch (option) {
            case SPHWDBGetDateOptionModelWithUrl:
                resultSet = [db executeQuery:@"SELECT * FROM t_videoCaches WHERE url = ?", url];
                break;
                
            case SPHWDBGetDateOptionWaitingModel:
                resultSet = [db executeQuery:@"SELECT * FROM t_videoCaches WHERE state = ? order by lastStateTime asc limit 0,1", [NSNumber numberWithInteger:SPHWDownloadStateWaiting]];
                break;
                
            case SPHWDBGetDateOptionLastDownloadingModel:
                resultSet = [db executeQuery:@"SELECT * FROM t_videoCaches WHERE state = ? order by lastStateTime desc limit 0,1", [NSNumber numberWithInteger:SPHWDownloadStateDownloading]];
                break;
                
            default:
                break;
        }
        
        while ([resultSet next]) {
            model = [[SPHWDownloadModel alloc] initWithFMResultSet:resultSet];
        }
    }];
    
    return model;
}

// 获取数据集合
- (NSArray<SPHWDownloadModel *> *)getDateWithOption:(SPHWDBGetDateOption)option
{
    __block NSArray<SPHWDownloadModel *> *array = nil;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet;
        switch (option) {
            case SPHWDBGetDateOptionAllCacheData:
                resultSet = [db executeQuery:@"SELECT * FROM t_videoCaches"];
                break;
                
            case SPHWDBGetDateOptionAllDownloadingData:
                resultSet = [db executeQuery:@"SELECT * FROM t_videoCaches WHERE state = ? order by lastStateTime desc", [NSNumber numberWithInteger:SPHWDownloadStateDownloading]];
                break;
                
            case SPHWDBGetDateOptionAllDownloadedData:
                resultSet = [db executeQuery:@"SELECT * FROM t_videoCaches WHERE state = ?", [NSNumber numberWithInteger:SPHWDownloadStateFinish]];
                break;
                
            case SPHWDBGetDateOptionAllUnDownloadedData:
                resultSet = [db executeQuery:@"SELECT * FROM t_videoCaches WHERE state != ?", [NSNumber numberWithInteger:SPHWDownloadStateFinish]];
                break;
                
            case SPHWDBGetDateOptionAllWaitingData:
                resultSet = [db executeQuery:@"SELECT * FROM t_videoCaches WHERE state = ?", [NSNumber numberWithInteger:SPHWDownloadStateWaiting]];
                break;
                
            default:
                break;
        }
        
        NSMutableArray *tmpArr = [NSMutableArray array];
        while ([resultSet next]) {
            [tmpArr addObject:[[SPHWDownloadModel alloc] initWithFMResultSet:resultSet]];
        }
        array = tmpArr;
    }];
    
    return array;
}

// 更新数据
- (void)updateWithModel:(SPHWDownloadModel *)model option:(SPHWDBUpdateOption)option
{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (option & SPHWDBUpdateOptionState) {
            [self postStateChangeNotificationWithFMDatabase:db model:model];
            [db executeUpdate:@"UPDATE t_videoCaches SET state = ? WHERE url = ?", [NSNumber numberWithInteger:model.state], model.url];
        }
        if (option & SPHWDBUpdateOptionLastStateTime) {
            [db executeUpdate:@"UPDATE t_videoCaches SET lastStateTime = ? WHERE url = ?", [NSNumber numberWithInteger:[SPHWToolBox getTimeStampWithDate:[NSDate date]]], model.url];
        }
        if (option & SPHWDBUpdateOptionResumeData) {
            [db executeUpdate:@"UPDATE t_videoCaches SET resumeData = ? WHERE url = ?", model.resumeData, model.url];
        }
        if (option & SPHWDBUpdateOptionProgressData) {
            [db executeUpdate:@"UPDATE t_videoCaches SET tmpFileSize = ?, totalFileSize = ?, progress = ?, lastSpeedTime = ?, intervalFileSize = ? WHERE url = ?", [NSNumber numberWithInteger:model.tmpFileSize], [NSNumber numberWithFloat:model.totalFileSize], [NSNumber numberWithFloat:model.progress], [NSNumber numberWithDouble:model.lastSpeedTime], [NSNumber numberWithInteger:model.intervalFileSize], model.url];
        }
        if (option & SPHWDBUpdateOptionAllParam) {
            [self postStateChangeNotificationWithFMDatabase:db model:model];
            [db executeUpdate:@"UPDATE t_videoCaches SET resumeData = ?, totalFileSize = ?, tmpFileSize = ?, progress = ?, state = ?, lastSpeedTime = ?, intervalFileSize = ?, lastStateTime = ? WHERE url = ?", model.resumeData, [NSNumber numberWithInteger:model.totalFileSize], [NSNumber numberWithInteger:model.tmpFileSize], [NSNumber numberWithFloat:model.progress], [NSNumber numberWithInteger:model.state], [NSNumber numberWithDouble:model.lastSpeedTime], [NSNumber numberWithInteger:model.intervalFileSize], [NSNumber numberWithInteger:[SPHWToolBox getTimeStampWithDate:[NSDate date]]], model.url];
        }
    }];
}

// 状态变更通知
- (void)postStateChangeNotificationWithFMDatabase:(FMDatabase *)db model:(SPHWDownloadModel *)model
{
    // 原状态
    NSInteger oldState = [db intForQuery:@"SELECT state FROM t_videoCaches WHERE url = ?", model.url];
    if (oldState != model.state && oldState != SPHWDownloadStateFinish) {
        // 状态变更通知
        [[NSNotificationCenter defaultCenter] postNotificationName:SPHWDownloadStateChangeNotification object:model];
    }
}

// 删除数据
- (void)deleteModelWithUrl:(NSString *)url
{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:@"DELETE FROM t_videoCaches WHERE url = ?", url];
        if (result) {
//            NSLog(@"删除成功：%@", url);
        }else {
//            NSLog(@"删除失败：%@", url);
        }
    }];
}

@end
