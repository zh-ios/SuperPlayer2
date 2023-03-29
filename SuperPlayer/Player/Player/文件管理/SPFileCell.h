//
//  SPFileCell.h
//  Player
//
//  Created by hz on 2021/11/10.
//

#import "SPTableViewCell.h"
#import "SPFilesModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SPFileCell : SPTableViewCell

@property (nonatomic, strong) UIButton *operateBtn;


- (void)updateCellWithFileModel:(SPFilesModel *)model;

@property (nonatomic, copy) void (^operateBtnOnClicked)(SPFilesModel *model, UIButton *btn);

@end

NS_ASSUME_NONNULL_END
