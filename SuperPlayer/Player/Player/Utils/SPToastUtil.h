//
//  SPToastUtil.h
//  ZHProject
//
//  Created by zhxxxx  ondfasd 2019/6/28.
//  Copyright © 2023 zhssssx. 
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPToastUtil : NSObject

+ (void)showLoadingWithTitle:(NSString*) title onView:(UIView *) view;

+ (void)endLoadingOnView:(UIView *) view;

+ (void)showToast:(NSString *) toast;

+ (void)showToast:(NSString *) toast completed:(nullable void(^)(void))completion;

+ (void)showToast:(NSString *) toast duration:(CGFloat)duration completed:(nullable void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
