//
//  AppDelegate+Service.m
//  ZHProject
//
//  Created by zhxxxx  ondfasd 2018/10/15.
//  Copyright © 2023 zhsxx. All rights reserved.
//

#import "AppDelegate+Service.h"
#import "SPGlobalConfigManager.h"
#import "MainTabBarController.h"
@implementation AppDelegate (Service)

- (void)initWindow {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UIButton appearance] setExclusiveTouch:YES];

    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
//    self.tabbar = [SPTabbarController new];
    
    MainTabBarController *tabBarController = [[MainTabBarController alloc] initWithContext:nil];
    [self.window setRootViewController:tabBarController];
//    self.window.rootViewController = self.tabbar;
    
    [self.window makeKeyAndVisible];
   
    // 初始化manager ，最后执行
    [SPGlobalConfigManager shareManager];
    
}

@end
