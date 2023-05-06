//
//  SPNavigationBar.h
//  ZHProject
//
//  Created by zhxxxx  ondfasd 2018/7/26.
//  Copyright © 2023 zhsxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPNavigationBar : UIView
@property (nonatomic, strong) SPBaseButton *backBtn;
@property (nonatomic, copy) void (^backOnClick)(SPBaseButton *btn);
@property (nonatomic, strong) SPBaseLabel *titleL;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end
