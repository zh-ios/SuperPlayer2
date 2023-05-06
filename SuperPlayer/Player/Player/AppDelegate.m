//
//  AppDelegate.m
//  Player
//
//  Cressssated by hzdddddd sxxxx on sky dat 2021/10/21.
//

#import "AppDelegate.h"
#import "AppDelegate+Service.h"


#import "GCDWebUploader.h"
#import "SPIAPManager.h"
#import <StoreKit/StoreKit.h>
//#import "SDImageWebPCoder.h"

#import "ZFLandscapeRotationManager.h"
//#import "LOTAnimationView.h"
#import "NetHelper.h"
@interface AppDelegate ()

@property (nonatomic, strong) GCDWebUploader *webUploader;


@end



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kDontShowThisTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [SPGlobalConfigManager shareManager];
    
    // 初始化iap
    [[SPIAPManager shareManager] startMagager];
 
    /**
     webp支持
     */
    // Override point for customization after application launch.
//    SDImageWebPCoder *webPCoder = [SDImageWebPCoder sharedCoder];
//    [[SDImageCodersManager sharedMgr] addCoder:webPCoder];
//    
    [self initWindow];
    
    NSInteger ts = arc4random_uniform(160);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ts * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SKStoreReviewController requestReview];
    });
    return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // 重置
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kDontShowThisTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[SPIAPManager shareManager] stopManager];
}

// 应用处于后台，所有下载任务完成调用
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    _backgroundSessionCompletionHandler = completionHandler;
}

/// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    ZFInterfaceOrientationMask orientationMask = [ZFLandscapeRotationManager supportedInterfaceOrientationsForWindow:window];
    if (orientationMask != ZFInterfaceOrientationMaskUnknow) {
        return (UIInterfaceOrientationMask)orientationMask;
    }
    /// 这里是非播放器VC支持的方向
    return UIInterfaceOrientationMaskPortrait;
}

/// 进入后台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


@end
