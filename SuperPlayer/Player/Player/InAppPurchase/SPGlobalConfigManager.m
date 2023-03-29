//
//  GlobalStatusManager.m
//  ZHProject
//
//  Created by zh on 2019/8/21.
//  Copyright © 2019 autohome. All rights reserved.
//

#import "SPGlobalConfigManager.h"
#import "NetHelper.h"
#import "NSDate+AHDateUtil.h"
#import "SPIAPManager.h"
#import "YYCache.h"

@implementation RemoteConfigModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (BOOL)is_new_version_online {
    return _is_new_version_online;
}

- (NSString *)webview_url {
    if ([SPIAPManager shareManager].isMainland) {
        return self.webview_url_cn;
    } else {
        return self.webview_url_en;
    }
}

@end

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

- (BOOL)unlockAllFunc {
//#ifdef DEBUG
//    return YES;
//#endif
    return _unlockAllFunc;
}

- (instancetype)init {
    if (self = [super init]) {

        self.unlockAllFuncForeverStatus = [[NSUserDefaults standardUserDefaults] boolForKey:kUnlockAllFuncForeverKey];
        self.openAllScreenLockStatus = [[NSUserDefaults standardUserDefaults] boolForKey:kAllScreenLockKey];
        self.speedupStatus = [[NSUserDefaults standardUserDefaults] boolForKey:kSpeedupStatusKey];

        self.iapExpireTs = [[[NSUserDefaults standardUserDefaults] objectForKey:kIAP_Expire_Ts] longLongValue];

        long long crtTs = [[NSDate date] timeIntervalSince1970]*1000;
        BOOL subscribed = (crtTs<=self.iapExpireTs);

        // 订阅或者永久购买
        if (self.unlockAllFuncForeverStatus || subscribed) {
            _unlockAllFunc = YES;
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
        
        [self addObserver];
        
        [self requestRemoteData];
    }
    return self;
}

- (void)requestRemoteData {

//#ifdef DEBUG
//    NSString *testJSON = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"];
//    NSData *jsonData = [NSData dataWithContentsOfFile:testJSON];
//    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
//    self.configModel = [[RemoteConfigModel alloc] initWithDictionary:jsonDict error:nil];
//    NSLog(@"%@",self.configModel);
//#endif

    NSDictionary *cachedDict = [[NSUserDefaults standardUserDefaults] objectForKey:kRemoteConfigDataKey];
    if (cachedDict && [cachedDict isKindOfClass:NSDictionary.class]) {
        self.configModel = [[RemoteConfigModel alloc] initWithDictionary:cachedDict error:nil];
    }
    @weakify(self);
//    super_player_rc
    [NetHelper GET:@"https://gitee.com/zhsxx/super_player_rc/raw/master/super_player_rc" parameters:nil success:^(id responseObject) {
        @strongify(self);
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            self.configModel = [[RemoteConfigModel alloc] initWithDictionary:responseObject error:nil];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:kRemoteConfigDataKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    } failure:^(MiNetError *error) {

    }];
}

- (void)updateIAPWithExpireTs:(long long)expireTs {

    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",@(expireTs)] forKey:kIAP_Expire_Ts];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.iapExpireTs = expireTs;
    
    long long crtTs = [[NSDate date] timeIntervalSince1970]*1000;
    BOOL subscribed = (crtTs<=self.iapExpireTs);

    // 订阅或者永久购买
    if (self.unlockAllFuncForeverStatus || subscribed) {
        _unlockAllFunc = YES;
    }
}


- (void)setUnlockAllFuncForeverStatus:(BOOL)unlockAllFuncForeverStatus {
    _unlockAllFuncForeverStatus = unlockAllFuncForeverStatus;
    if (unlockAllFuncForeverStatus) {
        _unlockAllFunc = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUnlockAllFuncForeverKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}


static NSString *kRandomVideoDateKey = @"kRandomVideoDateKey";

- (void)didBecomeActive {
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:kRandomVideoDateKey];
    BOOL isSameDay = [[NSDate date] isEqualToDateIgnoringTime:date];
    if (!isSameDay) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kRandomFreeGirlVideoMaxCountKey];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kRandomVideoDateKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (BOOL)shouldShowIAPAlertWhilePlayOnlineVideos {
    if (self.unlockAllFunc) return NO;
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
