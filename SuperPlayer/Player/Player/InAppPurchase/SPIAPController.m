//
//  SPIAPController.m
//  Player
//
//  Cressssated by hzdddddd sxxxx on sky dat 2021/12/3.
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
@property (nonatomic, strong) SPBaseButton *subscribeBtn;
@property (nonatomic, strong) CAShapeLayer *animateShapeLayer;

@end

@implementation SPIAPController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kZHLocalizedString(@"畅享随心播特权");
    
    [self addContainerView];
    
    [self initSubViews];
    
    [self addrestoreIAPBtn];
    if ([SPGlobalConfigManager shareManager].configModel.is_new_version_online) {
        [[SPIAPManager shareManager] requestProductWithPid:kunlockForever];
    }
    
    [SPIAPManager shareManager].delegate = self;
}

- (void)addrestoreIAPBtn {
    SPBaseButton *restoreBtn = [[SPBaseButton alloc] initWithFrame:CGRectMake(self.view.width-90, kTopSafeArea, 90, 44)];
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

- (void)addAnimationWithIndex:(int)index view:(UIView *)view{
    view.x = kScreenWidth;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4*index * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:0 animations:^{
            view.x = 15;
        } completion:nil];
    });
}

- (void)initSubViews {
    CGFloat leftPadding = 15;

    UILabel *tipLabel = [[SPBaseLabel alloc] initWithFrame:CGRectMake(leftPadding , kNavbarHeight+15, 250, 80)];
    tipLabel.text = [NSString stringWithFormat:kZHLocalizedString(@"  欢迎使用\n                     %@！"),kZHLocalizedString(@"妙播")];
    tipLabel.font = [UIFont boldSystemFontOfSize:25];
    tipLabel.numberOfLines = 2;
    [self.containerView addSubview:tipLabel];
    tipLabel.textColor = kThemeEndColor;
    [tipLabel sizeToFit];
        
    CGFloat btnH = 40;
    CGFloat btnMargin = 10;
    
    SPBaseButton *onLineBtn = [self createBtnWithIcon:@"sp_icon_iap_lianjie" title:kZHLocalizedString(@"输入视频URL在线播 AS YOU WISH!") highlightText:kZHLocalizedString(@"在线") highlightColor:[UIColor colorWithHexString:@"ec680f"] frame:CGRectMake(leftPadding, tipLabel.bottom+15, kScreenWidth-leftPadding, btnH)];

    SPBaseButton *lockBtn = [self createBtnWithIcon:@"sp_icon_lock" title:kZHLocalizedString(@"视频加密或隐藏安全放心播") highlightText:kZHLocalizedString(@"安全放心") highlightColor:[UIColor colorWithRGB:72 G:166 B:35 alpha:1] frame:CGRectMake(onLineBtn.left, onLineBtn.bottom+btnMargin, onLineBtn.width, onLineBtn.height)];
    
    SPBaseButton *wifiBtn = [self createBtnWithIcon:@"sp_icon_iap_wifi" title:kZHLocalizedString(@"Wifi/iTunes传输方便快捷超省心") highlightText:kZHLocalizedString(@"超省心") highlightColor:[UIColor colorWithRGB:251 G:62 B:31 alpha:1] frame:CGRectMake(onLineBtn.left, lockBtn.bottom+btnMargin, onLineBtn.width, onLineBtn.height)];
        
    SPBaseButton *playBtn = [self createBtnWithIcon:@"sp_icon_iap_play" title:kZHLocalizedString(@"全格式视频快速流畅播放不卡顿") highlightText:kZHLocalizedString(@"流畅") highlightColor:kThemeEndColor frame:CGRectMake(onLineBtn.left, wifiBtn.bottom+btnMargin, onLineBtn.width, onLineBtn.height)];
    
    SPBaseButton *adBtn = [self createBtnWithIcon:@"sp_icon_ad" title:kZHLocalizedString(@"干净清爽无广告、视频加密不受限") highlightText:kZHLocalizedString(@"清爽") highlightColor:[UIColor colorWithRGB:72 G:168 B:35 alpha:1] frame:CGRectMake(onLineBtn.left, playBtn.bottom+btnMargin, onLineBtn.width, onLineBtn.height)];
    
    [self.containerView addSubview:onLineBtn];
    [self.containerView addSubview:lockBtn];
    [self.containerView addSubview:wifiBtn];
    [self.containerView addSubview:playBtn];
    [self.containerView addSubview:adBtn];
    [self addAnimationWithIndex:0 view:onLineBtn];
    [self addAnimationWithIndex:1 view:lockBtn];
    [self addAnimationWithIndex:2 view:wifiBtn];
    [self addAnimationWithIndex:3 view:playBtn];
    [self addAnimationWithIndex:4 view:adBtn];
    
    CGFloat margin = 30;
    CGFloat iapLeftPadding = 30;
    CGFloat iapViewW = (self.view.width-iapLeftPadding*2-margin*2)/3;
    CGFloat iapViewH = 80;

    CGFloat adjustedIapViewH = 0;
    CGFloat btnY = adBtn.bottom + 30;
    for (int i = 0; i<3; i++) {
        if (i == 0) {
            SPIAPItemView *iapView = [[SPIAPItemView alloc] initWithFrame:CGRectMake(iapLeftPadding+(iapViewW+margin)*i, btnY, iapViewW, iapViewH) disCountTitle:kZHLocalizedString(@"超实惠") timeTitle:kZHLocalizedString(@"一个月") price:kZHLocalizedString(@"18 ¥") type:@""];
            [self.containerView addSubview:iapView];
            iapView.tag = i;
            adjustedIapViewH = iapView.viewMaxHeight+15;
            iapView.height = adjustedIapViewH;
            [iapView addTarget:self action:@selector(selectIAPView:) forControlEvents:UIControlEventTouchUpInside];
        }

        if (i == 1) {
            SPIAPItemView *iapView = [[SPIAPItemView alloc] initWithFrame:CGRectMake(iapLeftPadding+(iapViewW+margin)*i, btnY, iapViewW, adjustedIapViewH) disCountTitle:@"73% OFF" timeTitle:kZHLocalizedString(@"一年") price:kZHLocalizedString(@"58 ¥") type:@""];
            [self.containerView addSubview:iapView];
            iapView.tag = i;
            [iapView addTarget:self action:@selector(selectIAPView:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i == 2) {
            SPIAPItemView *iapView = [[SPIAPItemView alloc] initWithFrame:CGRectMake(iapLeftPadding+(iapViewW+margin)*i, btnY, iapViewW, adjustedIapViewH) disCountTitle:kZHLocalizedString(@"最划算") timeTitle:kZHLocalizedString(@"永久特权") price:kZHLocalizedString(@"68 ¥") type:@""];
            [self.containerView addSubview:iapView];
            iapView.selectedStatus = YES;
            self.lastSelectedView = iapView;
            iapView.tag = i;
            [iapView addTarget:self action:@selector(selectIAPView:) forControlEvents:UIControlEventTouchUpInside];
            
            [self drawDashLine:iapView lineLength:10 lineSpacing:8 lineColor:nil];
            
            [self selectIAPView:iapView];
            
        }
    }
    
    SPBaseButton *subscribeBtn = [[SPBaseButton alloc] initWithFrame:CGRectMake(iapLeftPadding, adBtn.bottom+20+iapViewH+65, self.view.width-iapLeftPadding*2, 50)];
    self.subscribeBtn = subscribeBtn;
    UIImage *bgImage = [UIView gradientImageFromColor:nil toColor:nil size:subscribeBtn.size];
    [subscribeBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [self.subscribeBtn setTitle:kZHLocalizedString(@"购买后立即永久畅享全部功能") forState:UIControlStateNormal];
    subscribeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.containerView addSubview:subscribeBtn];
    subscribeBtn.layer.cornerRadius = subscribeBtn.height*0.5;
    subscribeBtn.clipsToBounds = YES;
    [subscribeBtn addTarget:self action:@selector(subscribe:) forControlEvents:UIControlEventTouchUpInside];
    
    SPBaseButton *previewBtn = [[SPBaseButton alloc] initWithFrame:CGRectMake(iapLeftPadding, subscribeBtn.bottom+20, self.view.width-iapLeftPadding*2, 50)];
    [previewBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [previewBtn setTitle:kZHLocalizedString(@"预览购后功能  >>>") forState:UIControlStateNormal];
    previewBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.containerView addSubview:previewBtn];
    previewBtn.layer.cornerRadius = previewBtn.height*0.5;
    previewBtn.clipsToBounds = YES;
    [previewBtn addTarget:self action:@selector(preview:) forControlEvents:UIControlEventTouchUpInside];
    
    if(![SPVersionManager sharedMgr].isNewVersionAvailable) {
        previewBtn.hidden = YES;
    }
    
    UILabel *declarationLabel = [[SPBaseLabel alloc] initWithFrame:CGRectMake(iapLeftPadding, previewBtn.bottom+30, self.subscribeBtn.width, 40)];
    declarationLabel.textColor = kTextColor9;
    declarationLabel.font = [UIFont systemFontOfSize:9];
    [self.containerView addSubview:declarationLabel];
    declarationLabel.numberOfLines = 0;
    declarationLabel.text = kZHLocalizedString(@"自动续费产品可前往【系统】-【账号】-【订阅】内随时取消");
    declarationLabel.textAlignment = NSTextAlignmentCenter;
    
    SPBaseButton *licenseBtn = [[SPBaseButton alloc] initWithFrame:CGRectMake(25, declarationLabel.bottom+10, (self.view.width-25*2-20*2)/2, 44)];
    [licenseBtn setTitle:kZHLocalizedString(@"【 服务协议 】") forState:UIControlStateNormal];
    [licenseBtn setTitleColor:kThemeMiddleColor forState:UIControlStateNormal];
    licenseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.containerView addSubview:licenseBtn];
    [licenseBtn addTarget:self action:@selector(go2licensePage:) forControlEvents:UIControlEventTouchUpInside];
    
    SPBaseButton *privacyBtn = [[SPBaseButton alloc] initWithFrame:CGRectMake(licenseBtn.right+20, declarationLabel.bottom+10, licenseBtn.width, 44)];
    [privacyBtn setTitle:kZHLocalizedString(@"【 隐私政策 】") forState:UIControlStateNormal];
    [privacyBtn setTitleColor:kThemeMiddleColor forState:UIControlStateNormal];
    privacyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.containerView addSubview:privacyBtn];
    [privacyBtn addTarget:self action:@selector(go2privacyController:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(nullable UIColor *)lineColor {
    if (!lineColor) lineColor = RGB(0, 255, 254);
   
    [self.animateShapeLayer removeFromSuperlayer];
    self.animateShapeLayer = nil;

    UIBezierPath *path  = [UIBezierPath bezierPathWithRect:CGRectMake(lineView.bounds.size.width*0.5, lineView.bounds.size.height*0.5, lineView.bounds.size.width, lineView.bounds.size.height)];

    CAShapeLayer *animateShapeLayer  = [CAShapeLayer layer];
    self.animateShapeLayer = animateShapeLayer;
    
    [animateShapeLayer setBounds:lineView.bounds];

    [animateShapeLayer setFillColor:[UIColor clearColor].CGColor];

    //  设置虚线颜色为blackColor
    [animateShapeLayer setStrokeColor:lineColor.CGColor];

    [animateShapeLayer setShadowColor:[UIColor redColor].CGColor];
    [animateShapeLayer setShadowOffset:CGSizeMake(0, 0)];
    [animateShapeLayer setShadowRadius:1.f];
    [animateShapeLayer setShadowOpacity:1.f];
    animateShapeLayer.cornerRadius = 5.f;

    //  设置虚线宽度
    CGFloat lineW = 2;
    [animateShapeLayer setLineWidth:lineW];
    // 设置线条圆角
    [animateShapeLayer setLineCap:kCALineJoinRound];
    //  设置线宽，线间距
    [animateShapeLayer setLineDashPattern:[NSArray arrayWithObjects:@(lineLength),@(lineSpacing), nil]];

    //设置路径
    [animateShapeLayer setPath:path.CGPath];
    [lineView.layer addSublayer:animateShapeLayer];
    //加动画
    CABasicAnimation *dashAnimation = [CABasicAnimation
                          animationWithKeyPath:@"lineDashPhase"];
    [dashAnimation setFromValue:[NSNumber numberWithFloat:300.f]];
    [dashAnimation setToValue:[NSNumber numberWithFloat:0.f]];
    [dashAnimation setDuration:10.f];
    dashAnimation.cumulative = YES; //关键属性，自己看文档
    [dashAnimation setRepeatCount:MAXFLOAT];
    dashAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.animateShapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
}


- (SPBaseButton *)createBtnWithIcon:(NSString *)icon title:(NSString *)title
            highlightText:(NSString *)text highlightColor:(UIColor *)color frame:(CGRect)frame {
    
    SPBaseButton *btn = [[SPBaseButton alloc] initWithFrame:frame];
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
- (void)go2licensePage:(SPBaseButton *)btn {
    NSURL *appstdURL = [NSURL URLWithString:@"https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"];
    if ([[UIApplication sharedApplication] canOpenURL:appstdURL]) {
        [[UIApplication sharedApplication] openURL:appstdURL options:@{} completionHandler:^(BOOL success) {
            
        }];;
    }
}

- (void)go2privacyController:(SPBaseButton *)btn {
    PrivacyController *p = [[PrivacyController alloc] init];
    p.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:p animated:YES];
}

- (void)subscribe:(SPBaseButton *)btn {
    if (self.lastSelectedView.tag == 0) [[SPIAPManager shareManager] requestProductWithPid:kunlockOneMonth];
    if (self.lastSelectedView.tag == 1) [[SPIAPManager shareManager] requestProductWithPid:kunlockOneYear];
    if (self.lastSelectedView.tag == 2) [[SPIAPManager shareManager] requestProductWithPid:kunlockForever];
}

- (void)preview:(SPBaseButton *)btn {
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
        [self.subscribeBtn setTitle:kZHLocalizedString(@"购买后立即永久畅享全部功能") forState:UIControlStateNormal];
    } else {
        [self.subscribeBtn setTitle:kZHLocalizedString(@"立即订阅，畅享全部功能") forState:UIControlStateNormal];
    }
    [self drawDashLine:view lineLength:10 lineSpacing:8 lineColor:nil];
}

- (void)SPIAPManagerDidFinishPurchase:(NSString *)pid {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SPToastUtil showToast:@"欢迎来到 VIP 世界~ ✿✿ヽ(°▽°)ノ✿ ！！！" duration:2 completed:^{
            [SKStoreReviewController requestReview];
        }];
    });
}

@end
