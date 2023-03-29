//
//  SPTableViewCell.m
//  ZHProject
//
//  Created by zh on 2018/7/10.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "SPTableViewCell.h"

@interface SPTableViewCell ()
@property (nonatomic, strong) UIView *selectedBgView;
@end

@implementation SPTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [self initWithStyle:style reuseIdentifier:reuseIdentifier cellFrame:CGRectZero]) {
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellFrame:(CGRect)frame {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSplitLine:frame];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    assert("error");
    return [self initWithCoder:aDecoder];
}

- (void)addSplitLine:(CGRect)lineFrame {
    _splitLine = [[BaseView alloc] initWithFrame:CGRectMake(10, lineFrame.size.height-onePixel, kScreenWidth-10, onePixel)];
    _splitLine.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.splitLine];
    
    UIView *backgroundView = [[BaseView alloc] init];
    self.selectedBgView = backgroundView;
    backgroundView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    self.selectedBackgroundView = backgroundView;
    self.multipleSelectionBackgroundView = self.selectedBackgroundView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.selectedBgView.frame = self.bounds;
    _splitLine.y = self.bounds.size.height-0.5;
}

@end
