//
//  SPHWDataBaseManager.h
//  SPHWProject
//
//  Created by wangqibin on 2018/4/25.
//  Copyright © 2018年 wangqibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPHWDownloadModel.h"

typedef NS_OPTIONS(NSUInteger, SPHWDBUpdateOption) {
    SPHWDBUpdateOptionState         = 1 << 0,  // 更新状态
    SPHWDBUpdateOptionLastStateTime = 1 << 1,  // 更新状态最后改变的时间
    SPHWDBUpdateOptionResumeData    = 1 << 2,  // 更新下载的数据
    SPHWDBUpdateOptionProgressData  = 1 << 3,  // 更新进度数据（包含tmpFileSize、totalFileSize、progress、intervalFileSize、lastSpeedTime）
    SPHWDBUpdateOptionAllParam      = 1 << 4   // 更新全部数据
};

@interface SPHWDataBaseManager : NSObject

// 获取单例
+ (instancetype)shareManager;

// 插入数据
- (void)insertModel:(SPHWDownloadModel *)model;

// 获取数据
- (SPHWDownloadModel *)getModelWithUrl:(NSString *)url;    // 根据url获取数据
- (SPHWDownloadModel *)getWaitingModel;                    // 获取第一条等待的数据
- (SPHWDownloadModel *)getLastDownloadingModel;            // 获取最后一条正在下载的数据
- (NSArray<SPHWDownloadModel *> *)getAllCacheData;         // 获取所有数据
- (NSArray<SPHWDownloadModel *> *)getAllDownloadingData;   // 根据lastStateTime倒叙获取所有正在下载的数据
- (NSArray<SPHWDownloadModel *> *)getAllDownloadedData;    // 获取所有下载完成的数据
- (NSArray<SPHWDownloadModel *> *)getAllUnDownloadedData;  // 获取所有未下载完成的数据（包含正在下载、等待、暂停、错误）
- (NSArray<SPHWDownloadModel *> *)getAllWaitingData;       // 获取所有等待下载的数据

// 更新数据
- (void)updateWithModel:(SPHWDownloadModel *)model option:(SPHWDBUpdateOption)option;

// 删除数据
- (void)deleteModelWithUrl:(NSString *)url;

@end
