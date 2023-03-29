//
//  XTArrowItem.m
//  FMhatProject
//
//  Created by zh on 2018/7/3.
//  Copyright © 2018年 xiaomi. All rights reserved.
//

#import "SPArrowItem.h"

@implementation SPArrowItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title
                    subTitle:(NSString *)subTitle targetCls:(NSString *)cls {
    SPArrowItem *item = [[SPArrowItem alloc] init];
    item.targetClass = cls;
    item.icon = icon;
    item.title = title;
    item.subTitle = subTitle;
    return item;
}

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title targetCls:(NSString *)cls {
    return [self itemWithIcon:icon title:title subTitle:nil targetCls:cls];
}

@end
