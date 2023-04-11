//
//  XTSwitchItem.m
//  FMhatProject
//
//  Created by zhxxxx  ondfasd 2018/7/3.
//  Copyright © 2023 zhsxx. All rights reserved.
//

#import "SPSwitchItem.h"

@implementation SPSwitchItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle {
    SPSwitchItem *item = [[SPSwitchItem alloc] init];
    item.icon = icon;
    item.title = title;
    item.subTitle = subTitle;
    item.switchEnabled = YES;
    return item;
}

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title {
    return [self itemWithIcon:icon title:title subTitle:nil];
}

@end
