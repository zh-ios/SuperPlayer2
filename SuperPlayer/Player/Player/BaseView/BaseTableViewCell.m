//
//  BaseTableViewCell.m
//  FMProject
//
//  Created by zh on 2019/2/12.
//  Copyright © 2019 xiaomi. All rights reserved.
//

#import "BaseTableViewCell.h"



@implementation BaseTableViewCell {
    UILabel *_lineLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *selectedBgView = [[BaseView alloc] initWithFrame:self.bounds];
        selectedBgView.userInteractionEnabled = NO;
        selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        self.selectedBackgroundView = selectedBgView;
        self.multipleSelectionBackgroundView = selectedBgView;
        _lineLabel = [[BaseLabel alloc] init];
        [self.contentView addSubview:_lineLabel];
        _lineLabel.backgroundColor = kSeparatorLineColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _lineLabel.frame = CGRectMake(15, self.height-onePixel, kScreenWidth-15*2, onePixel);
}

@end
