//
//  UIView+CornerRadius.h
//  Player
//
//  Created by hz on 2022/2/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIView (CornerRadius)


// 通过path 方式 设置不同地方的圆角
- (void)addCornerRadius:(UIRectCorner)corner size:(CGSize)size;


// 通过layer 方式直接添加圆角
- (void)addCornerRadius:(CGFloat)radius;



@end

NS_ASSUME_NONNULL_END
