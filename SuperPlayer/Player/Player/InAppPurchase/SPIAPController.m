//
//  SPIAPController.m
//  Player
//
//  Created by hz on 2021/12/3.
//

#import "SPIAPController.h"
#import "SPIAPItemView.h"
#import "UIView+gradient.h"
#import "PrivacyController.h"
#import "SPIAPManager.h"
#import "SPVersionManager.h"
#import "SPVIPPreviewController.h"
#import <StoreKit/StoreKit.h>

@interface SPIAPController ()<SPIAPManagerDelegate>

@property (nonatomic, strong) UIScrollView *containerView;
@property (nonatomic, strong) SPIAPItemView *lastSelectedView;
@property (nonatomic, strong) UIButton *subscribeBtn;
@property (nonatomic, strong) CAShapeLayer *shapelayer;

@end

@implementation SPIAPController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kZHLocalizedString(@"激活 PRO 模式");
    
    [self addContainerView];
    
    [self initSubViews];
    
    [self addrestoreIAPBtn];
    if ([SPGlobalConfigManager shareManager].configModel.is_new_version_online) {
        [[SPIAPManager shareManager] requestProductWithPid:kunlockForever];
    }
    
    [SPIAPManager shareManager].delegate = self;
}

- (void)addrestoreIAPBtn {
    UIButton *restoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-90, kTopSafeArea, 90, 44)];
    [self.customNavView addSubview:restoreBtn];
    [restoreBtn addTarget:self action:@selector(restore) forControlEvents:UIControlEventTouchUpInside];
    [restoreBtn setTitle:kZHLocalizedString(@"恢复购买") forState:UIControlStateNormal];
    [restoreBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    restoreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
}

- (void)restore {
    [[SPIAPManager shareManager] restoreIAP];
}

- (void)addContainerView {
    self.containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containerView];
}

