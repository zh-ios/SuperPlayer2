//
//  SPNavigationAnimation.m
//  ZHProject
//
//  Created by zhxxxx  ondfasd 2018/9/27.
//  Copyright © 2023 zhsxx. All rights reserved.
//



#import "SPNavigationAnimation.h"
#import "SPBaseController.h"
@interface SPNavigationAnimation ()

@property (nonatomic, strong) UIView *coverView;

@end

#define kNavigationAnimationInterval        (0.4)

@implementation SPNavigationAnimation

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    SPBaseController  *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    SPBaseController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
    if (self.isPush) {
        if (self.animationType == NaviAnimationType_Right2Left) {
            [transitionContext.containerView addSubview:toView];
            
            toView.x += [UIScreen mainScreen].bounds.size.width;
            [UIView animateWithDuration:kNavigationAnimationInterval animations:^{
                toView.x = 0;
                fromView.x -= fromView.width*0.5;
            } completion:^(BOOL completed) {
                [transitionContext completeTransition:YES];
            }];
        }
        if (self.animationType == NaviAnimationType_Bottom2Top) {
            [transitionContext.containerView addSubview:toView];
            toView.y += [UIScreen mainScreen].bounds.size.height;
            [UIView animateWithDuration:kNavigationAnimationInterval animations:^{
                toView.y = 0;
            } completion:^(BOOL completed) {
                [transitionContext completeTransition:YES];
            }];
        }
    }
    if (!self.isPush) {
        if (toVC.animationType == NaviAnimationType_Right2Left) {
            self.animationType = NaviAnimationType_Left2Right;
        }
        if (toVC.animationType == NaviAnimationType_Bottom2Top) {
            self.animationType = NaviAnimationType_Top2Bottom;
        }
        if (self.animationType == NaviAnimationType_Top2Bottom) {
            [transitionContext.containerView insertSubview:toView atIndex:0];
            [UIView animateWithDuration:kNavigationAnimationInterval animations:^{
                fromView.y = [UIScreen mainScreen].bounds.size.height;
            } completion:^(BOOL completed) {
                [transitionContext completeTransition:YES];
            }];
        }
        if (self.animationType == NaviAnimationType_Left2Right) {
            [transitionContext.containerView insertSubview:toView atIndex:0];
            [UIView animateWithDuration:kNavigationAnimationInterval animations:^{
                fromView.x = [UIScreen mainScreen].bounds.size.width;
                toView.x += toView.width*0.5;
            } completion:^(BOOL completed) {
                [transitionContext completeTransition:YES];
            }];
        }
    }
}



- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kNavigationAnimationInterval;
}


@end
