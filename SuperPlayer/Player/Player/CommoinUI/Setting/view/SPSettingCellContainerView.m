//
//  SPSettingCellContainerView.m
//  FMhatProject
//
//  Created by zhxxxx  ondfasd 2018/7/3.
//  Copyright © 2023 zhsxx. All rights reserved.
//

#import "SPSettingCellContainerView.h"
#import "SPArrowItem.h"
#import "SPSwitchItem.h"
#import "SPLabelItem.h"

#define kSettingCellImgW 25
#define kSettingCellImgH kSettingCellImgW

#define kSettingCellPaddingLeft  16 //图片距离左边的距离

#define kSettingCellArrowW 17 //尖括号的宽度10
#define kSettingCellArrowH 22 //夹括号的高度 15

#define kSettingCellAsseoryLabelW 100
#define kSettingCellAsseoryLabelH  30

#define kSettingCellTitleFont                   (15)
#define kSettingCellSubTitleFont                (12)
#define kSettingCellAccessoryLabelFont          (12)

@interface SPSettingCellContainerView ()

@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *subTitleL;

/**
 右侧的label
 */
@property (nonatomic, strong) UILabel *accessoryL;
@property (nonatomic, strong) UIImageView *arrowImage;
@property (nonatomic, strong) UISwitch *switchView;

/**
  新消息提示
 */
@property (nonatomic, strong) UILabel *updateMsgL;

@end


@implementation SPSettingCellContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.img = [[UIImageView alloc] init];
    [self addSubview:self.img];
    self.img.hidden = YES;
    self.img.contentMode = UIViewContentModeScaleAspectFit;
    
    self.titleL = [[SPBaseLabel alloc] init];
    self.titleL.font = [UIFont systemFontOfSize:kSettingCellTitleFont];
    self.titleL.textColor = RGB(34, 34, 34);
    [self addSubview:self.titleL];
    
    // 默认隐藏
    self.subTitleL = [[SPBaseLabel alloc] init];
    self.subTitleL.hidden = YES;
    self.subTitleL.font = [UIFont systemFontOfSize:kSettingCellSubTitleFont];
    self.subTitleL.textColor = RGB(153, 153, 153);
    [self addSubview:self.subTitleL];
    
    // 默认隐藏
    self.accessoryL = [[SPBaseLabel alloc] init];
    self.accessoryL.hidden = YES;
    self.accessoryL.userInteractionEnabled = YES;
    self.accessoryL.font = [UIFont systemFontOfSize:kSettingCellSubTitleFont];
    self.accessoryL.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.accessoryL];
    
    
    self.updateMsgL = [[SPBaseLabel alloc] init];
    self.updateMsgL.text = @"new";
    self.updateMsgL.hidden = YES;
    self.updateMsgL.font = [UIFont systemFontOfSize:10];
    self.updateMsgL.textColor = [UIColor whiteColor];
    self.updateMsgL.backgroundColor = [UIColor redColor];
    self.updateMsgL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.updateMsgL];
    
    self.arrowImage = [[UIImageView alloc] init];
    self.arrowImage.hidden = YES;
    self.arrowImage.image = [UIImage imageNamed:@"sp_icon_right_arrow"];
    [self addSubview:self.arrowImage];
    self.arrowImage.contentMode = UIViewContentModeScaleAspectFit;
    
    // 默认隐藏
    self.switchView = [[UISwitch alloc] init];
    self.switchView.hidden = YES;
    self.switchView.onTintColor = kTextHighlightColor;
    [self.switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.switchView];
}

- (void)setItem:(SPCellItem *)item {
    _item = item;
    CGFloat titleLX = 0;
    if (item.icon&&item.icon.length>0) {
        self.img.hidden = NO;
        self.img.image = [UIImage imageNamed:item.icon];
        self.img.frame = CGRectMake(kSettingCellPaddingLeft,
                                    (self.height-kSettingCellImgH)*0.5,
                                    kSettingCellImgW,
                                    kSettingCellImgH);
        titleLX = CGRectGetMaxX(self.img.frame) + kSettingCellPaddingLeft;
    } else {
        // 重置img的frame 解决重用问题
        self.img.hidden = YES;
        self.img.frame = CGRectZero;
        titleLX = CGRectGetMaxX(self.img.frame) + 10;
    }
    
    // TODO 如果文字过长，需要设置label的最大长度
    CGSize titleSize = [item.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kSettingCellTitleFont]}];
    self.titleL.frame = CGRectMake(titleLX, (self.height-titleSize.height)*0.5, titleSize.width+2, titleSize.height);
    self.titleL.text = item.title;
    
    if (item.subTitle&&item.subTitle.length>0) {
        self.subTitleL.hidden = NO;
        CGSize subTitleSize = [item.subTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kSettingCellSubTitleFont]}];;
        self.subTitleL.frame = CGRectMake(CGRectGetMaxX(self.titleL.frame)+8,
                                          (self.height-subTitleSize.height)*0.5,
                                          subTitleSize.width,
                                          subTitleSize.height);
        self.subTitleL.text = item.subTitle;
    } else {
        self.subTitleL.hidden = YES;
        self.subTitleL.frame = CGRectZero;
    }
    
    [self setRightView];
}

