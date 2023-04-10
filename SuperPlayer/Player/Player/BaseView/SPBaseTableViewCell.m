//
//  SPBaseTableViewCell.m
//  FMProject
//
//  Created by zhxxxx  ondfasd 2019/2/12.
//  Copyright © 2019 zz  ll rights reserved..
//

#import "SPBaseTableViewCell.h"



@implementation SPBaseTableViewCell {
    UILabel *_lineLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *selectedBgView = [[SPBaseView alloc] initWithFrame:self.bounds];
        selectedBgView.userInteractionEnabled = NO;
        selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        self.selectedBackgroundView = selectedBgView;
        self.multipleSelectionBackgroundView = selectedBgView;
        _lineLabel = [[SPBaseLabel alloc] init];
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
