//
//  SPLocalFileManager.m
//  Player
//
//  Created by hz on 2021/11/10.
//

#import "SPLocalFileManager.h"

@interface SPLocalFileManager ()

@property (nonatomic, strong) NSMutableArray *files;

@end

@implementation SPLocalFileManager

static SPLocalFileManager *_mgr = nil;

static NSString *global_folderPath = @"";
static NSString *locked_folderPath = @"";
static NSString *global_folderName = @"localfolders";
static NSString *global_lock_folderName = @"lockfolders";

+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_mgr) {
            _mgr = [[self alloc] init];
            // 创建存储文件夹的总文件夹
            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            NSString *fPath = [docPath stringByAppendingPathComponent:global_folderName];
            global_folderPath = fPath;
            
            NSString *lockPath = [docPath stringByAppendingPathComponent:global_lock_folderName];
            locked_folderPath = lockPath;
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:fPath]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:fPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            if (![[NSFileManager defaultManager] fileExistsAtPath:lockPath]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:lockPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
    });
    return _mgr;
}

- (NSString *)getDocumentPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSString *)getGlobalFilePath {
    return global_folderPath;
}

- (NSString *)getLockedFilePath {
    return locked_folderPath;
}

- (NSMutableArray *)files {
    if (!_files) {
        _files = @[].mutableCopy;
    }
    return _files;
}

- (NSArray<SPFilesModel *> *)getLocalFiles {
    return [self getFilesInFolder:global_folderPath fliterFiles:NO];
}

- (NSArray<SPFilesModel *> *)getLocalFolders {
    return [self getFilesInFolder:global_folderPath fliterFiles:YES];
}

-  (NSArray<SPFilesModel *> *)getLockedFolders {
    NSArray *arr = [self getFilesInFolder:locked_folderPath fliterFiles:YES];
    for (SPFilesModel *f in arr) {
        f.isLocked = YES;
    }
    return arr;
}

- (NSArray<SPFilesModel *> *)getLocalLockedFiles {
    NSArray *arr = [self getFilesInFolder:locked_folderPath fliterFiles:NO];
    for (SPFilesModel *f in arr) {
        f.isLocked = YES;
    }
    return arr;
}

- (NSArray<SPFilesModel *> *)getFilesInFolder:(NSString *)folderPath fliterFiles:(BOOL)f{
    NSMutableArray *datas = @[].mutableCopy;
    NSArray *subP = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
    for (NSString *p in subP) {
        // 如果不是直接路径ruturn ，例如 xx/xxx.mp4这种
        if ([p containsString:@"/"]) continue;
        SPFilesModel *m = [[SPFilesModel alloc] init];
        m.name = p;
        NSString *fullPath = [folderPath stringByAppendingPathComponent:p];
        m.fullPath = fullPath;
        BOOL isFolder = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isFolder];
        if (f&&!isFolder) {
            continue;
        }
        m.isFolder = isFolder;
        if (m.isFolder) {
            m.fileSize = [self folderSizeAtPath:fullPath];
            m.filesCount = [[[NSFileManager defaultManager] subpathsAtPath:fullPath] count];
        } else {
            m.fileSize = [self fileSizeAtPath:fullPath];
        }
        m.createDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil] fileCreationDate];
        [datas addObject:m];
    }
    
    NSArray *marr = [[datas copy] sortedArrayUsingComparator:^NSComparisonResult(SPFilesModel *obj1, SPFilesModel *obj2) {
        return obj1.createTs>obj2.createTs;
    }];
    
    return marr;
}

- (long long)fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (long long)folderSizeAtPath:(NSString *)folderpath {
    long long totalSize = 0;
    for (NSString *subP in [[NSFileManager defaultManager] subpathsAtPath:folderpath]) {
        NSString *subFiles = [folderpath stringByAppendingPathComponent:subP];
        totalSize += [self fileSizeAtPath:subFiles];
    }
    return totalSize;
}


