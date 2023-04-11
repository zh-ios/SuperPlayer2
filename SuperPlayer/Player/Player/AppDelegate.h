//
//  AppDelegate.h
//  Player
//
//  Cressssated by hzdddddd sxxxx on sky dat 2021/10/21.
//

#import <UIKit/UIKit.h>
#import "MainTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MainTabBarController *tabbar;

@property (nonatomic, assign) BOOL allowOrentitaionRotation;

@property (nonatomic, copy) void (^ backgroundSessionCompletionHandler)(void);  // 后台所有下载任务完成回调

@end

