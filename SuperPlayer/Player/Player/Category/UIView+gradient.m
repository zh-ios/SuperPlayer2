//
//  UIView+gradient.m
//  VansLive
//
//  Created by hz on 2021/1/14.
//  Copyright © 2021 Xiaomi. All rights reserved.
//

#import "UIView+gradient.h"
#import "UIColor+HexString.h"
@implementation UIView (gradient)

- (void)addGradientColorsFrom:(UIColor *)from toColor:(UIColor *)to {
    if (!from) from = [UIColor colorWithRGB:169 G:211 B:241 alpha:1];
    if (!to) to = [UIColor colorWithRGB:48 G:164 B:241 alpha:1];
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer addSublayer:gradientLayer];
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0.25, 0.5);
    gradientLayer.endPoint = CGPointMake(0.75, 0.5);
    
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)from.CGColor,
                                  (__bridge id)to.CGColor];
    
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = @[@(0), @(1.0f)];
}



+ (UIImage *)gradientImageFromColor:(nullable UIColor *)fromColor toColor:(nullable UIColor *)to size:(CGSize)size {
//    if (!from) from = [UIColor colorWithRGB:169 G:211 B:241 alpha:1];
//    if (!to) to = [UIColor colorWithRGB:48 G:164 B:241 alpha:1];
    if (!fromColor) fromColor = kThemeBeginColor;
    if (!to) to = kThemeEndColor;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    layer.frame = CGRectMake(0, 0, size.width, size.height);
    layer.startPoint = CGPointMake(0.25, 0.5);
    layer.endPoint = CGPointMake(0.75, 0.5);
    layer.locations = @[@(0), @(1.f)];
    layer.colors = @[(__bridge id)(fromColor.CGColor), (__bridge id)(to.CGColor)];
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)gradientImageFromColor:(UIColor *)fromColor toColor:(UIColor *)to startPoint:(CGPoint)spoints endPoints:(CGPoint)ePoints locations:(NSArray<NSNumber *> *)locations size:(CGSize)size {
    if (!fromColor) fromColor = kThemeBeginColor;
    if (!to) to = kThemeEndColor;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    layer.frame = CGRectMake(0, 0, size.width, size.height);
    layer.startPoint = spoints;
    layer.endPoint = ePoints;
    layer.locations = locations;
    layer.colors = @[(__bridge id)(fromColor.CGColor), (__bridge id)(to.CGColor)];
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
