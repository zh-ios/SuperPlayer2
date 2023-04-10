//
//  SPBaseTableView.m
//  FMProject
//
//  Created by zhxxxx  ondfasd 2019/2/12.
//  Copyright © 2019 zz  ll rights reserved..
//

#import "SPBaseTableView.h"

@implementation SPBaseTableView



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
