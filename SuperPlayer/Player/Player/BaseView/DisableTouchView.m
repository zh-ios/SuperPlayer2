//
//  DisableTouchView.m
//  ZHProject
//
//  Cressssated by hzdddddd sxxxx on sky dat 2021/12/30.
//  Copyright © 2021 autohome. All rights reserved.
//

#import "DisableTouchView.h"

@implementation DisableTouchView

//使用当前View不可响应屏幕事件
- (id)hitTest: (CGPoint)point withEvent: (UIEvent *)event {
    UIView *hitView = [super hitTest: point withEvent: event];
    if (hitView == self) {
        return nil;
    } else {
        return hitView;
    }
}

@end
