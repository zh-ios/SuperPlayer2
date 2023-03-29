//
//  XTLabelItem.m
//  FMhatProject
//
//  Created by zh on 2018/7/3.
//  Copyright © 2018年 xiaomi. All rights reserved.
//

#import "SPLabelItem.h"

@implementation SPLabelItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle accessoryDesc:(NSString *)desc {
    SPLabelItem *item = [[SPLabelItem alloc] init];
    item.icon = icon;
    item.title = title;
    item.subTitle = subTitle;
    item.accessoryDesc = desc;
    return item;
}

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title desc:(NSString *)desc {
    return [self itemWithIcon:icon title:title subTitle:nil accessoryDesc:desc];
}

@end
