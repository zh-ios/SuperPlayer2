//
//  UIView+CornerRadius.m
//  Player
//
//  Created by hz on 2022/2/11.
//

#import "UIView+CornerRadius.h"

@implementation UIView (CornerRadius)

- (void)addCornerRadius:(UIRectCorner)corner size:(CGSize)size {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
}

@end
