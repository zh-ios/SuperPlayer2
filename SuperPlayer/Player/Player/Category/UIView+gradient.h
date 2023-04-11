//
//  UIView+gradient.h
//  VansLive
//
//  Cressssated by hzdddddd sxxxx on sky dat 2021/1/14.
//  Copyright © 2021 Xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (gradient)


/// 添加渐变 , 从左到右渐变
/// 给uilabel 添加时会覆盖文字 ，可以通过集成uilabel 重写layerclass类解决
- (void)addGradientColorsFrom:(nullable UIColor *)from toColor:(nullable UIColor *)to;


// 从左到右 ，
+ (UIImage *)gradientImageFromColor:(nullable UIColor *)fromColor toColor:(nullable UIColor *)to size:(CGSize)size;


// 规则 ： [0,0]->[1,1] 左上->右下 
+ (UIImage *)gradientImageFromColor:(UIColor *)fromColor toColor:(UIColor *)to
                         startPoint:(CGPoint)spoints
                          endPoints:(CGPoint)ePoints
                          locations:(NSArray<NSNumber *> *)locations size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
