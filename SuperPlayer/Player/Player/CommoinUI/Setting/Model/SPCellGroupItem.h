//
//  XTCellGroupItem.h
//  FMhatProject
//
//  Created by zhxxxx  ondfasd 2018/7/3.
//  Copyright © 2018年 xiaomi. All rights reserved.
//  tableView 分组模型

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@class SPCellItem;

@interface SPCellGroupItem : NSObject

// header和footer可以支持点击
@property (nonatomic, strong, nullable) UIView *headerView;
@property (nonatomic, strong, nullable) UIView *footerView;

// 不用支持点击
//@property (nonatomic, copy) NSString *headerStr;
//@property (nonatomic, copy) NSString *footerStr;

@property (nonatomic, strong) NSArray<SPCellItem *> *items;

+ (instancetype)itemWithItems:(NSArray<SPCellItem *> *)items;
    
@end
NS_ASSUME_NONNULL_END
