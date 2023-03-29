//
//  ZHNavigationBar.m
//  ZHProject
//
//  Created by zh on 2018/7/26.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHNavigationBar.h"
#import "UIView+gradient.h"
#import "UIView+ExtendHitArea.h"
#import "AXWebViewController.h"

@interface ZHNavigationBar ()

@property (nonatomic, strong) AXWebViewController *webVC;

@end

@implementation ZHNavigationBar


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:imageView];
    UIImage *image = [UIView gradientImageFromColor:nil toColor:nil size:CGSizeMake(kScreenWidth, kNavbarHeight)];
    imageView.image = image;
    self.backgroundImageView = imageView;
    
    
    UILabel *titleL = [[BaseLabel alloc] initWithFrame:CGRectMake(80, kTopSafeArea + 10, self.frame.size.width-80*2, 20)];
    titleL.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    self.titleL = titleL;
    self.titleL.textAlignment = NSTextAlignmentCenter;
    self.titleL.textColor = [UIColor whiteColor];
    [self addSubview:titleL];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kTopSafeArea+10, 80, 30)];
    [self addSubview:backBtn];
    self.backBtn = backBtn;
    [backBtn setImage:[UIImage imageNamed:@"sp_icon_back"] forState:UIControlStateNormal];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    backBtn.adjustsImageWhenHighlighted = NO;
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn extendHitAreaTop:20 left:20 bottom:20 right:20];
    
    self.bottomLine = [[BaseView alloc] initWithFrame:CGRectMake(0, self.height-onePixel, self.width, onePixel)];
    self.bottomLine.backgroundColor = kSeparatorLineColor;
    [self addSubview:self.bottomLine];
    self.bottomLine.hidden = YES;
}
- (void)back:(UIButton *)btn {
    if (self.backOnClick) {
        self.backOnClick(btn);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleL.y = kTopSafeArea + 10;
}

@end