//
//  SPCommonSettingCell.h
//  FMhatProject
//
//  Created by zh on 2018/7/3.
//  Copyright © 2018年 xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@class SPCellItem;

@interface SPCommonSettingCell : BaseTableViewCell

@property (nonatomic, strong) SPCellItem *item;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellWidth:(CGFloat)width;

@end
