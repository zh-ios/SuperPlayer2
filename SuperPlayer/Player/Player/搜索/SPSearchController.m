//
//  SPSearchController.m
//  SMPlayer
//
//  Created by hz on 2021/10/21.
//

#import "SPSearchController.h"
#import "SPSearchTagView.h"
#import "SearchTextFieldView.h"
#import <objc/runtime.h>
#import "ZHWebController.h"
#import "FBShimmeringView.h"
#import "UIView+gradient.h"
#import "SPIAPController.h"
#import "SPVideoPlayerController.h"
#import "ZHNavigationController.h"
#import "SPVersionManager.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "AXWebViewController.h"
#import "SPIAPManager.h"
#import "NetHelper.h"

@interface SPSearchController ()<UITextFieldDelegate, YYTextViewDelegate>

@property (nonatomic, strong) NSMutableArray *searchHistory;
@property (nonatomic, strong) SPSearchTagView *historyView;

@property (nonatomic, strong) UITextField *tf;
@property (nonatomic, strong) YYTextView *urlView;
@property (nonatomic, strong) UIButton *playRandowVideoButton;
@property (nonatomic, strong) CALayer *animationLayer;


@end

@implementation SPSearchController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    [self addSearchView];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadTagView];
    [self addBreathAnimation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([SPVersionManager sharedManager].isNewVersionAvailable) {
        BOOL hadClick = [[NSUserDefaults standardUserDefaults] boolForKey:kHadClick18YearOldAlert];
        if (!hadClick) {
            [self show18YearWarningAlert];
        }
    }
}

- (void)show18YearWarningAlert {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kZHLocalizedString(@"警告⚠️") message:kZHLocalizedString(@"\n本页面功能包含成人内容，浏览使用前请确保年满18周岁！") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:kZHLocalizedString(@"我已年满18周岁") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHadClick18YearOldAlert];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kZHLocalizedString(@"我是未成年人") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
    [alertVC addAction:sureAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)dismissKeyboard {
    [self.tf resignFirstResponder];
}

- (void)addSearchView {
    SearchTextFieldView *textView = [[SearchTextFieldView alloc] initWithFrame:CGRectMake(0, kTopSafeArea+5, self.view.width-40, 35)];
    [self.customNavView addSubview:textView];
    NSString *searchPlaceHolder = kZHLocalizedString(@" (在线搜)请输入要搜索的内容");

    textView.textField.placeholder = searchPlaceHolder;
    textView.textField.font = [UIFont systemFontOfSize:15];
    textView.textField.textColor = kTextColor3;

    // ios 13chxian shantui
//    [textView.textField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
    UILabel *placeholderLabel = object_getIvar(textView.textField, ivar);
    placeholderLabel.font = [UIFont systemFontOfSize:14];
    textView.textField.delegate = self;
    self.tf = textView.textField;
    self.tf.returnKeyType = UIReturnKeySearch;
    self.tf.enablesReturnKeyAutomatically = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(textView.right-5, textView.top, 40, textView.height)];
    [cancelBtn setTitle:kZHLocalizedString(@"取消") forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavView addSubview:cancelBtn];
}

- (void)initSubviews {
    TPKeyboardAvoidingScrollView *container = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabbarHeight)];
    [self.view addSubview:container];
    container.showsHorizontalScrollIndicator = NO;
    container.showsVerticalScrollIndicator = NO;
    container.clipsToBounds = YES;
    
    self.searchHistory = [(NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:kSearchHistoryKey] mutableCopy];
    

    SPSearchTagView *historyView = [[SPSearchTagView alloc] initWithFrame:CGRectMake(0, kNavbarHeight + 15, self.view.width, 20)];
    @weakify(self)
    historyView.btnOnClicked = ^(NSString * _Nonnull title) {
        @strongify(self)
        [self getSearchResult:title];
        self.tf.text = title;
    };
    historyView.clearBtnOnClicked = ^{
      @strongify(self)
        [self clearSearchHisotry];
    };
    self.historyView = historyView;
    [container addSubview:self.historyView];

    UIButton *playRandomButton = [[UIButton alloc] initWithFrame:CGRectMake(25, container.height - 150 , 50, 50)];
    [container addSubview:playRandomButton];
    self.playRandowVideoButton = playRandomButton;
    [playRandomButton addTarget:self action:@selector(playRandomVideo) forControlEvents:UIControlEventTouchUpInside];
    [container contentSizeToFit];
}

