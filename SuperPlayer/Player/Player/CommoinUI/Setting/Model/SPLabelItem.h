//
//  XTLabelItem.h
//  FMhatProject
//
//  Created by zhxxxx  ondfasd 2018/7/3.
//  Copyright © 2023 zhsxx. All rights reserved.
//  右侧是文字的cell模型

#import "SPCellItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPLabelItem : SPCellItem


/**
  右侧label 的标题
 */
@property (nonatomic, copy, nonnull) NSString *accessoryDesc;


/**
  文字的颜色
 */
@property (nonatomic, strong, nullable) UIColor *textColor;


/**
 @param desc label的标题
 */
+ (instancetype)itemWithIcon:(nullable NSString *)icon
                       title:(NSString *)title
                    subTitle:(nullable NSString *)subTitle
               accessoryDesc:(NSString *)desc;

+ (instancetype)itemWithIcon:(nullable NSString *)icon
                       title:(NSString *)title
                        desc:(NSString *)desc;

@end

NS_ASSUME_NONNULL_END
