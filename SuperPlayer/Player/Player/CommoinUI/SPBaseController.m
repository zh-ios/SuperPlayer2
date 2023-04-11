//
//  SPBaseController.m
//  ZHProject
//
//  Created by zhxxxx  ondfasd 2018/9/27.
//  Copyright © 2023 zhsxx. All rights reserved.
//

#import "SPBaseController.h"
#import "SPNavigationAnimation.h"
#import "SPNavigationController.h"
#import "SPNavigationBar.h"
@interface SPBaseController ()<UINavigationControllerDelegate>


@end

@implementation SPBaseController

- (void)setTitle:(NSString *)title {
    self.customNavView.titleL.text = title?:@"";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = self.panGestureEnabled;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 页面消失的时候，重置返回手势为可用
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.customNavView];
}

- (SPNavigationBar *)customNavView {
    if (!_customNavView) {
        _customNavView = [[SPNavigationBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kNavbarHeight)];
    }
    return _customNavView;
}

// 将 customnaviView 添加到每个页面控制器上，滑动返回的时候，navivie 也会跟着返回
// 如果要想微信 导航条不动，渐变的那种需要使用原生导航
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [SPAppThemeManager sharedMgr].viewBgColor;
    self.panGestureEnabled = YES;
    
    self.showNavBottomLine = NO;

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    @weakify(self)
    [self.view addSubview:self.customNavView];
    
    self.customNavView.backOnClick = ^(SPBaseButton *btn) {
    @strongify(self)
    [self backBtnOnClicked:btn];
    };
}

-(UIViewController *)currentViewController{
    
    UIViewController * currVC = nil;
    UIViewController * Rootvc = [UIApplication sharedApplication].keyWindow.rootViewController ;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        }else if([Rootvc isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }
    } while (Rootvc!=nil);
    
    return currVC;
}

- (void)backBtnOnClicked:(SPBaseButton *)btn {
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
//    if (operation == UINavigationControllerOperationPop) {
//        SPNavigationAnimation *animation = [[SPNavigationAnimation alloc] init];
//        animation.isPush = NO;
//        return animation;
//    }
//    if (operation == UINavigationControllerOperationPush) {
////        SPNavigationAnimation *animation = [[SPNavigationAnimation alloc] init];
////        animation.isPush = YES;
////        SPBaseController *fromViewController = (SPBaseController *)fromVC;
////        SPBaseController *toViewController = (SPBaseController *)toVC;
////        fromViewController.animationType = toViewController.animationType;
////        animation.animationType = toViewController.animationType;
//        return animation;
//    }
//    if (operation == UINavigationControllerOperationNone) {
//        return nil;
//    }
//    return nil;
//}

- (void)setShowNavBottomLine:(BOOL)showNavBottomLine {
    _showNavBottomLine = showNavBottomLine;
    self.customNavView.bottomLine.hidden = !showNavBottomLine;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



@end