- (void)playRandomVideo {
    if ([[SPGlobalConfigManager shareManager] shouldShowIAPAlertWhilePlayOnlineVideos]) {
        [ZHToastUtil showToast:kZHLocalizedString(@"已达每天次数上限，解锁VIP无限播") completed:^{
            SPIAPController *iapVC = [[SPIAPController alloc] init];
            iapVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:iapVC animated:YES];
        }];
    } else {
        [ZHToastUtil showLoadingWithTitle:@"" onView:self.view];
        [NetHelper GET:@"https://tucdn.wpon.cn/api-girl/index.php?wpon=json" parameters:nil success:^(id responseObject) {
            [ZHToastUtil endLoadingOnView:self.view];
            NSString *url = responseObject[@"mp4"];
            if (!kIS_STR_NIL(url)) {
                url = [NSString stringWithFormat:@"https:%@",url];
                SPVideoPlayerController *playerVC = [[SPVideoPlayerController alloc] init];
                playerVC.hidesBottomBarWhenPushed = YES;
                playerVC.isOnLineVideo = YES;
                playerVC.urls = @[url];
                playerVC.currentIndex = 0;
                [self.navigationController pushViewController:playerVC animated:YES];
            }
        } failure:^(MiNetError *error) {
            [ZHToastUtil endLoadingOnView:self.view];
            [ZHToastUtil showToast:kZHLocalizedString(@"稍后再试吧~~")];
        }];
    }
}



- (void)cancel {
    [self.tf resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view endEditing:YES];
}

- (void)textFiledDidChanged:(NSNotification *)noti {
   
}

#pragma mark --- UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *text = [self.tf.text trimingWhiteSpaceAndNewline];
    if (text.length == 0) {
        [ZHToastUtil showToast:kZHLocalizedString(@"请输入搜索内容")];
        return NO;
    }
    
    BOOL unlockAllFunc = [SPGlobalConfigManager shareManager].unlockAllFunc;
//#ifdef DEBUG
//    unlockAllFunc = YES;
//#endif
    if (!unlockAllFunc) {
        [ZHToastUtil showToast:kZHLocalizedString(@"该功能需要激活 PRO 模式后才可使用，即将进入激活页面") duration:1.5 completed:^{
            SPIAPController *iapVC = [[SPIAPController alloc] init];
            iapVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:iapVC animated:YES];
        }];
        return NO;
    }
    
    [self getSearchResult:text];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;//这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

