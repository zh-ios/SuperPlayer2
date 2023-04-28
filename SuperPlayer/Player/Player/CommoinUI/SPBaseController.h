//
//  SPBaseController.h
//  ZHProject
//
//  Created by zhxxxx  ondfasd 2018/9/27.
//  Copyright © 2023 zhsxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPNavigationDefine.h"
#import "SPNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPBaseController : UIViewController


/**
 从当前控制器 push 出去的anitionType, 如从AVC push 到 BVC,需要设置 BVC.animationType = ...
 */


@property (nonatomic, assign) NaviAnimationType animationType;

@property (nonatomic, strong) SPNavigationBar *customNaviView;


/**
 是否显示导航底部线，默认NO
 */
@property (nonatomic, assign) BOOL showNavBottomLine;

/**
  是否允许左滑返回手势
 */
@property (nonatomic, assign) BOOL panGestureEnabled;



/**
 如果需要自定义点击返回事件，重写此方法

 @param btn 返回btn
 */
- (void)backBtnOnClicked:(SPBaseButton *)btn;

@end

NS_ASSUME_NONNULL_END
