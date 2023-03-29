//
//  UIViewController+topViewController.h
//  ZHProject
//
//  Created by hz on 2021/12/8.
//  Copyright © 2021 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (topViewController)


//当前屏幕显示的viewcontroller
+ (UIViewController *)currentVC;

// 根控制器
+ (UIViewController *)rootVC;

@end

NS_ASSUME_NONNULL_END
