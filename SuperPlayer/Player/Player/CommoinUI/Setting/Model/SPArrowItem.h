//
//  XTArrowItem.h
//  FMhatProject
//
//  Created by zhxxxx  ondfasd 2018/7/3.
//  Copyright © 2023 zhsxx. All rights reserved.
//  右侧带有箭头的cell，这种一般都是跳转页面

#import "SPCellItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPArrowItem : SPCellItem


/**
  要跳转的类名字
 */
@property (nonatomic, copy, nullable) NSString *targetClass;

/**
  是否显示 （new） 提示 ，new 提示和subtitle UI上存在冲突，没有处理。
 */
@property (nonatomic, assign) BOOL showNewTips;

// 隐藏右箭头
@property (nonatomic, assign) BOOL hideArrowImageView;

/**
 @param cls 要跳转目标控制器名字
 */
+ (instancetype)itemWithIcon:(nullable NSString *)icon
                       title:(NSString *)title
                    subTitle:(nullable NSString *)subTitle
                    targetCls:(nullable NSString *)cls;


+ (instancetype)itemWithIcon:(nullable NSString *)icon
                       title:(NSString *)title
                    targetCls:(nullable NSString *)cls;
@end

NS_ASSUME_NONNULL_END
