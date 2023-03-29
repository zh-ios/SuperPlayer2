//
//  BaseTableView.m
//  FMProject
//
//  Created by zh on 2019/2/12.
//  Copyright © 2019 xiaomi. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView



- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        if (@available(iOS 11.0, *)) {
            self.estimatedSectionFooterHeight = 0.0;
            self.estimatedSectionHeaderHeight = 0.0;
        }
        self.backgroundColor = [UIColor whiteColor];
        self.separatorStyle =  UITableViewCellSeparatorStyleNone;
    }
    return self;
}
@end
