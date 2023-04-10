//
//  SPCommonSettingCell.m
//  FMhatProject
//
//  Created by zhxxxx  ondfasd 2018/7/3.
//  Copyright © 2018年 xiaomi. All rights reserved.
//

#import "SPCommonSettingCell.h"
#import "SPSettingCellContainerView.h"
@interface SPCommonSettingCell ()

@property (nonatomic, strong) SPSettingCellContainerView *containerView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) CGFloat selfWidth;

@end

@implementation SPCommonSettingCell

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self initSubviews];
//    }
//    return self;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellWidth:(CGFloat)width {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.width = width;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    // width 取屏幕宽，这个是拿到的width是320,高44。
    self.containerView = [[SPSettingCellContainerView alloc] initWithFrame:CGRectMake(0, 0, self.width, 52)];
    [self.contentView addSubview:self.containerView];
    
    UIView *selectedBgView = [[SPBaseView alloc] initWithFrame:self.bounds];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    
    self.selectedBackgroundView = selectedBgView;
    self.multipleSelectionBackgroundView = selectedBgView;
    
//    self.lineView = [[SPBaseView alloc] init];
//    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
//    [self.contentView addSubview:self.lineView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.lineView.frame = CGRectMake(17.5, self.height-0.5, self.width-17.5, 0.5);
}

- (void)setItem:(SPCellItem *)item {
    _item = item;
    self.containerView.item = item;
}

@end
