//
//  SPBaseSettingController.h
//  FMhatProject
//
//  Created by zh on 2018/7/3.
//  Copyright © 2018年 xiaomi. All rights reserved.
//

#import "SPBaseSettingController.h"
#import "SPArrowItem.h"
#import "SPSwitchItem.h"
#import "SPLabelItem.h"
#import "SPCellGroupItem.h"
#import "SPBaseController.h"

@interface SPBaseSettingController : SPBaseController

@property (nonatomic, strong) UITableView *tableView;

// SPCellGroupItem 对象集合
@property (nonatomic, strong) NSArray<SPCellGroupItem *> *groupItems;

@property (nonatomic, strong) UIView *tableHeaderView;

@property (nonatomic, strong) UIView *tableFooterView;

- (void)reloadData;

@property (nonatomic, assign, getter=isShowLogout) BOOL showLogout;
    
@end