- (void)setRightView {
    // 箭头
    CGFloat rightPadding = 20;
    if ([self.item isKindOfClass:[SPArrowItem class]]) {
        [self setViewShow:self.arrowImage];
        SPArrowItem *item = (SPArrowItem *)self.item;
        self.arrowImage.frame = CGRectMake(self.width-kSettingCellArrowW-rightPadding,
                                           (self.height-kSettingCellArrowH)*0.5,
                                           kSettingCellArrowW,
                                           kSettingCellArrowH);
        // 升级提示按钮
        self.updateMsgL.hidden = !item.showNewTips;
        if (!self.updateMsgL.hidden) {
            self.updateMsgL.frame = CGRectMake(self.arrowImage.left-28, (self.height-16)*0.5, 28, 16);
            self.updateMsgL.layer.cornerRadius = self.updateMsgL.height*0.5;
            self.updateMsgL.layer.masksToBounds = YES;
        }
        
        if (item.hideArrowImageView) {
            self.arrowImage.hidden = YES;
        } else {
            self.arrowImage.hidden = NO;
        }
        
    // 开关
    } else if ([self.item isKindOfClass:[SPSwitchItem class]]) {
        [self setViewShow:self.switchView];
        SPSwitchItem *item = (SPSwitchItem *)self.item;
        self.switchView.userInteractionEnabled = item.switchEnabled;
        self.switchView.on = item.switchOn;
        self.switchView.hidden = item.hidden;
        self.switchView.frame = CGRectMake(self.width-rightPadding-42,
                                           (self.height-self.switchView.height)*0.5,
                                           self.switchView.width,
                                           self.switchView.height);

        
    } else if ([self.item isKindOfClass:[SPLabelItem class]]) {
        [self setViewShow:self.accessoryL];
        SPLabelItem *item = (SPLabelItem *)self.item;
        CGSize acSize = [item.accessoryDesc sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kSettingCellAccessoryLabelFont]}];
        self.accessoryL.frame = CGRectMake(self.width-rightPadding-acSize.width,
                                           (self.height-acSize.height)*0.5,
                                           acSize.width,
                                           acSize.height);
        self.accessoryL.text = item.accessoryDesc;
        if (item.textColor) {
            self.accessoryL.textColor = item.textColor;
        } else {
            self.accessoryL.textColor = RGB(153, 153, 153);
        }
//        if (self.item.onClicked) { // 如果实现了block 说明有点击事件，需要添加一个手势
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accessoryLOnClick)];
//            [self.accessoryL addGestureRecognizer:tap];
//            [self.accessoryL setExtendedHitArea:CGRectMake(10, 10, 20, 10)];
//        }
    }
}


/**
 展示右边的视图，隐藏其他视图

 @param view 要展示view
 */
- (void)setViewShow:(UIView *)view {
    self.switchView.hidden =  self.switchView == view ? NO : YES;
    self.accessoryL.hidden =  self.accessoryL == view ? NO : YES;
    self.arrowImage.hidden =  self.arrowImage == view ? NO : YES;
}

- (void)switchChanged:(BOOL)on {
    SPSwitchItem *item = (SPSwitchItem *)self.item;
//    item.switchOn = !item.switchOn;
//    [self.switchView didChangeSwitchValue];
//    self.switchView.on = item.switchOn;
    if (self.item.onClicked) {
        self.item.onClicked(item, self.switchView);
    }
}

- (void)accessoryLOnClick {
    if (self.item.onClicked) {
        SPLabelItem *item = (SPLabelItem *)self.item;
        self.item.onClicked(item, nil);
    }
}

@end