- (void)initSubViews {
    CGFloat leftPadding = 15;

    UILabel *tipLabel = [[BaseLabel alloc] initWithFrame:CGRectMake(leftPadding , kNavbarHeight+15, 250, 80)];
    tipLabel.text = [NSString stringWithFormat:kZHLocalizedString(@"  欢迎使用\n                %@！"),kZHLocalizedString(@"秒播")];
    tipLabel.font = [UIFont boldSystemFontOfSize:25];
    tipLabel.numberOfLines = 2;
    [self.containerView addSubview:tipLabel];
    tipLabel.textColor = kThemeEndColor;
    [tipLabel sizeToFit];
        
    CGFloat btnH = 40;
    CGFloat btnMargin = 10;
    
    UIButton *onLineBtn = [self createBtnWithIcon:@"sp_icon_iap_lianjie" title:kZHLocalizedString(@"视频在线播在线搜如你所愿!") highlightText:kZHLocalizedString(@"在线") highlightColor:[UIColor colorWithHexString:@"ec680e"] frame:CGRectMake(leftPadding, tipLabel.bottom+15, kScreenWidth-leftPadding, btnH)];

    
  
    UIButton *lockBtn = [self createBtnWithIcon:@"sp_icon_lock" title:kZHLocalizedString(@"视频加密、屏幕锁安全放心播") highlightText:kZHLocalizedString(@"安全放心") highlightColor:[UIColor colorWithRGB:71 G:165 B:35 alpha:1] frame:CGRectMake(onLineBtn.left, onLineBtn.bottom+btnMargin, onLineBtn.width, onLineBtn.height)];
    
    UIButton *wifiBtn = [self createBtnWithIcon:@"sp_icon_iap_wifi" title:kZHLocalizedString(@"Wifi / iTunes传输方便快捷超省心") highlightText:kZHLocalizedString(@"超省心") highlightColor:[UIColor colorWithRGB:251 G:62 B:31 alpha:1] frame:CGRectMake(onLineBtn.left, lockBtn.bottom+btnMargin, onLineBtn.width, onLineBtn.height)];
        
    UIButton *playBtn = [self createBtnWithIcon:@"sp_icon_iap_play" title:kZHLocalizedString(@"高清视频快速流畅播放不卡顿") highlightText:kZHLocalizedString(@"快速流畅") highlightColor:kThemeEndColor frame:CGRectMake(onLineBtn.left, wifiBtn.bottom+btnMargin, onLineBtn.width, onLineBtn.height)];
    
    UIButton *adBtn = [self createBtnWithIcon:@"iap_icon_ad" title:kZHLocalizedString(@"干净清爽无广告、视频加密不受限") highlightText:kZHLocalizedString(@"干净清爽") highlightColor:[UIColor colorWithRGB:71 G:165 B:35 alpha:1] frame:CGRectMake(onLineBtn.left, playBtn.bottom+btnMargin, onLineBtn.width, onLineBtn.height)];
    
    [self.containerView addSubview:onLineBtn];
    [self.containerView addSubview:lockBtn];
    [self.containerView addSubview:wifiBtn];
    [self.containerView addSubview:playBtn];
    [self.containerView addSubview:adBtn];
    
    
    CGFloat margin = 15;
    CGFloat iapLeftPadding = 15;
    CGFloat iapViewW = (self.view.width-iapLeftPadding*2-margin*3)/4;
    CGFloat iapViewH = 80;

    CGFloat adjustedIapViewH = 0;
    CGFloat btnY = adBtn.bottom + 30;
    for (int i = 0; i<4; i++) {
        if (i == 0) {
            SPIAPItemView *iapView = [[SPIAPItemView alloc] initWithFrame:CGRectMake(iapLeftPadding+(iapViewW+margin)*i, btnY, iapViewW, iapViewH) disCountTitle:kZHLocalizedString(@"超实惠") timeTitle:kZHLocalizedString(@"一个月") price:kZHLocalizedString(@"28 ¥") type:@""];
            [self.containerView addSubview:iapView];
            iapView.tag = i;
            adjustedIapViewH = iapView.viewMaxHeight+15;
            iapView.height = adjustedIapViewH;
            [iapView addTarget:self action:@selector(selectIAPView:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i == 1) {
            SPIAPItemView *iapView = [[SPIAPItemView alloc] initWithFrame:CGRectMake(iapLeftPadding+(iapViewW+margin)*i, btnY, iapViewW, adjustedIapViewH) disCountTitle:@"30% OFF" timeTitle:kZHLocalizedString(@"三个月") price:kZHLocalizedString(@"58 ¥") type:@""];
            [self.containerView addSubview:iapView];
            
            iapView.tag = i;
            [iapView addTarget:self action:@selector(selectIAPView:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i == 2) {
            SPIAPItemView *iapView = [[SPIAPItemView alloc] initWithFrame:CGRectMake(iapLeftPadding+(iapViewW+margin)*i, btnY, iapViewW, adjustedIapViewH) disCountTitle:@"62% OFF" timeTitle:kZHLocalizedString(@"一年") price:kZHLocalizedString(@"128 ¥") type:@""];
            [self.containerView addSubview:iapView];
            iapView.tag = i;
            [iapView addTarget:self action:@selector(selectIAPView:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i == 3) {
            SPIAPItemView *iapView = [[SPIAPItemView alloc] initWithFrame:CGRectMake(iapLeftPadding+(iapViewW+margin)*i, btnY, iapViewW, adjustedIapViewH) disCountTitle:kZHLocalizedString(@"最划算") timeTitle:kZHLocalizedString(@"永久激活") price:kZHLocalizedString(@"168 ¥") type:@""];
            [self.containerView addSubview:iapView];
            iapView.selectedStatus = YES;
            self.lastSelectedView = iapView;
            iapView.tag = i;
            [iapView addTarget:self action:@selector(selectIAPView:) forControlEvents:UIControlEventTouchUpInside];
            
            [self drawDashLine:iapView lineLength:10 lineSpacing:8 lineColor:nil];
            
            [self selectIAPView:iapView];
            
        }
    }
    
    UIButton *subscribeBtn = [[UIButton alloc] initWithFrame:CGRectMake(iapLeftPadding, adBtn.bottom+20+iapViewH+65, self.view.width-iapLeftPadding*2, 50)];
    self.subscribeBtn = subscribeBtn;
    UIImage *bgImage = [UIView gradientImageFromColor:nil toColor:nil size:subscribeBtn.size];
    [subscribeBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [self.subscribeBtn setTitle:kZHLocalizedString(@"购买后立即永久享有全部权益") forState:UIControlStateNormal];
    subscribeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.containerView addSubview:subscribeBtn];
    subscribeBtn.layer.cornerRadius = subscribeBtn.height*0.5;
    subscribeBtn.clipsToBounds = YES;
    [subscribeBtn addTarget:self action:@selector(subscribe:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *previewBtn = [[UIButton alloc] initWithFrame:CGRectMake(iapLeftPadding, subscribeBtn.bottom+20, self.view.width-iapLeftPadding*2, 50)];
    [previewBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [previewBtn setTitle:kZHLocalizedString(@"预览购后功能  >>>") forState:UIControlStateNormal];
    previewBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.containerView addSubview:previewBtn];
    previewBtn.layer.cornerRadius = previewBtn.height*0.5;
    previewBtn.clipsToBounds = YES;
    [previewBtn addTarget:self action:@selector(preview:) forControlEvents:UIControlEventTouchUpInside];
    
    if(![SPVersionManager sharedManager].isNewVersionAvailable) {
        previewBtn.hidden = YES;
    }
    
    UILabel *declarationLabel = [[BaseLabel alloc] initWithFrame:CGRectMake(iapLeftPadding, previewBtn.bottom+30, self.subscribeBtn.width, 40)];
    declarationLabel.textColor = kTextColor9;
    declarationLabel.font = [UIFont systemFontOfSize:9];
    [self.containerView addSubview:declarationLabel];
    declarationLabel.numberOfLines = 0;
    declarationLabel.text = kZHLocalizedString(@"自动续费产品可前往【系统】-【账号】-【订阅】内随时取消");
    declarationLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *licenseBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, declarationLabel.bottom+10, (self.view.width-25*2-20*2)/2, 44)];
    [licenseBtn setTitle:kZHLocalizedString(@"【服务协议】") forState:UIControlStateNormal];
    [licenseBtn setTitleColor:kThemeMiddleColor forState:UIControlStateNormal];
    licenseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.containerView addSubview:licenseBtn];
    [licenseBtn addTarget:self action:@selector(go2licensePage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *privacyBtn = [[UIButton alloc] initWithFrame:CGRectMake(licenseBtn.right+20, declarationLabel.bottom+10, licenseBtn.width, 44)];
    [privacyBtn setTitle:kZHLocalizedString(@"【隐私政策】") forState:UIControlStateNormal];
    [privacyBtn setTitleColor:kThemeMiddleColor forState:UIControlStateNormal];
    privacyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.containerView addSubview:privacyBtn];
    [privacyBtn addTarget:self action:@selector(go2privacyController:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(nullable UIColor *)lineColor {
    if (!lineColor) lineColor = RGB(0, 255, 254);
   
    [self.shapelayer removeFromSuperlayer];
    self.shapelayer = nil;

    UIBezierPath *path  = [UIBezierPath bezierPathWithRect:CGRectMake(lineView.bounds.size.width*0.5, lineView.bounds.size.height*0.5, lineView.bounds.size.width, lineView.bounds.size.height)];

    CAShapeLayer *shapelayer  = [CAShapeLayer layer];
    self.shapelayer = shapelayer;
    
    [shapelayer setBounds:lineView.bounds];

    [shapelayer setFillColor:[UIColor clearColor].CGColor];

    //  设置虚线颜色为blackColor
    [shapelayer setStrokeColor:lineColor.CGColor];

    [shapelayer setShadowColor:[UIColor redColor].CGColor];
    [shapelayer setShadowOffset:CGSizeMake(0, 0)];
    [shapelayer setShadowRadius:1.f];
    [shapelayer setShadowOpacity:1.f];
    shapelayer.cornerRadius = 5.f;

    //  设置虚线宽度
    CGFloat lineW = 2;
    [shapelayer setLineWidth:lineW];
    // 设置线条圆角
    [shapelayer setLineCap:kCALineJoinRound];
    //  设置线宽，线间距
    [shapelayer setLineDashPattern:[NSArray arrayWithObjects:@(lineLength),@(lineSpacing), nil]];

    //设置路径
    [shapelayer setPath:path.CGPath];
    [lineView.layer addSublayer:shapelayer];
    //加动画
    CABasicAnimation *dashAnimation = [CABasicAnimation
                          animationWithKeyPath:@"lineDashPhase"];
    [dashAnimation setFromValue:[NSNumber numberWithFloat:300.f]];
    [dashAnimation setToValue:[NSNumber numberWithFloat:0.f]];
    [dashAnimation setDuration:10.f];
    dashAnimation.cumulative = YES; //关键属性，自己看文档
    [dashAnimation setRepeatCount:MAXFLOAT];
    dashAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.shapelayer addAnimation:dashAnimation forKey:@"linePhase"];
}


- (UIButton *)createBtnWithIcon:(NSString *)icon title:(NSString *)title
            highlightText:(NSString *)text highlightColor:(UIColor *)color frame:(CGRect)frame {
    
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:title];
    [mstr addAttributes:@{NSForegroundColorAttributeName : kTextColor3,NSFontAttributeName : [UIFont systemFontOfSize:16]} range:NSMakeRange(0, [title length])];
    NSRange hlRange = [title rangeOfString:text];
    [mstr addAttributes:@{NSForegroundColorAttributeName : color, NSFontAttributeName:[UIFont boldSystemFontOfSize:22]} range:hlRange];
    [btn setAttributedTitle:mstr forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    UIImage *btnImage = [[UIImage imageNamed:icon] sd_resizedImageWithSize:CGSizeMake(frame.size.height-2, frame.size.height-13) scaleMode:SDImageScaleModeAspectFit];
    [btn setImage:btnImage forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
    return btn;
}

// 许可协议
- (void)go2licensePage:(UIButton *)btn {
    NSURL *appstdURL = [NSURL URLWithString:@"https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"];
    if ([[UIApplication sharedApplication] canOpenURL:appstdURL]) {
        [[UIApplication sharedApplication] openURL:appstdURL options:@{} completionHandler:^(BOOL success) {
            
        }];;
    }
}

- (void)go2privacyController:(UIButton *)btn {
    PrivacyController *p = [[PrivacyController alloc] init];
    p.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:p animated:YES];
}

- (void)subscribe:(UIButton *)btn {
    if (self.lastSelectedView.tag == 0) [[SPIAPManager shareManager] requestProductWithPid:kunlockOneMonth];
    if (self.lastSelectedView.tag == 1) [[SPIAPManager shareManager] requestProductWithPid:kunlockOneSeason];
    if (self.lastSelectedView.tag == 2) [[SPIAPManager shareManager] requestProductWithPid:kunlockOneYear];
    if (self.lastSelectedView.tag == 3) [[SPIAPManager shareManager] requestProductWithPid:kunlockForever];
}

- (void)preview:(UIButton *)btn {
    SPVIPPreviewController *preview = [[SPVIPPreviewController alloc] init];
    preview.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:preview animated:YES];
}

- (void)selectIAPView:(SPIAPItemView *)view {
    if (view.selectedStatus) return;
    view.selectedStatus = YES;
    self.lastSelectedView.selectedStatus = NO;
    self.lastSelectedView = view;
    if (view.tag == 3) {
        [self.subscribeBtn setTitle:kZHLocalizedString(@"购买后立即永久享有全部权益") forState:UIControlStateNormal];
    } else {
        [self.subscribeBtn setTitle:kZHLocalizedString(@"立即订阅，享有全部权益") forState:UIControlStateNormal];
    }
    [self drawDashLine:view lineLength:10 lineSpacing:8 lineColor:nil];
}

- (void)SPIAPManagerDidFinishPurchase:(NSString *)pid {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ZHToastUtil showToast:@"欢迎来到 VIP 世界~ ✿✿ヽ(°▽°)ノ✿ ！！！" duration:2 completed:^{
            [SKStoreReviewController requestReview];
        }];
    });
}

@end
