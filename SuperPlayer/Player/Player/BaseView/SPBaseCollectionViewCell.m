//
//  SPBaseCollectionViewCell.m
//  FMProject
//
//  Created by liuaihuan on 2019/4/24.
//  Copyright © 2019年 xiaomi. All rights reserved.
//

#import "SPBaseCollectionViewCell.h"

@implementation SPBaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *selectedBgView = [[SPBaseView alloc] initWithFrame:self.bounds];
        selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        self.selectedBackgroundView = selectedBgView;
    }
    return self;
}

@end
