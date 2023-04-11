//
//  XTCellGroupItem.m
//  FMhatProject
//
//  Created by zhxxxx  ondfasd 2018/7/3.
//  Copyright © 2023 zhsxx. All rights reserved.
//

#import "SPCellGroupItem.h"

@implementation SPCellGroupItem
    
    
+ (instancetype)itemWithItems:(NSArray<SPCellItem *> *)items {
    SPCellGroupItem *item = [[SPCellGroupItem alloc] init];
    item.items = items;
    return item;
}

@end
