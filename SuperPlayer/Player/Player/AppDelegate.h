//
//  AppDelegate.h
//  Player
//
//  Created by hz on 2021/10/21.
//

#import <UIKit/UIKit.h>
#import "SPTabbarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SPTabbarController *tabbar;

@property (nonatomic, assign) BOOL allowOrentitaionRotation;

@property (nonatomic, copy) void (^ backgroundSessionCompletionHandler)(void);  // 后台所有下载任务完成回调

@end

