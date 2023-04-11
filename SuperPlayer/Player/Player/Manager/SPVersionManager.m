//
//  SPVersionManager.m
//  Player
//
//  Cressssated by hzdddddd sxxxx on sky dat 2022/1/6.
//

#import "SPVersionManager.h"
#import "AFNetworkReachabilityManager.h"
#import "AppInfoTool.h"
#import "NetHelper.h"


@interface SPVersionManager ()

@end

@implementation SPVersionManager

static SPVersionManager *_mgr = nil;

+ (instancetype)sharedMgr {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_mgr) {
            _mgr = [[self alloc] init];
        }
    });
    return _mgr;
}

- (BOOL)isNewVersionAvailable {
    return NO;
}

- (NSString *)weburl {
    if (_weburl) {
        return @"https://cn.bing.com/?mkt=zh-CN";
    }
    return _weburl;
}

- (void)getAppVersionInfo {
    self.currentVersion = [AppInfoTool getAppVersion];
    self.onlineVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kOnlineVersionKey];
    

    [self getOnLineAppInfo];
    
    if (!self.onlineVersion) self.onlineVersion = self.currentVersion;
    // 已经是最新版本
    if ([self.onlineVersion isEqualToString:self.currentVersion]) {
        self.isLatestVersion = YES;
    }
    // 针对第一次安装 app 的情况
    [self checkNetWorkStatus];
}

- (void)checkNetWorkStatus {
    
    BOOL hadInstall = [[NSUserDefaults standardUserDefaults] boolForKey:khadInstallApp];
    if (hadInstall) return;
    
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];

    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(kZHLocalizedString(@"未知网络"));
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                NSLog(kZHLocalizedString(@"没有网络(断网)"));
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(kZHLocalizedString(@"手机自带网络"));
                [self getOnLineAppInfo];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"WIFI");
                [self getOnLineAppInfo];
                break;
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
}


- (void)forceUpdate {
    if (self.isLatestVersion) return;
    if (!self.isNewVersionAvailable) return;
    
    // TODO 更新的内容
}

- (void)getOnLineAppInfo {

    if ([NetHelper getProxyStatus]) return;
    NSInteger localVersion = [[AppInfoTool  getAppVersion] floatValue] * 10;
    //  新版本是否上线
    NSString *versionKey = [NSString stringWithFormat:@"%@_%@",kNewVersionIsOnline, @(localVersion)];
    BOOL online = [[NSUserDefaults standardUserDefaults] boolForKey:versionKey];
    self.isNewVersionAvailable = online;
    // 是最新版本
    if (self.isLatestVersion) return;
    if (self.isNewVersionAvailable) return;

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSData *rawData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://raw.githubusercontent.com/zh-ios/project_remote_config/main/config_text"]];
//        NSError *error = nil;
//        NSDictionary *configJSON = [NSJSONSerialization JSONObjectWithData:rawData options:NSJSONReadingAllowFragments error:&error];
//        if ([configJSON[@"is_new_version_available"] boolValue]) {
//            self.isNewVersionAvailable = YES;
//            self.onlineVersion = [AppInfoTool getAppVersion];
//            self.weburl = configJSON[@"web_url"];
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:versionKey];
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:khadInstallApp];
//            // 存储当前线上版本
//            [[NSUserDefaults standardUserDefaults] setObject:self.onlineVersion forKey:kOnlineVersionKey];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            if (self.latestVersionOnlineCallback) {
//                self.latestVersionOnlineCallback();
//            }
//        }
    });
}

@end
