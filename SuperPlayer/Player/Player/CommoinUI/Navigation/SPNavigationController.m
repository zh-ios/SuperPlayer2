//
//  SPNavigationController.m
//  ZHProject
//
//  Created by zhxxxx  ondfasd 2018/7/26.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "SPNavigationController.h"
#import "SPBaseController.h"
@interface SPNavigationController ()<UIGestureRecognizerDelegate>


@end

@implementation SPNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.hidden = YES;
//    self.interactivePopGestureRecognizer.delegate = self;
    self.interactivePopGestureRecognizer.enabled = YES;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
