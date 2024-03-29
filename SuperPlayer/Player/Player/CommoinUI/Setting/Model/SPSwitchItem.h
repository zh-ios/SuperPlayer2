//
//  XTSwitchItem.h
//  FMhatProject
//
//  Created by zhxxxx  ondfasd 2018/7/3.
//  Copyright © 2023 zhsxx. All rights reserved.
//  右侧是开关的cell模型

#import "SPCellItem.h"
NS_ASSUME_NONNULL_BEGIN
@interface SPSwitchItem : SPCellItem


/**
 开关的状态
 */
@property (nonatomic, assign) BOOL switchOn;
// 开关是否可以点击
@property (nonatomic, assign) BOOL switchEnabled;

// 隐藏开关
@property (nonatomic, assign) BOOL hidden;

/**
 @param icon cell的图片，没有传nil或者@“”
 @param title cell的标题
 @return cell对应的模型对象
 */
+ (instancetype)itemWithIcon:(nullable NSString *)icon
                       title:(NSString *)title;


/**
 @param icon cell的图片，没有传nil或者@“”
 @param title cell的标题
 @param subTitle cell子标题，详细描述
 @return cell对应的模型
 */
+ (instancetype)itemWithIcon:(nullable NSString *)icon
                       title:(NSString *)title
                    subTitle:(nullable NSString *)subTitle;

@end
NS_ASSUME_NONNULL_END
