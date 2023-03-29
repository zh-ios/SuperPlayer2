//
//  SPWebViewToolbar.m
//  Player
//
//  Created by hz on 2022/4/22.
//

#import "SPWebViewToolbar.h"

@interface SPWebViewToolbar ()

@property (nonatomic, strong) UIButton *gobackBtn;
@property (nonatomic, strong) UIButton *goforwardBtn;
@property (nonatomic, strong) UIButton *refreshBtn;

@end

@implementation SPWebViewToolbar


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    CGFloat leftpadding = 20;
    CGFloat btnWH = 44;
    self.gobackBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftpadding, 2.5, btnWH, btnWH)];
    [self addSubview:self.gobackBtn];
    [self.gobackBtn setImage:kResizedImage(@"sp_icon_goback", 25) forState:UIControlStateNormal];
    [self.gobackBtn setImage:kResizedImage(@"sp_icon_goback_disable", 25) forState:UIControlStateDisabled];
    [self.gobackBtn addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    
    self.goforwardBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.gobackBtn.right+40, 2.5, btnWH, btnWH)];
    [self addSubview:self.goforwardBtn];
    [self.goforwardBtn setImage:kResizedImage(@"sp_icon_goforward", 25) forState:UIControlStateNormal];
    [self.goforwardBtn setImage:kResizedImage(@"sp_icon_goforward_disable", 25) forState:UIControlStateDisabled];
    [self.goforwardBtn addTarget:self action:@selector(goforward:) forControlEvents:UIControlEventTouchUpInside];
    
    self.refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width-leftpadding-btnWH, 2.5, btnWH, btnWH)];
    [self addSubview:self.refreshBtn];
    [self.refreshBtn setImage:kResizedImage(@"sp_icon_refresh", 25) forState:UIControlStateNormal];
    [self.refreshBtn addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)goback:(UIButton *)btn {
    if (self.gobackBtnOnClickedBlock) {
        self.gobackBtnOnClickedBlock(btn);
    }
}
- (void)goforward:(UIButton *)btn {
    if (self.goforwardBtnOnClickedBlock) {
        self.goforwardBtnOnClickedBlock(btn);
    }
}
- (void)refresh:(UIButton *)btn {
    if (self.refreshOnClickedBlock) {
        self.refreshOnClickedBlock(btn);
    }
}

- (void)refreshBtnStausGobackEnable:(BOOL)benable gofordBtnEnable:(BOOL)fenable {
    self.gobackBtn.enabled = benable;
    self.goforwardBtn.enabled = fenable;
}

@end
