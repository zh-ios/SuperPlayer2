//
//  SPGoodCommentManager.m
//  Player
//
//  Created by hz on 2022/1/5.
//

#import "SPGoodCommentManager.h"

#import "SPGoodCommentManager.h"
#import "SPIAPManager.h"
#import <StoreKit/StoreKit.h>
#import "SPIAPController.h"
#import "AppDelegate.h"
#import <StoreKit/StoreKit.h>
#import "SPVersionManager.h"

@interface SPGoodCommentManager ()



@end

@implementation SPGoodCommentManager

static SPGoodCommentManager *_mgr;

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_mgr) {
            _mgr = [[self alloc] init];
        }
    });
    return _mgr;
}


- (void)startGoodCmt{
    // 如果是系统的，则一直走系统
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsSystemCommentStyle]) {
        [SKStoreReviewController requestReview];
        return;
    }
    // 使用系统评论
    if ([SPGlobalConfigManager shareManager].configModel.force_cmt_percent == 0) {
        [SKStoreReviewController requestReview];
        return;
    }
    
    // 是否已经好评过
    BOOL hadClickGoodCmt = [[NSUserDefaults standardUserDefaults] boolForKey:khadClickGoodCmtKey];
    self.hadClickGoodCmt = hadClickGoodCmt;
    if (hadClickGoodCmt) { // 点击过好评论过
        return;
    }
    
//    BOOL buyAllStatus = [SPGlobalConfigManager shareManager].unlockAllFunc;
//    if (buyAllStatus) return;
    
    NSInteger temp = arc4random_uniform(100)+1;
    if ([SPGlobalConfigManager shareManager].configModel.force_cmt_percent >= temp) {
        // 使用准备文字的好评
        if ([SPGlobalConfigManager shareManager].configModel.show_preparedtext_cmt_Percent > 0) {
            // 控制几率,之前逻辑反了
            if ([SPGlobalConfigManager shareManager].configModel.show_preparedtext_cmt_Percent > arc4random_uniform(100)+1) {
                [self showInputCommentAlertWithPreparedText];
            } else {
                [self showCommentAlert];
            }
        } else {
            // 1/2几率
            if (arc4random_uniform(2) == 1) {
                [self showCommentAlert];
            } else {
                [self showInputCommentAlertWithPreparedText];
            }
        }
    } else {
        [SKStoreReviewController requestReview];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsSystemCommentStyle];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
}


- (void)showCommentAlert {
    UIAlertController *alert = [UIAlertController  alertControllerWithTitle: kZHLocalizedString(@"五星+文字 好评送福利啦 😘~ ") message:kZHLocalizedString(@"1、加密视频个数及空间不限！\n\n2、免费观看小姐姐视频！\n\n3、永久去除广告!\n\n好评后将免费送您3项 Vip 会员功能") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *fufei = [UIAlertAction actionWithTitle:kZHLocalizedString(@"付费获取！") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        SPIAPController *iap = [[SPIAPController alloc] init];
        iap.hidesBottomBarWhenPushed = YES;
        [[UIViewController currentVC].navigationController pushViewController:iap animated:YES];
        
    }];
    [alert addAction:fufei];

    UIAlertAction *goodCmt = [UIAlertAction actionWithTitle:kZHLocalizedString(@"给好评免费获取") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[AppInfoTool getCommentURLStr]] options:@{} completionHandler:nil];

        // 存储
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:khadClickGoodCmtKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [SPGlobalConfigManager shareManager].hadClickGoodCmt = YES;
    }];
    [alert addAction:goodCmt];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}
- (void)showInputCommentAlertWithPreparedText {
    UIAlertController *alert = [UIAlertController  alertControllerWithTitle: kZHLocalizedString(@"五星+文字 好评送福利啦 😘~ ") message:kZHLocalizedString(@"1、加密视频个数及空间不限！\n\n2、免费观看小姐姐视频！\n\n3、永久去除广告!\n\n好评后将免费送您3项 Vip 会员功能") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *fufei = [UIAlertAction actionWithTitle:kZHLocalizedString(@"付费获取！") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        SPIAPController *iap = [[SPIAPController alloc] init];
        iap.hidesBottomBarWhenPushed = YES;
        [[UIViewController currentVC].navigationController pushViewController:iap animated:YES];
        
    }];
    [alert addAction:fufei];

    UIAlertAction *goodCmt = [UIAlertAction actionWithTitle:kZHLocalizedString(@"给好评免费获取") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        pb.string = [self.class getCmtString];
        [ZHToastUtil showToast:kZHLocalizedString(@"评语已复制，直接粘贴即可😘~") duration:1.5 completed:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[AppInfoTool getCommentURLStr]] options:@{} completionHandler:nil];
        }];

        // 存储
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:khadClickGoodCmtKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [SPGlobalConfigManager shareManager].hadClickGoodCmt = YES;
    }];
    [alert addAction:goodCmt];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (NSString *)getCmtString {
    uint32_t count = (uint32_t)[self cmtDatas].count;
    NSString *cmtStr = [self cmtDatas][arc4random_uniform(count)];
    if (arc4random_uniform(11) > 7) {
        NSString *str2 = [self cmtDatas][arc4random_uniform(count)];
        return [NSString stringWithFormat:@"%@，%@",cmtStr, str2];
    }
    return cmtStr;
}

+ (NSArray *)cmtDatas {
    if ([SPGlobalConfigManager shareManager].configModel.cmts.count > 0) {
        return [SPGlobalConfigManager shareManager].configModel.cmts;
    }
    return @[
       
    ];
}

@end
