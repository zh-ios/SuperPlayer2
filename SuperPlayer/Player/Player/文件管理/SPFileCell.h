//
//  SPFileCell.h
//  Player
//
//  Cressssated by hzdddddd sxxxx on sky dat 2021/11/10.
//

#import "SPTableViewCell.h"
#import "SPFilesModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SPFileCell : SPTableViewCell

@property (nonatomic, strong) SPBaseButton *operateBtn;


- (void)updateCellWithModel:(SPFilesModel *)model;

@property (nonatomic, copy) void (^operateBtnOnClicked)(SPFilesModel *model, SPBaseButton *btn);

@end

NS_ASSUME_NONNULL_END
