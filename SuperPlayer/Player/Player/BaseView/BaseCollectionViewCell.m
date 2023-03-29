//
//  BaseCollectionViewCell.m
//  FMProject
//
//  Created by liuaihuan on 2019/4/24.
//  Copyright © 2019年 xiaomi. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *selectedBgView = [[BaseView alloc] initWithFrame:self.bounds];
        selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        self.selectedBackgroundView = selectedBgView;
    }
    return self;
}

@end
