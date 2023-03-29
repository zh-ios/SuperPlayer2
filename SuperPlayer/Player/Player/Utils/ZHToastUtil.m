//
//  ZHToastUtil.m
//  ZHProject
//
//  Created by zh on 2019/6/28.
//  Copyright © 2019 autohome. All rights reserved.
//

#import "ZHToastUtil.h"
#import "MBProgressHUD.h"

@implementation ZHToastUtil

static NSInteger const HUDViewTag = 222222222;
static NSInteger const ToastViewTag = 11111111;

+ (void)showLoadingWithTitle:(NSString *) title onView:(UIView *) view{
    
    MBProgressHUD *hud = [view viewWithTag:HUDViewTag];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    hud.removeFromSuperViewOnHide = YES;
    if (hud) {
        [hud hideAnimated:NO];
    }
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [[UIColor whiteColor] colorWithAlphaComponent:1];
    hud = [[MBProgressHUD alloc] initWithView:view];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    hud.tag = HUDViewTag;
    
    hud.alpha = 1.f;
    hud.label.font = [UIFont systemFontOfSize:14];
    hud.label.textColor = [UIColor whiteColor];
    hud.label.text = NSLocalizedString(title, @"HUD loading title");
    [view addSubview:hud];
    [hud showAnimated:YES];
}

+ (void)endLoadingOnView:(UIView *) view {
    MBProgressHUD *hud = [view viewWithTag:HUDViewTag];
    [hud hideAnimated:YES];
}

+ (void)showToast:(NSString *)toast {
    [self showToast:toast duration:1.5];
}
    
+ (void) showToast:(NSString *)toast duration:(CGFloat)duration {

    MBProgressHUD *toastHUD = [[UIApplication sharedApplication].keyWindow viewWithTag:ToastViewTag];
    if (toastHUD) {
        [toastHUD hideAnimated:NO];
    }

     MBProgressHUD *_hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
     _hud.mode = MBProgressHUDModeText;
     _hud.removeFromSuperViewOnHide = YES;

    _hud.offset = CGPointMake(0,0);
    _hud.label.numberOfLines = 0;
    _hud.label.text = toast;
    _hud.label.textColor = [UIColor whiteColor];
    _hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    _hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.8];
    _hud.bezelView.layer.cornerRadius = 3;
    _hud.userInteractionEnabled = NO;
    [_hud hideAnimated:YES afterDelay:1.5];
}

+ (void)showToast:(NSString *)toast completed:(nullable void (^)(void))completion {
    [self showToast:toast];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) {
            completion();
        }
    });
}

+ (void)showToast:(NSString *)toast duration:(CGFloat)duration completed:(void (^)(void))completion {
    [self showToast:toast duration:duration];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) {
            completion();
        }
    });
}



@end
