//
//  SPFilesModel.h
//  Player
//
//  Created by hz on 2021/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPFilesModel : NSObject

// 是否是文件夹
@property (nonatomic, assign) BOOL isFolder;

// 名称
@property (nonatomic, copy) NSString *name;
// 完整路径
@property (nonatomic, copy) NSString *fullPath;

// 如果是文件夹 ，里面包括的文件数量
@property (nonatomic, assign) NSInteger filesCount;

// 文件夹大小或者文件大小
@property (nonatomic, assign) long long fileSize;

// 文件大小 ，str类型
@property (nonatomic, copy) NSString *fileSizeStringValue;

@property (nonatomic, assign) long long createTs;

@property (nonatomic, strong) NSDate *createDate;

// 是否是加密的
@property (nonatomic, assign) BOOL isLocked;


//// 记录当前播放进度功能
// 当前播放的总时长
@property (nonatomic, assign) NSTimeInterval currentPlayTs;
// 视频id
@property (nonatomic, copy) NSString *fileId;

@end

NS_ASSUME_NONNULL_END
