//
//  SPInputOnlineLinkerController.m
//  Player
//
//  Created by zhuhao on 2023/2/8.
//

#import "SPInputOnlineLinkerController.h"
#import "YYTextView.h"
#import "FBShimmeringView.h"
#import "SPVersionManager.h"
#import "SPIAPController.h"
#import "SPVideoPlayerController.h"

@interface SPInputOnlineLinkerController ()<YYTextViewDelegate>

@property (nonatomic, strong) YYTextView *urlView;

@end

@implementation SPInputOnlineLinkerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    self.title = kZHLocalizedString(@"在线播");
}

- (void)setupSubviews {
    UILabel *line = [[SPBaseLabel alloc] initWithFrame:CGRectMake(15, kNavbarHeight+50, self.view.width-15*2, 5)];
    [self.view addSubview:line];
    [line addGradientColorsFrom:nil toColor:nil];
    
    UIImageView *playIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, kNavbarHeight+60, 30, 30)];
    playIcon.image = [UIImage imageNamed:@"sp_icon_search_play"];
    [self.view addSubview:playIcon];
    [self rotateView:playIcon];
    
    FBShimmeringView *shim = [[FBShimmeringView alloc] initWithFrame:CGRectMake(playIcon.right+5, playIcon.top, kScreenWidth-playIcon.right-30, 30)];
    [self.view addSubview:shim];
    
    UILabel *label = [[SPBaseLabel alloc] initWithFrame:shim.bounds];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = kThemeMiddleColor;
    shim.contentView = label;
    shim.shimmering = YES;
    NSString *tipStr = kZHLocalizedString(@"输入视频URL链接🔗在线播放");
    if ([SPVersionManager sharedMgr].isNewVersionAvailable) {
        tipStr = kZHLocalizedString(@"输入视频链接🔗在线播放");
    }

    label.text = tipStr;
    
//    CGFloat downloadBtnWH = 28;
//    SPBaseButton *downloadBtn = [[SPBaseButton alloc] initWithFrame:CGRectMake(kScreenWidth-50, shim.top, downloadBtnWH, downloadBtnWH)];
//    downloadBtn.centerY = shim.centerY;
//    [container addSubview:downloadBtn];
//    [downloadBtn setImage:[UIImage imageNamed:@"searh_download"] forState:UIControlStateNormal];
//    [downloadBtn addTarget:self action:@selector(downloadBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [downloadBtn extendHitAreaTop:20 left:20 bottom:20 right:20];
    
    YYTextView *urlView = [[YYTextView alloc] initWithFrame:CGRectMake(15, playIcon.bottom+10, self.view.width-15*2, 80)];
    self.urlView = urlView;
    urlView.font = [UIFont systemFontOfSize:13];
    urlView.textColor = kTextColor6;
    [self.view addSubview:urlView];
    urlView.returnKeyType = UIReturnKeyDone;
    urlView.placeholderText = kZHLocalizedString(@" (在线播)输入有效的链接地址，如: https://xxxxxx.mp4");
    urlView.placeholderFont = [UIFont systemFontOfSize:13];
    urlView.placeholderTextColor = kTextColor9;
    urlView.delegate = self;
    urlView.backgroundColor = [UIColor whiteColor];
    urlView.layer.shadowColor = kThemeBeginColor.CGColor;
    urlView.layer.shadowRadius = 5;
    urlView.layer.shadowOpacity = 0.5;
    urlView.layer.masksToBounds = NO;
    
    
    SPBaseButton *playerBtn = [[SPBaseButton alloc] initWithFrame:CGRectMake(15, urlView.bottom+20, kScreenWidth-15*2, 50)];
    UIImage *bgImage = [UIView gradientImageFromColor:nil toColor:nil size:playerBtn.bounds.size];
    [playerBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [playerBtn setTitle:kZHLocalizedString(@"开始在线播放开启精彩之旅 =>") forState:UIControlStateNormal];
    playerBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [playerBtn addTarget:self action:@selector(playOnLineVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playerBtn];
    playerBtn.layer.cornerRadius = playerBtn.height*0.5;
    playerBtn.clipsToBounds = YES;
}

- (void)rotateView:(UIImageView *)view {
    [view.layer removeAllAnimations];
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    rotationAnimation.duration = 2.5;
    rotationAnimation.repeatCount = HUGE_VALF;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)playOnLineVideo:(SPBaseButton *)btn {
    BOOL unlockAllFunc = [SPGlobalConfigManager shareManager].hadUnlockAllFunc;
//#ifdef DEBUG
//    unlockAllFunc = YES;
//#endif
    if (!unlockAllFunc) {
        [SPToastUtil showToast:kZHLocalizedString(@"该功能需要激活 VIP 后才可使用，即将进入激活页面") duration:1.5 completed:^{
            SPIAPController *iapVC = [[SPIAPController alloc] init];
            iapVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:iapVC animated:YES];
        }];
    } else {
        NSString *url = [self.urlView.text trimingWhiteSpaceAndNewline];
        if (url.length == 0) {
            [SPToastUtil showToast:kZHLocalizedString(@"请输入有效的URL")];
            return;
        }

        SPVideoPlayerController *playerVC = [[SPVideoPlayerController alloc] init];
        playerVC.hidesBottomBarWhenPushed = YES;
        playerVC.isOnLineVideo = YES;
        playerVC.urls = @[url];
        playerVC.currentIndex = 0;
        [self.navigationController pushViewController:playerVC animated:YES];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
