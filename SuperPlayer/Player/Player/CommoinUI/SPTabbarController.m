//
//  SPTabbarController.m
//  ZHProject
//
//  Created by zhxxxx  ondfasd 2018/10/15.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "SPTabbarController.h"
#import "SPNavigationController.h"
#import "SPProfileController.h"
#import "SPFileManagerController.h"
#import "SPLockedController.h"
#import "SPVersionManager.h"
#import <CoreMotion/CoreMotion.h>

@interface SPTabbarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) NSMutableArray *controllersArr;
@property (nonatomic, strong) NSMutableArray *tabbarBtnArr;
@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation SPTabbarController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabbarBtnArr = @[].mutableCopy;
    
    self.delegate = self;
    //初始化tabbar
    [self setUpTabBar];
    [self setupViewControllers];
    [self addMotionManager];
    
//    @weakify(self);
//    [SPVersionManager sharedManager].latestVersionOnlineCallback = ^{
//        @strongify(self);
//        [self setupViewControllers];
//    };
}

- (void)setupViewControllers {
    BOOL ret = [SPGlobalConfigManager shareManager].hadHideVipVideos;
    if (ret) {
        [self setupNormalViewController];
    } else {
        //添加子控制器
        [self setUpAllChildViewController];
    }
}

- (void)addMotionManager {
    
    // 已经初始化过了 
    if (self.motionManager) return;
    if (![SPGlobalConfigManager shareManager].enalbleShakeToHideFunc) return;
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterbackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterforeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self startAccelerometer];
}

- (void)appWillEnterforeground:(NSNotification *)noti {
    [self startAccelerometer];
}
- (void)appEnterbackground:(NSNotification *)noti {
    [self.motionManager stopMagnetometerUpdates];
}

-(void)startAccelerometer {

//以push的方式更新并在block中接收加速度

   [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc]init] withHandler:^(CMAccelerometerData*accelerometerData,NSError*error) {

       [self outputAccelertionData:accelerometerData.acceleration];

       if (error) {

       }
 }];
}


- (void)outputAccelertionData:(CMAcceleration)acceleration {

    if (![SPGlobalConfigManager shareManager].enalbleShakeToHideFunc) return;
    
    //综合3个方向的加速度
    double accelerameter = sqrt( pow( acceleration.x,2) + pow( acceleration.y,2) + pow( acceleration.z,2) );

    //当综合加速度大于2.3时，就激活效果（此数值根据需求可以调整，数据越小，用户摇动的动作就越小，越容易激活，反之加大难度，但不容易误触发）

    if(accelerameter>2.3f) {
       // 停止更新加速仪(如果业务需要)（很重要！）
       [self.motionManager stopAccelerometerUpdates];
       // 2s 后再继续更新方式 多次摇动出现错误
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [self startAccelerometer];
       });
       dispatch_async(dispatch_get_main_queue(), ^{
           //UI线程必须在此block内执行，例如摇一摇动画、UIAlertView之类
           if ([SPGlobalConfigManager shareManager].hadHideVipVideos) {
               [self setUpAllChildViewController];
               kFeedbackHeavy
           } else {
               [self setupNormalViewController];
               kFeedbackHeavy
           }
       });
   }
}
#pragma mark ————— init TabBar —————
- (void)setUpTabBar{
    UITabBar *tabbar = [[UITabBar alloc] initWithFrame:self.tabBar.frame];
    [self setValue:tabbar forKey:@"tabBar"];
    tabbar.translucent = NO;
    
    // 改变tabbar背景图片、分割线
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setShadowImage:[UIImage new]];
    
    //添加阴影
    self.tabBar.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -2);
    self.tabBar.layer.shadowOpacity = 0.6f;
    self.tabBar.layer.shadowRadius = 6.0f;
    
    if (@available(iOS 15.0, *)) {
        self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance;
    }
    
    // 解决字体会变蓝的问题
    self.tabBar.tintColor = kTextHighlightColor;

}

