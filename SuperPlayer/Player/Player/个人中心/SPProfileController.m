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
#import "SPFeedbackController.h"
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

    SPSwitchItem *shakeToHide = [SPSwitchItem itemWithIcon:@"sp_icon_shake" title:kZHLocalizedString(@"摇一摇 显示/隐藏 VIP 视频") subTitle:@""];
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
    
    SPArrowItem *onlinePlay = [SPArrowItem itemWithIcon:@"sp_icon_iap_lianjie" title:kZHLocalizedString(@"在线播") targetCls:nil];
    SPInputOnlineLinkerController *onlineVC = [[SPInputOnlineLinkerController alloc] init];
    onlineVC.hidesBottomBarWhenPushed = YES;
    onlinePlay.onClicked = ^(SPCellItem * _Nullable item, UISwitch * _Nullable sw) {
        @weakify(self);
        [self.navigationController pushViewController:onlineVC animated:YES];
    };
    

    // TODO 跳转到对应控制器
    SPArrowItem *subScribe =  [SPArrowItem itemWithIcon:@"sp_icon_unlock" title:kZHLocalizedString(@"激活 VIP ") subTitle:kZHLocalizedString(@"激活后可畅享全部功能") targetCls:nil];
    SPArrowItem *feedback = [SPArrowItem itemWithIcon:@"sp_icon_feedback" title:kZHLocalizedString(@"🧲使用帮助~") subTitle:kZHLocalizedString(@"问题反馈及帮助~😘") targetCls:nil];
    feedback.onClicked = ^(SPCellItem * _Nullable item, UISwitch * _Nullable sw) {
    @strongify(self)
        SPFeedbackController *feedVC = [[SPFeedbackController alloc] init];
        feedVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:feedVC animated:YES];
    };
    
    
    BOOL speedupStatus = [SPGlobalConfigManager shareManager].speedupStatus;
    
    
    BOOL openAllFuncForeverStatus = [SPGlobalConfigManager shareManager].hadUnlockAllFunctionForeverStatus;
    BOOL subscribeStatus = [SPGlobalConfigManager shareManager].hadUnlockAllFunc;
    
    
    // 如果订阅了
    long long expireTs = [SPGlobalConfigManager shareManager].iapExpireTs;
    NSDate *expireDate = [NSDate dateWithTimeIntervalSince1970:expireTs/1000];
    
    // 内购过期时间
    NSString *expireStr = [expireDate dateTimeStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 永久解锁
    if (openAllFuncForeverStatus) {
        subScribe = [SPArrowItem itemWithIcon:@"sp_icon_unlock" title:kZHLocalizedString(@"已永久激活 VIP") targetCls:nil];
        subScribe.hideArrowImageView = YES;
    } else if (subscribeStatus) {
//        subScribe = [SPArrowItem itemWithIcon:@"sp_icon_unlock" title:kZHLocalizedString(@"已激活 PRO 模式") subTitle:[NSString stringWithFormat:kZHLocalizedString(@"有效期至%@"),expireStr] targetCls:nil];
        subScribe = [SPArrowItem itemWithIcon:@"sp_icon_unlock" title:kZHLocalizedString(@"已激活 VIP ") subTitle:@"" targetCls:nil];
    }


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
    
    SPCellGroupItem *feedbackGroup = [SPCellGroupItem itemWithItems:@[feedback]];
    feedbackGroup.headerView = [self getHeader];

    SPCellGroupItem *shakeTohideGroup = [SPCellGroupItem itemWithItems:@[shakeToHide]];
    shakeTohideGroup.headerView = [self getHeader];

    SPCellGroupItem *onlinePlayGroup = [SPCellGroupItem itemWithItems:@[onlinePlay]];
    onlinePlayGroup.headerView = [self getHeader];
    
    SPCellGroupItem *hadUnlockAllFuncGroup = [SPCellGroupItem itemWithItems:@[subScribe]];
    hadUnlockAllFuncGroup.headerView = [self getHeader];

    self.groupItems = @[feedbackGroup,shakeTohideGroup,onlinePlayGroup,hadUnlockAllFuncGroup];

    [self.tableView reloadData];
}




- (UIView *)getHeader {
    UIView *header = [[SPBaseView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 15)];
    return header;
}

#pragma mark --- SPIAPManagerDelegate
- (void)SPIAPManagerDidFinishPurchase:(NSString *)pid {
    if ([pid isEqualToString:kunlockForever]) {
        [SPGlobalConfigManager shareManager].hadUnlockAllFunctionForeverStatus = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:khadUnlockAllFuncForeverKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

// 购买凭证校验失败
- (void)SPIAPManagerVerfyFailed {
    [SPToastUtil showToast:kZHLocalizedString(@"凭证校验失败")];
}

- (void)SPIAPManagerCancelledOrFailed:(NSString *)pid {
    
}

@end

