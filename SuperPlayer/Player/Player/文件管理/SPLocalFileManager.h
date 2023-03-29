//
//  SPLocalFileManager.h
//  Player
//
//  Created by hz on 2021/11/10.
//

#import <Foundation/Foundation.h>
#import "SPFilesModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface SPLocalFileManager : NSObject

+ (instancetype)sharedManager;

- (NSString *)getDocumentPath;
//
- (NSString *)getGlobalFilePath;
// 获取加密文件夹路径
- (NSString *)getLockedFilePath;

/// 创建文件夹
- (BOOL)createFolders:(NSString *)folderName;

/// 获取本地所有文件，非加密的（包括文件和文件夹）
- (NSArray <SPFilesModel *> *)getLocalFiles;

// 获取本所有加密后的文件，（包括文件和文件夹）
- (NSArray <SPFilesModel *> *)getLocalLockedFiles;


// 获取本地所有文件夹
- (NSArray <SPFilesModel *> *)getLocalFolders;

// 获取加密文件夹
- (NSArray <SPFilesModel *> *)getLockedFolders;


/// 重命名文件
/// @param name name
/// @param path 文件路径
- (BOOL)reNameFoldersWithName:(NSString *)name folderPath:(NSString *)path;

// 删除文件夹，同时删除文件夹下所有文件
- (BOOL)deleteFolders:(NSString *)folderPath;


/// 获取folder下所有文件 ,是否过滤文件（只保留文件夹）
- (NSArray <SPFilesModel *> *)getFilesInFolder:(NSString *)folderPath fliterFiles:(BOOL)f;

- (BOOL)deleteFile:(NSString *)filePath;

// 批量删除文件
- (BOOL)deleteFiles:(NSArray <NSString *> *)filePaths;


/// 判断本地是否有同名文件夹
- (BOOL)hasSameNameFolders:(NSString *)folderName folderPath:(NSString *)folderPath;

// 文件夹下是否有同名文件
- (BOOL)hasSameNameFile:(NSString *)fileName folderPath:(NSString *)folderPath;


/// 移动文件到另一个路径下
/// @param sourcePath 源文件全路径
/// @param path 目标全路径
- (BOOL)moveFileFromPath:(NSString *)sourcePath toPath:(NSString *)path;


/// 拷贝文件
/// @param sourcePath 源文件全路径
/// @param targetPath 目标文件夹
- (void)copyFileFromPath:(NSString *)sourcePath toPath:(NSString *)targetPath;

// 获取加密视频总数量
- (NSInteger)getLockedFilesCount;

// 获取下载视频的路径
- (NSString *)getDownloadPath;

@end

NS_ASSUME_NONNULL_END
