//
//  ZHToastUtil.h
//  ZHProject
//
//  Created by zh on 2019/6/28.
//  Copyright © 2019 autohome. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHToastUtil : NSObject

+ (void)showLoadingWithTitle:(NSString*) title onView:(UIView *) view;

+ (void)endLoadingOnView:(UIView *) view;

+ (void)showToast:(NSString *) toast;

+ (void)showToast:(NSString *) toast completed:(nullable void(^)(void))completion;

+ (void)showToast:(NSString *) toast duration:(CGFloat)duration completed:(nullable void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
