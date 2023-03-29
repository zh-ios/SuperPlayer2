//
//  ZHDownloadCell.h
//  Player
//
//  Created by zhuhao on 2022/10/14.
//

#import "BaseTableViewCell.h"
#import "HWDownloadModel.h"
@class ZHDownloadCell;
NS_ASSUME_NONNULL_BEGIN

@interface ZHDownloadCell : BaseTableViewCell

- (void)updateUIWithModel:(HWDownloadModel *)model;

@property (nonatomic, copy) void (^downloadBtnOnClickBlock)(UIButton *downloadBtn, ZHDownloadCell *cell ,HWDownloadModel *model);

@end

NS_ASSUME_NONNULL_END
