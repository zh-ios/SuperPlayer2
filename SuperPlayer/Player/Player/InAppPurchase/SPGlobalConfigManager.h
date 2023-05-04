//
//  GlobalStatusManager.h
//  ZHProject
//
//  Created by zhxxxx  ondfasd 2019/8/21.
//  Copyright © 2023 zhssssx. 
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@interface SPGlobalConfigManager : NSObject


+ (instancetype)shareManager;


// 是否付费解锁全部功能了
// !!!!
@property (nonatomic, assign) BOOL hadUnlockAllFunc;
// 是否开启全屏锁，开启后进入app需要输入密码才能进入app
@property (nonatomic, assign) BOOL openAllScreenLockStatus;

// 是否永久解锁全部功能
@property (nonatomic, assign) BOOL hadUnlockAllFunctionForeverStatus;

@property (nonatomic, assign, readonly) long long iapExpireTs;

@property (nonatomic, assign) BOOL hadHideVipVideos;
// 是否启用 摇动隐藏func
@property (nonatomic, assign) BOOL enalbleShakeToHideFunc;


/// 更新过期时间，只需要关系过期时间即可
/// @param expireTs 过期时间
- (void)updateIAPWithExpireTs:(long long)expireTs;

// 播放小姐姐视频是否应该弹出购买弹窗,每天免费播放5个
- (BOOL)shouldShowIAPAlertWhilePlayOnlineVideos;

@end

NS_ASSUME_NONNULL_END
