//
//  SPNavigationBar.m
//  ZHProject
//
//  Created by zhxxxx  ondfasd 2018/7/26.
//  Copyright © 2023 zhsxx. All rights reserved.
//

#import "SPNavigationBar.h"
#import "UIView+gradient.h"
#import "UIView+ExtendHitArea.h"

@interface SPNavigationBar ()

@end

@implementation SPNavigationBar


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    
    UIImageView *imageView = [[SPBaseImageView alloc] initWithFrame:self.bounds];
    [self addSubview:imageView];
    UIImage *image = [UIView gradientImageFromColor:nil toColor:nil size:CGSizeMake(kScreenWidth, kNavbarHeight)];
    imageView.image = image;
    self.backgroundImageView = imageView;
    
    
    SPBaseLabel *titleL = [[SPBaseLabel alloc] initWithFrame:CGRectMake(80, kTopSafeArea + 10, self.frame.size.width-80*2, 20)];
    titleL.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    self.titleL = titleL;
    self.titleL.textAlignment = NSTextAlignmentCenter;
    self.titleL.textColor = [UIColor whiteColor];
    [self addSubview:titleL];
    
    SPBaseButton *backBtn = [[SPBaseButton alloc] initWithFrame:CGRectMake(0, kTopSafeArea+10, 80, 30)];
    [self addSubview:backBtn];
    self.backBtn = backBtn;
    [backBtn setImage:[UIImage imageNamed:@"sp_icon_back"] forState:UIControlStateNormal];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    backBtn.adjustsImageWhenHighlighted = NO;
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn extendHitAreaTop:20 left:20 bottom:20 right:20];
    
    self.bottomLine = [[SPBaseView alloc] initWithFrame:CGRectMake(0, self.height-onePixel, self.width, onePixel)];
    self.bottomLine.backgroundColor = kSeparatorLineColor;
    [self addSubview:self.bottomLine];
    self.bottomLine.hidden = YES;
}
- (void)back:(SPBaseButton *)btn {
    if (self.backOnClick) {
        self.backOnClick(btn);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleL.y = kTopSafeArea + 10;
}

@end