- (void)clearSearchHisotry {
    [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:kSearchHistoryKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.searchHistory = @[].mutableCopy;
    [self reloadTagView];
}

- (void)saveSearchHistory:(NSString *)txt {
    NSString *key = kSearchHistoryKey;
    NSMutableArray *datas = [[[NSUserDefaults standardUserDefaults] objectForKey:key] mutableCopy];
    if (!datas) datas = @[].mutableCopy;
    
    if ([datas containsObject:txt]) {
        [datas removeObject:txt];
        [datas insertObject:txt atIndex:0];
    } else {
        [datas insertObject:txt atIndex:0];
    }
    
    if (datas.count > 15) [datas removeLastObject];
    [[NSUserDefaults standardUserDefaults] setObject:datas forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.searchHistory = [datas mutableCopy];
    [self reloadTagView];
}

- (void)getSearchResult:(NSString *)text {
    if ([NetHelper getProxyStatus]) {
        return;
    }
    BOOL unlockAllFunc = [SPGlobalConfigManager shareManager].unlockAllFunc;
#ifdef DEBUG
    unlockAllFunc = YES;
#endif
    if (!unlockAllFunc) {
        [ZHToastUtil showToast:kZHLocalizedString(@"该功能需要激活 PRO 模式后才可使用，即将进入激活页面") duration:1.5 completed:^{
            SPIAPController *iapVC = [[SPIAPController alloc] init];
            iapVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:iapVC animated:YES];
        }];
        return;
    }
    [self.tf resignFirstResponder];
    [self saveSearchHistory:text];
    
    NSString *url = @"https://cn.bing.com/?mkt=zh-CN";
    NSString *webURL = [SPGlobalConfigManager shareManager].configModel.webview_url;
    if (kSTR_IS_VALID(webURL)&&[SPGlobalConfigManager shareManager].configModel.is_new_version_online) {
        url = webURL;
    }
 
    AXWebViewController *webVC = [[AXWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    webVC.showsToolBar = YES;
    webVC.webView.allowsLinkPreview = YES;
    webVC.hidesBottomBarWhenPushed = YES;
     
    [self.navigationController pushViewController:webVC animated:YES];
}


- (void)addSearchResultVCWithDatas:(NSArray *)datas searchText:(NSString *)text{
    
}

- (void)reloadTagView {
    self.searchHistory = [(NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:kSearchHistoryKey] mutableCopy];
    if (self.searchHistory.count == 0) {
        //zhtodo 国际化内容
        self.searchHistory = [@[kZHLocalizedString(@"天美传媒TM"),kZHLocalizedString(@"蜜桃传媒影视"),kZHLocalizedString(@"JK"),kZHLocalizedString(@"Spa"),kZHLocalizedString(@"tokyo")] mutableCopy];
        [self.historyView updateView:self.searchHistory title:kZHLocalizedString(@"热门搜索")];
    } else {
        [self.historyView updateView:self.searchHistory title:kZHLocalizedString(@"搜索历史")];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.tf resignFirstResponder];
}

- (void)downloadBtnOnClicked:(UIButton *)btn {
    NSString *url = [self.urlView.text trimingWhiteSpaceAndNewline];
    if (url.length == 0) {
        [ZHToastUtil showToast:kZHLocalizedString(@"请输入有效的URL")];
        return;
    }
}


static NSString *const kBreathAnimationKey  = @"BreathAnimationKey";
static NSString *const kBreathAnimationName = @"BreathAnimationName";
static NSString *const kBreathScaleName     = @"BreathScaleName";
CGFloat kHeartSizeWidth = 100.0f;
CGFloat kHeartSizeHeight = 100.0f;
/**
 *  按钮呼吸动画
 */
- (void)addBreathAnimation {
    if (![self.self.playRandowVideoButton.layer animationForKey:kBreathAnimationKey] && self.playRandowVideoButton) {
        UIImage *animnationImage = [UIImage imageNamed:@"sticker_classic_zhifeiji"];
        [self.animationLayer removeFromSuperlayer];
        CALayer *layer = [CALayer layer];
        self.animationLayer = layer;
        layer.position = CGPointMake(25, 25);
        layer.bounds = CGRectMake(0, 0, 50, 50);
        layer.backgroundColor = [UIColor clearColor].CGColor;
        layer.contents = (__bridge id _Nullable)(animnationImage.CGImage);
        layer.contentsGravity = kCAGravityResizeAspect;
        if (![self.playRandowVideoButton.layer.sublayers containsObject:self.animationLayer]) {
            [self.playRandowVideoButton.layer addSublayer:layer];
        }
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.values = @[@1.f, @1.4f, @1.f];
        animation.keyTimes = @[@0.f, @0.5f, @1.f];
        animation.duration = 5; //1000ms
        animation.repeatCount = FLT_MAX;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [animation setValue:kBreathAnimationKey forKey:kBreathAnimationName];
        [layer addAnimation:animation forKey:kBreathAnimationKey];
        
        CALayer *breathLayer = [CALayer layer];
        breathLayer.position = layer.position;
        breathLayer.bounds = layer.bounds;
        breathLayer.backgroundColor = [UIColor clearColor].CGColor;
        breathLayer.contents = (__bridge id _Nullable)(animnationImage.CGImage);
        breathLayer.contentsGravity = kCAGravityResizeAspect;
//        [self.playRandowVideoButton.layer insertSublayer:breathLayer below:layer];

        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.values = @[@1.f, @2.0f];
        scaleAnimation.keyTimes = @[@0.f,@1.f];
        scaleAnimation.duration = animation.duration;
        scaleAnimation.repeatCount = FLT_MAX;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animation];
        opacityAnimation.keyPath = @"opacity";
        opacityAnimation.values = @[@1.f, @0.f];
        opacityAnimation.duration = 0.4f;
        opacityAnimation.keyTimes = @[@0.f, @1.f];
        opacityAnimation.repeatCount = FLT_MAX;
        opacityAnimation.duration = animation.duration;
        opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

        CAAnimationGroup *scaleOpacityGroup = [CAAnimationGroup animation];
        scaleOpacityGroup.animations = @[scaleAnimation, opacityAnimation];
        scaleOpacityGroup.removedOnCompletion = NO;
        scaleOpacityGroup.fillMode = kCAFillModeForwards;
        scaleOpacityGroup.duration = animation.duration;
        scaleOpacityGroup.repeatCount = FLT_MAX;
        [breathLayer addAnimation:scaleOpacityGroup forKey:kBreathScaleName];
    }
}


@end
