//
//  SPAllLocalFoldersController.h
//  Player
//
//  Created by hz on 2021/11/15.
//  文件夹选择页面，将文件放入文件夹

#import "SPBaseController.h"
#import "SPFilesModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface SPAllLocalFoldersController : SPBaseController

@property (nonatomic, strong) SPFilesModel *model;

@end

NS_ASSUME_NONNULL_END
