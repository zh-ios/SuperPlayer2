//
//  GlobalStatusManager.m
//  ZHProject
//
//  Created by zhxxxx  ondfasd 2019/8/21.
//  Copyright © 2023 zhssssx. 
//



#import "SPGlobalConfigManager.h"
#import "NSDate+AHDateUtil.h"
#import "SPIAPManager.h"
#import "YYCache.h"


@interface SPGlobalConfigManager ()

@property (nonatomic, assign, readwrite) long long iapExpireTs;

@end

@implementation SPGlobalConfigManager

static SPGlobalConfigManager *_mgr = nil;

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_mgr) {
            _mgr = [[SPGlobalConfigManager alloc] init];
        }
    });
    return _mgr;
}

- (BOOL)hadUnlockAllFunc {
//#ifdef DEBUG
//    return YES;
//#endif
    return _hadUnlockAllFunc;
}

- (instancetype)init {
    if (self = [super init]) {

        self.hadUnlockAllFunctionForeverStatus = [[NSUserDefaults standardUserDefaults] boolForKey:khadUnlockAllFuncForeverKey];
        self.openAllScreenLockStatus = [[NSUserDefaults standardUserDefaults] boolForKey:kAllScreenLockKey];

        self.iapExpireTs = [[[NSUserDefaults standardUserDefaults] objectForKey:kIAP_Expire_Ts] longLongValue];

        long long crtTs = [[NSDate date] timeIntervalSince1970]*1000;
        BOOL subscribed = (crtTs<=self.iapExpireTs);

        // 订阅或者永久购买
        if (self.hadUnlockAllFunctionForeverStatus || subscribed) {
            _hadUnlockAllFunc = YES;
        }
        
        self.hadHideVipVideos = [[NSUserDefaults standardUserDefaults] boolForKey:kHadHideVipVideos];
                
        NSString *enableShakeToHide = [[NSUserDefaults standardUserDefaults] objectForKey:kUserUseShakeToHideFunc];
        // 默认值未设置过
        if (!enableShakeToHide) {
            self.enalbleShakeToHideFunc = YES;
        } else {
            // 设置过
            self.enalbleShakeToHideFunc = [enableShakeToHide boolValue];
        }
    }
    return self;
}

- (void)updateIAPWithExpireTs:(long long)expireTs {

    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",@(expireTs)] forKey:kIAP_Expire_Ts];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.iapExpireTs = expireTs;
    
    long long crtTs = [[NSDate date] timeIntervalSince1970]*1000;
    BOOL subscribed = (crtTs<=self.iapExpireTs);

    // 订阅或者永久购买
    if (self.hadUnlockAllFunctionForeverStatus || subscribed) {
        _hadUnlockAllFunc = YES;
    }
}


- (void)sethadUnlockAllFunctionForeverStatus:(BOOL)hadUnlockAllFunctionForeverStatus {
    _hadUnlockAllFunctionForeverStatus = hadUnlockAllFunctionForeverStatus;
    if (hadUnlockAllFunctionForeverStatus) {
        _hadUnlockAllFunc = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:khadUnlockAllFuncForeverKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}



static NSString *kRandomVideoDateKey = @"kRandomVideoDateKeyKeyKey";
- (BOOL)shouldShowIAPAlertWhilePlayOnlineVideos {
    if (self.hadUnlockAllFunc) return NO;
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:kRandomFreeGirlVideoMaxCountKey];
    // 允许播放记录下播放的时间,
    if (count < kRandomFreeGirlVideoMaxCount) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kRandomVideoDateKey];
        
        // 次数+1
        count += 1;
        [[NSUserDefaults standardUserDefaults] setInteger:count forKey:kRandomFreeGirlVideoMaxCountKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return count > kRandomFreeGirlVideoMaxCount;
}


@end
