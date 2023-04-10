//
//  SPBaseSettingController.m
//  FMhatProject
//
//  Created by zhxxxx  ondfasd 2018/7/3.
//  Copyright © 2018年 xiaomi. All rights reserved.
//

#import "SPBaseSettingController.h"
#import "SPCommonSettingCell.h"
//#import "FMRouter.h"

@interface SPBaseSettingController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation SPBaseSettingController

static NSString *const cellId = @"xccommonsetttingcellid";

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavbarHeight, self.view.width, self.view.height-kNavbarHeight-kBottomSafeArea) style:UITableViewStyleGrouped];
        _tableView.rowHeight = 50;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 设置没有分割线
//        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.separatorColor = kSeparatorLineColor;
    }
    return _tableView;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
}

- (void)setTableFooterView:(UIView *)tableFooterView {
    _tableFooterView = tableFooterView;
    self.tableView.tableFooterView = tableFooterView;
}

- (void)setTableHeaderView:(UIView *)tableHeaderView {
    _tableHeaderView = tableHeaderView;
    self.tableView.tableHeaderView = tableHeaderView;
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SPCellGroupItem *group = self.groupItems[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPCommonSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SPCommonSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId cellWidth:tableView.width];
    }
    SPCellGroupItem *group = self.groupItems[indexPath.section];
    SPCellItem *item = group.items[indexPath.row];
    cell.item = item;
    // 如果不是箭头类型，则不需要选中效果
    if (![item isKindOfClass:[SPArrowItem class]]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    SPCellGroupItem *group = self.groupItems[section];
    return group.footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SPCellGroupItem *group = self.groupItems[section];
    return group.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    SPCellGroupItem *group = self.groupItems[section];
    if (group.footerView) {
        return group.footerView.height;
    } else {
        // 不能设置为0 否则在10的系统上会有默认间距
        return 0.1;
    }
}
    
// FIXME ; header 暂未设置 ！！！
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SPCellGroupItem *group = self.groupItems[section];
    if (group.headerView) {
        return group.headerView.height;
    } else {
        // 不能设置为0 否则在10的系统上会有默认间距
        return 0.1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SPCellGroupItem *group = self.groupItems[indexPath.section];
    SPCellItem *item = group.items[indexPath.row];
    // 如果是箭头类型的,并且没有自己实现block ，进行跳转 。
    if ([item isKindOfClass:[SPArrowItem class]]&&!item.onClicked) {
        SPArrowItem *arrowItem = (SPArrowItem *)item;
        Class cls = NSClassFromString(arrowItem.targetClass);
        UIViewController *baseVC = [[cls alloc] init];
        if (arrowItem.targetClass&&arrowItem.targetClass.length>0) {
//            [[FMRouter sharedInstance] jumpByPath:arrowItem.targetClass isHiddenTabBar:YES];
            [self.navigationController pushViewController:baseVC animated:YES];
        }
    }
    // 如果实现了block，自己去实现跳转逻辑 。
    if (([item isKindOfClass:[SPArrowItem class]]||[item isKindOfClass:[SPLabelItem class]])&&item.onClicked) {
        item.onClicked(item, nil);
    }
}


- (void)dealloc {
    
}

@end
