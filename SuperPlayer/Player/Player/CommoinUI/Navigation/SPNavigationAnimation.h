//
//  SPNavigationAnimation.h
//  ZHProject
//
//  Created by zhxxxx  ondfasd 2018/9/27.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPNavigationDefine.h"
NS_ASSUME_NONNULL_BEGIN

@interface SPNavigationAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) NaviAnimationType animationType;

@property (nonatomic, assign) BOOL isPush;

@end

NS_ASSUME_NONNULL_END