#pragma mark - ——————— init VC ————————
- (void)setUpAllChildViewController {
    
    self.controllersArr = @[].mutableCopy;
    
    SPFileManagerController *friendBattleVC = [[SPFileManagerController alloc] init];
    [self setupChildViewController:friendBattleVC title:kZHLocalizedString(@"视频") imageName:@"tab_icon_file" selectedImageName:@"tab_icon_file_selected"];
    
    SPLockedController *lockedVideos = [[SPLockedController alloc]init];
    [self setupChildViewController:lockedVideos title:kZHLocalizedString(@"VIP") imageName:@"tab_icon_movies" selectedImageName:@"tab_icon_movies_selected"];

    SPProfileController *profile = [[SPProfileController alloc] init];
    [self setupChildViewController:profile title:kZHLocalizedString(@"我") imageName:@"tab_icon_profile" selectedImageName:@"tab_icon_profile_selected"];
    
    self.viewControllers = self.controllersArr;
    
    [self.tabbarBtnArr removeAllObjects];
    for (UIView *view in self.tabBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            UIView *imageView = [[view subviews] firstObject];
            [self.tabbarBtnArr addObject:imageView];
        }
    }
    
    [SPGlobalConfigManager shareManager].hadHideVipVideos = NO;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kHadHideVipVideos];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setupNormalViewController {
    self.controllersArr = @[].mutableCopy;
    
    SPFileManagerController *friendBattleVC = [[SPFileManagerController alloc] init];
    [self setupChildViewController:friendBattleVC title:kZHLocalizedString(@"视频") imageName:@"tab_icon_file" selectedImageName:@"tab_icon_file_selected"];
    
    SPProfileController *profile = [[SPProfileController alloc] init];
    [self setupChildViewController:profile title:kZHLocalizedString(@"我") imageName:@"tab_icon_profile" selectedImageName:@"tab_icon_profile_selected"];
    
    self.viewControllers = self.controllersArr;
    
    [self.tabbarBtnArr removeAllObjects];
    for (UIView *view in self.tabBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            UIView *imageView = [[view subviews] firstObject];
            [self.tabbarBtnArr addObject:imageView];
        }
    }
    
    
    [SPGlobalConfigManager shareManager].hadHideVipVideos = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHadHideVipVideos];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)setupChildViewController:(SPBaseController *)controller title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectImageName {
    controller.title = title;
    controller.tabBarItem.title = title;
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 0, 0);
    
    // 调整文字间距
    controller.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
    
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kTextColor6,NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kTextHighlightColor,NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateSelected];
    // 隐藏返回按钮
    controller.customNavView.backBtn.hidden = YES;
    
    SPNavigationController *nav = [[SPNavigationController alloc] initWithRootViewController:controller];
    nav.navigationBar.hidden = YES;
    [self.controllersArr addObject:nav];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    kFeedbackLight 
    
    NSInteger index = [self.tabBar.items indexOfObject:item];
    UIView *animateView = self.tabbarBtnArr[index];
    //. 图片动画
    [self addRotationAnimation:animateView];
    [self addScaleAnimation:animateView];
}

- (void)addRotationAnimation:(UIView *)view {
    //创建一个关键帧动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //设置关键帧
    keyAnimation.values = @[@(-M_PI_4 * 0.15 * 1), @(M_PI_4 * 0.15 * 1), @(-M_PI_4 * 0.15 * 1)];
    keyAnimation.duration = 0.2;
    //设置重复
    keyAnimation.repeatCount = 2;
    
    //把核心动画添加到layer上
    [view.layer addAnimation:keyAnimation forKey:@"keyAnimation"];

}

- (void)addScaleAnimation:(UIView *)view {
   
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.2];
    scaleAnimation.autoreverses = YES;//自动反向执行动画效果
    scaleAnimation.repeatCount = 1;
    scaleAnimation.duration = 0.2;
    [view.layer addAnimation:scaleAnimation forKey:@"FlyElephant.scale"];

}

@end
