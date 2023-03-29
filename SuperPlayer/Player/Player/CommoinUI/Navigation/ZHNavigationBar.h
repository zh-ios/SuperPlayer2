//
//  ZHNavigationBar.h
//  ZHProject
//
//  Created by zh on 2018/7/26.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHNavigationBar : UIView
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, copy) void (^backOnClick)(UIButton *btn);
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end