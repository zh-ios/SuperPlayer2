//
//  SPProfileController.m
//  SMPlayer
//
//  Created by hz on 2021/10/21.
//

#import "SPProfileController.h"
#import "SPIAPManager.h"
#import "SPIAPController.h"
#import "NSDate+AHDateUtil.h"
#import "FeedbackController.h"
#import <StoreKit/StoreKit.h>
#import "SPVersionManager.h"
#import "SPInputOnlineLinkerController.h"
@interface SPProfileController ()<SPIAPManagerDelegate>
@end

@implementation SPProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kZHLocalizedString(@"个人中心");
    [SPIAPManager shareManager].delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initSubItems];
}


- (void)initSubItems {
    
    @weakify(self)
    
    SPSwitchItem *speedup = [SPSwitchItem itemWithIcon:@"sp_icon_speedup" title:kZHLocalizedString(@"硬件加速") subTitle:kZHLocalizedString(@"启用硬件加速，播放更顺畅~")];
    
//    SPArrowItem *goodCmt = [SPArrowItem itemWithIcon:@"sp_icon_heart" title:kZHLocalizedString(@"五星好评支持开发者 😘") targetCls:nil];
//    goodCmt.onClicked = ^(SPCellItem * _Nullable item, UISwitch * _Nullable sw) {
//        [SKStoreReviewController requestReview];
//    };

    
//    sp_icon_setting_share@2x
    // TODO 跳转到对应控制器
    SPArrowItem *share =  [SPArrowItem itemWithIcon:@"sp_icon_setting_share" title:kZHLocalizedString(@"分享给好友") subTitle:@"" targetCls:nil];
    
    share.onClicked = ^(SPCellItem * _Nullable item, UISwitch * _Nullable sw) {
        [self handleShareAction];
    };
    
    SPSwitchItem *shakeToHide = [SPSwitchItem itemWithIcon:@"sp_icon_shake" title:kZHLocalizedString(@"摇一摇 显示/隐藏 Vip 视频") subTitle:@""];
    BOOL enableShakeToHide = [SPGlobalConfigManager shareManager].enalbleShakeToHideFunc;
    if (enableShakeToHide) {
        shakeToHide.switchOn = YES;
    }
    shakeToHide.onClicked = ^(SPCellItem * _Nullable item, UISwitch * _Nullable sw) {
        [SPGlobalConfigManager shareManager].enalbleShakeToHideFunc = sw.on;
        [[NSUserDefaults standardUserDefaults] setObject:(sw.on?@"1":@"0") forKey:kUserUseShakeToHideFunc];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (sw.on) {
            AppDelegate *delegate =  (AppDelegate *)kAppDelegate;
            [delegate.tabbar addMotionManager];
        }
    };
    
    SPArrowItem *onlinePlay = [SPArrowItem itemWithIcon:@"sp_icon_iap_lianjie" title:kZHLocalizedString(@"在线播放") targetCls:nil];
    SPInputOnlineLinkerController *onlineVC = [[SPInputOnlineLinkerController alloc] init];
    onlineVC.hidesBottomBarWhenPushed = YES;
    onlinePlay.onClicked = ^(SPCellItem * _Nullable item, UISwitch * _Nullable sw) {
        @weakify(self);
        [self.navigationController pushViewController:onlineVC animated:YES];
    };
    

    // TODO 跳转到对应控制器
    SPArrowItem *subScribe =  [SPArrowItem itemWithIcon:@"sp_icon_unlock" title:kZHLocalizedString(@"激活 PRO 模式") subTitle:kZHLocalizedString(@"激活后可畅享全部功能") targetCls:nil];
    SPArrowItem *feedback = [SPArrowItem itemWithIcon:@"sp_icon_feedback" title:kZHLocalizedString(@"🧲搜索求助~") subTitle:kZHLocalizedString(@"邮箱联系帮您解决搜索问题！~😘") targetCls:nil];
    feedback.onClicked = ^(SPCellItem * _Nullable item, UISwitch * _Nullable sw) {
    @strongify(self)
        FeedbackController *feedVC = [[FeedbackController alloc] init];
        feedVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:feedVC animated:YES];
    };
    
    
    BOOL speedupStatus = [SPGlobalConfigManager shareManager].speedupStatus;
    
    
    BOOL openAllFuncForeverStatus = [SPGlobalConfigManager shareManager].unlockAllFuncForeverStatus;
    BOOL subscribeStatus = [SPGlobalConfigManager shareManager].unlockAllFunc;
    
    
    // 如果订阅了
    long long expireTs = [SPGlobalConfigManager shareManager].iapExpireTs;
    NSDate *expireDate = [NSDate dateWithTimeIntervalSince1970:expireTs/1000];
    
    // 内购过期时间
    NSString *expireStr = [expireDate dateTimeStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 永久解锁
    if (openAllFuncForeverStatus) {
        subScribe = [SPArrowItem itemWithIcon:@"sp_icon_unlock" title:kZHLocalizedString(@"已永久激活 PRO 模式") targetCls:nil];
        subScribe.hideArrowImageView = YES;
    } else if (subscribeStatus) {
//        subScribe = [SPArrowItem itemWithIcon:@"sp_icon_unlock" title:kZHLocalizedString(@"已激活 PRO 模式") subTitle:[NSString stringWithFormat:kZHLocalizedString(@"有效期至%@"),expireStr] targetCls:nil];
        subScribe = [SPArrowItem itemWithIcon:@"sp_icon_unlock" title:kZHLocalizedString(@"已激活 PRO 模式") subTitle:@"" targetCls:nil];
    }

    if (speedupStatus) speedup.switchOn = YES;

    speedup.onClicked = ^(SPCellItem *item, UISwitch *sw) {
        [SPGlobalConfigManager shareManager].speedupStatus = sw.on;
        [[NSUserDefaults standardUserDefaults] setBool:sw.on forKey:kSpeedupStatusKey];
    };
    
    subScribe.onClicked = ^(SPCellItem * _Nullable item, UISwitch * _Nullable sw) {
        @strongify(self)
        // 如果已经永久激活或者激活了
        if (openAllFuncForeverStatus||subscribeStatus) {
            return;
        }
        SPIAPController *controller = [[SPIAPController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    };
    
//    SPCellGroupItem *goodCmtGroup = [SPCellGroupItem itemWithItems:@[goodCmt]];
//    goodCmtGroup.headerView = [self getHeader];
    
    SPCellGroupItem *speedupGroup = [SPCellGroupItem itemWithItems:@[speedup]];
    speedupGroup.headerView = [self getHeader];

    SPCellGroupItem *feedbackGroup = [SPCellGroupItem itemWithItems:@[feedback]];
    feedbackGroup.headerView = [self getHeader];
    
    SPCellGroupItem *shareGroup = [SPCellGroupItem itemWithItems:@[share]];
    shareGroup.headerView = [self getHeader];
    
    SPCellGroupItem *shakeTohideGroup = [SPCellGroupItem itemWithItems:@[shakeToHide]];
    shakeTohideGroup.headerView = [self getHeader];

    SPCellGroupItem *onlinePlayGroup = [SPCellGroupItem itemWithItems:@[onlinePlay]];
    onlinePlayGroup.headerView = [self getHeader];
    
    SPCellGroupItem *unlockAllFuncGroup = [SPCellGroupItem itemWithItems:@[subScribe]];
    unlockAllFuncGroup.headerView = [self getHeader];

    self.groupItems = @[feedbackGroup,shareGroup,shakeTohideGroup,onlinePlayGroup,unlockAllFuncGroup];

    [self.tableView reloadData];
}




- (UIView *)getHeader {
    UIView *header = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 15)];
    return header;
}


- (void)handleShareAction {
    NSString *textToShare = kZHLocalizedString(@"分享给你一个好用的视频播放器，快来看看吧！");
    NSURL *urlToShare = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1598269158"];
    NSArray *activityItems = @[textToShare, urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
   
    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter, UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeMail,

    UIActivityTypePrint,UIActivityTypeCopyToPasteboard,

    UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,

    UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,

    UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,

    UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks];
   
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark --- SPIAPManagerDelegate
- (void)SPIAPManagerDidFinishPurchase:(NSString *)pid {
    if ([pid isEqualToString:kunlockForever]) {
        [SPGlobalConfigManager shareManager].unlockAllFuncForeverStatus = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUnlockAllFuncForeverKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

// 购买凭证校验失败
- (void)SPIAPManagerVerfyFailed {
    [ZHToastUtil showToast:kZHLocalizedString(@"凭证校验失败")];
}

- (void)SPIAPManagerCancelledOrFailed:(NSString *)pid {
    
}

@end

