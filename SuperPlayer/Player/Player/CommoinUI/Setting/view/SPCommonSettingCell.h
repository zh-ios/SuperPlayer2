//
//  SPCommonSettingCell.h
//  FMhatProject
//
//  Created by zhxxxx  ondfasd 2018/7/3.
//  Copyright © 2023 zhsxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPBaseTableViewCell.h"
@class SPCellItem;

@interface SPCommonSettingCell : SPBaseTableViewCell

@property (nonatomic, strong) SPCellItem *item;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellWidth:(CGFloat)width;

@end
