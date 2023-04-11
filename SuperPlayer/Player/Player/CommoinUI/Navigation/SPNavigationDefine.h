//
//  SPNavigationDefine.h
//  ZHProject
//
//  Created by zhxxxx  ondfasd 2018/9/27.
//  Copyright © 2023 zhsxx. All rights reserved.
//

#ifndef SPNavigationDefine_h
#define SPNavigationDefine_h

typedef NS_ENUM (NSInteger, NaviAnimationType) {
    NaviAnimationType_Right2Left = 0, // push 进去
    NaviAnimationType_Bottom2Top,  // push进去 类似present动画
    NaviAnimationType_Left2Right, // pop 出来
    NaviAnimationType_Top2Bottom //  pop 出来类似 dismiss动画
};


#endif /* SPNavigationDefine_h */
