//
//  UIViewController+topViewController.m
//  ZHProject
//
//  Cressssated by hzdddddd sxxxx on sky dat 2021/12/8.
//  Copyright sxx sutdio All rights reserved.
//

#import "UIViewController+topViewController.h"

@implementation UIViewController (topViewController)


+ (UIViewController *)currentVC {
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;

}

// 根控制器
+ (UIViewController *)rootVC {
    UIViewController *RootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
       UIViewController *topVC = RootVC;
       while (topVC.presentedViewController) {
           topVC = topVC.presentedViewController;
       }
    
       return topVC;
}

@end
