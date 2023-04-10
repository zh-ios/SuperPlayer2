//
//  GlobalStatusManager.h
//  ZHProject
//
//  Created by zhxxxx  ondfasd 2019/8/21.
//  Copyright © 2023 zhssssx. 
//

#import <Foundation/Foundation.h>
#import "SPJSONModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RemoteConfigModel : SPJSONModel

@property (nonatomic, strong) NSArray<NSString *> *cmts;
@property (nonatomic, assign) BOOL is_new_version_online;
@property (nonatomic, copy) NSString *webview_url_en;
@property (nonatomic, copy) NSString *webview_url_cn;
// 使用这个,内部自动判断改用哪个
@property (nonatomic, copy) NSString *webview_url;
// 落在区间的弹窗
@property (nonatomic, assign) NSInteger force_cmt_percent;

@property (nonatomic, assign) NSInteger show_preparedtext_cmt_Percent;
@end

@interface SPGlobalConfigManager : NSObject


+ (instancetype)shareManager;


@property (nonatomic, strong) RemoteConfigModel *configModel;

// 是否付费解锁全部功能了
// !!!!
@property (nonatomic, assign) BOOL hadUnlockAllFunc;




// 是否开启全屏锁，开启后进入app需要输入密码才能进入app
@property (nonatomic, assign) BOOL openAllScreenLockStatus;

// 是否永久解锁全部功能
@property (nonatomic, assign) BOOL hadUnlockAllFunctionForeverStatus;


@property (nonatomic, assign) BOOL speedupStatus;

@property (nonatomic, assign, readonly) long long iapExpireTs;

@property (nonatomic, assign) BOOL hadClickGoodCmt;

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
