//
//  SPHWDownloadManager.h
//  SPHWProject
//
//  Created by wangqibin on 2018/4/24.
//  Copyright © 2018年 wangqibin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SPHWDownloadModel.h"


@interface SPHWDownloadManager : NSObject

// 初始化下载单例，若之前程序杀死时有正在下的任务，会自动恢复下载
+ (instancetype)shareManager;

// 开始下载
- (void)startDownloadTask:(SPHWDownloadModel *)model;

// 暂停下载
- (void)pauseDownloadTask:(SPHWDownloadModel *)model;

// 删除下载任务及本地缓存
- (void)deleteTaskAndCache:(SPHWDownloadModel *)model;

@end