- (BOOL)createFolders:(NSString *)folderName {
    if ([folderName containsString:@"/"]) {
        [SPToastUtil showToast:kZHLocalizedString(@"包含非法字符\")/\"")];
        return NO;
    }
    NSString *folderPath = [global_folderPath stringByAppendingPathComponent:folderName];
    [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    return YES;
}

- (BOOL)reNameFoldersWithName:(NSString *)name folderPath:(NSString *)path {
    
    NSString *targetPath = @"";
    NSString *pathExt = [path pathExtension];
    // 上一层级目录
    NSString *upperFolder = [path stringByReplacingOccurrencesOfString:[[path componentsSeparatedByString:@"/"] lastObject] withString:@""];
    
    targetPath = [upperFolder stringByAppendingPathComponent:name];

    targetPath = [targetPath stringByAppendingPathExtension:pathExt];
    
    [[NSFileManager defaultManager] moveItemAtPath:path toPath:targetPath error:nil];
    return YES;
}

- (BOOL)deleteFolders:(NSString *)folderPath {
    
    NSArray *subPaths = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
    for (NSString *s in subPaths) {
        [[NSFileManager defaultManager] removeItemAtPath:s error:nil];
    }
    [[NSFileManager defaultManager] removeItemAtPath:folderPath error:nil];
    return YES;
}

- (BOOL)deleteFile:(NSString *)filePath {
    [self deleteFiles:@[filePath]];
    return YES;
}

- (BOOL)deleteFiles:(NSArray<NSString *> *)filePaths {
    for (NSString *p in filePaths) {
        [[NSFileManager defaultManager] removeItemAtPath:p error:nil];
    }
    return YES;
}

- (BOOL)hasSameNameFolders:(NSString *)folderName folderPath:(NSString *)folderPath {
    NSArray *subFolders = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
    for (NSString *subP in subFolders) {
        BOOL isFolder = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:[folderPath stringByAppendingPathComponent:subP] isDirectory:&isFolder];
        if (isFolder && [subP isEqualToString:folderName]) { // 是目录且重名
            return YES;
        }
    }
    return NO;
}

- (BOOL)hasSameNameFile:(NSString *)fileName folderPath:(nonnull NSString *)folderPath {
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
    for (NSString *subP in files) {
        BOOL isFolder = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:[folderPath stringByAppendingPathComponent:subP] isDirectory:&isFolder];
        // 不是文件夹且重名
        if (!isFolder) {
            if ([[subP stringByDeletingPathExtension] isEqualToString:[fileName stringByDeletingPathExtension]]) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)moveFileFromPath:(NSString *)sourcePath toPath:(NSString *)path {
    
    // 目标文件夹需要加上文件及路径名才行 目标文件夹/文件名.mov
    NSString *fileName = [[sourcePath componentsSeparatedByString:@"/"] lastObject];
    NSString *destFullPath = [NSString stringWithFormat:@"%@/%@",path, fileName];
    
    NSError *e = nil;
    BOOL isD = NO;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:sourcePath isDirectory:&isD];
    if (exist) {
        BOOL ret = [[NSFileManager defaultManager] moveItemAtPath:sourcePath toPath:destFullPath error:&e];
        if (ret) {
            NSLog(kZHLocalizedString(@"上传成功"));
            return YES;
        }
    }
    return NO;
}

- (void)copyFileFromPath:(NSString *)sourcePath toPath:(NSString *)targetPath {
    [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:targetPath error:nil];
}


- (NSInteger)getLockedFilesCount {
    NSArray *arr = [self getLocalLockedFiles];
    NSInteger count = 0;
    for (SPFilesModel *m in arr) {
        if (m.isFolder) {
            count += m.filesCount;
        } else {
            count += 1;
        }
    }
    return count;
}

- (NSString *)getDownloadPath {
    NSString *lbpath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    lbpath = [lbpath stringByAppendingPathComponent:@"downloadedvideos"];
    BOOL isD = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:lbpath isDirectory:&isD];
    if (isD) return lbpath;
    [[NSFileManager defaultManager] createDirectoryAtPath:lbpath withIntermediateDirectories:YES attributes:nil error:nil];
    return lbpath;
}

@end
