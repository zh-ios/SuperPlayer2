//
//  MainTabBarController.m
//  CYLTabBarController
//
//  v1.21.x Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2015 https://github.com/ChenYilong . All rights reserved.
//
#import "MainTabBarController.h"
#import <UIKit/UIKit.h>

static CGFloat const CYLTabBarControllerHeight = 40.f;

//View Controllers
#import "SPNavigationController.h"
#import "SPProfileController.h"
#import "SPFileManagerController.h"
#import "SPLockedController.h"
#import <CoreMotion/CoreMotion.h>
#import <CoreMotion/CoreMotion.h>

#define RANDOM_COLOR [UIColor colorWithHue: (arc4random() % 256 / 256.0) saturation:((arc4random()% 128 / 256.0 ) + 0.5) brightness:(( arc4random() % 128 / 256.0 ) + 0.5) alpha:1]

@interface MainTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, weak) SPBaseButton *selectedCover;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, assign) BOOL showVIPVideos;

@end

@implementation MainTabBarController

- (instancetype)initWithContext:(NSString *)context {
    
    self.showVIPVideos = ![[NSUserDefaults standardUserDefaults] boolForKey:kHadHideVipVideos];
    [SPGlobalConfigManager shareManager].hadHideVipVideos = !self.showVIPVideos;
    /**
     * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
     * 等 效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
     * 更推荐后一种做法。
     */
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;//UIEdgeInsetsMake(4.5, 0, -4.5, 0);
    UIOffset titlePositionAdjustment = UIOffsetMake(0, 3.5);
    if (self = [super initWithViewControllers:[self viewControllersForTabBar]
                        tabBarItemsAttributes:[self tabBarItemsAttributesForTabBar]
                                  imageInsets:imageInsets
                      titlePositionAdjustment:titlePositionAdjustment
                                      context:context
                ]) {
        [self customizeTabBarAppearanceWithTitlePositionAdjustment:titlePositionAdjustment];
        self.delegate = self;
        self.navigationController.navigationBar.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    [self addMotionManager];
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
    
    if ([UIViewController currentVC].navigationController.childViewControllers.count > 1) return;
    //综合3个方向的加速度
    double accelerameter = sqrt( pow( acceleration.x,2) + pow( acceleration.y,2) + pow( acceleration.z,2) );

    //当综合加速度大于2.3时，就激活效果（此数值根据需求可以调整，数据越小，用户摇动的动作就越小，越容易激活，反之加大难度，但不容易误触发）

    if(accelerameter>2.3) {
       // 停止更新加速仪(如果业务需要)（很重要！）
       [self.motionManager stopAccelerometerUpdates];
       // 2s 后再继续更新方式 多次摇动出现错误
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [self startAccelerometer];
       });
        
       dispatch_async(dispatch_get_main_queue(), ^{
           //UI线程必须在此block内执行，例如摇一摇动画、UIAlertView之类
           if ([SPGlobalConfigManager shareManager].hadHideVipVideos) {
               [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kHadHideVipVideos];
               [[NSUserDefaults standardUserDefaults] synchronize];
               AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
               delegate.tabbar = [self initWithContext:nil];
               delegate.tabbar.selectedIndex = 0;
               kFeedbackHeavy
           } else {
               [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHadHideVipVideos];
               [[NSUserDefaults standardUserDefaults] synchronize];
               AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
               delegate.tabbar = [self initWithContext:nil];
               delegate.tabbar.selectedIndex = 0;
               kFeedbackHeavy
           }
       });
   }
}


- (NSArray *)viewControllersForTabBar {
    SPFileManagerController *firstViewController = [[SPFileManagerController alloc] init];
    firstViewController.customNaviView.backBtn.hidden = YES;
    UIViewController *firstNavigationController = [[SPNavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    SPLockedController *secondViewController = [[SPLockedController alloc] init];
    secondViewController.customNaviView.backBtn.hidden = YES;
    UIViewController *secondNavigationController = [[SPNavigationController alloc]
                                                    initWithRootViewController:secondViewController];

    SPProfileController *thirdViewController = [[SPProfileController alloc] init];
    thirdViewController.customNaviView.backBtn.hidden = YES;
    UIViewController *thirdNavigationController = [[SPNavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    
    NSArray *viewControllers = @[firstNavigationController,secondNavigationController,thirdNavigationController];
    if (!self.showVIPVideos) {
        viewControllers = @[firstNavigationController,thirdNavigationController];
    }
    return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForTabBar {
    // lottie动画的json文件来自于NorthSea, respect!
    CGFloat firstXOffset = -12/2;
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : kZHLocalizedString(@"视频"),
                                                 CYLTabBarItemImage : @"sp_icon_tab_video_nm",
                                                 CYLTabBarItemSelectedImage : @"sp_icon_tab_video_hl",
                                                 CYLTabBarItemTitlePositionAdjustment: [NSValue valueWithUIOffset:UIOffsetMake(firstXOffset, 5)],
                                        
                                                 };
    CGFloat secondXOffset = (-25+2)/2;
    NSDictionary *secondTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : kZHLocalizedString(@"VIP"),
                                                  CYLTabBarItemImage : @"sp_icon_tab_vip_nm",
                                                  CYLTabBarItemSelectedImage : @"sp_icon_tab_vip_hl",
                                                  CYLTabBarItemTitlePositionAdjustment: [NSValue valueWithUIOffset:UIOffsetMake(secondXOffset, 5)],
                                                
                                                  };
    
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : kZHLocalizedString(@"我"),
                                                 CYLTabBarItemImage : @"sp_icon_tab_me_nm",
                                                 CYLTabBarItemSelectedImage : @"sp_icon_tab_me_hl",
                                                 CYLTabBarItemTitlePositionAdjustment: [NSValue valueWithUIOffset:UIOffsetMake(-secondXOffset, 5)],
                                                 
                                                 };

    NSArray *tabBarItemsAttributes = @[firstTabBarItemsAttributes,secondTabBarItemsAttributes,thirdTabBarItemsAttributes];
    if (!self.showVIPVideos) {
        tabBarItemsAttributes = @[firstTabBarItemsAttributes,thirdTabBarItemsAttributes];
    }
    return tabBarItemsAttributes;
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearanceWithTitlePositionAdjustment:(UIOffset)titlePositionAdjustment {
    // Customize UITabBar height
    // 自定义 TabBar 高度
    // tabBarController.tabBarHeight = CYL_IS_IPHONE_X ? 65 : 40;
    
    [self rootWindow].backgroundColor = [UIColor cyl_systemBackgroundColor];
    
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = kThemeBeginColor;
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = kThemeEndColor;

    // NO.1，using Image note:recommended.推荐方式
    // set the bar shadow image
    // without shadow : use -[[CYLTabBarController hideTabBarShadowImageView] in CYLMainRootViewController.m
    UIColor *tabbarBgColor = [kThemeMiddleColor colorWithAlphaComponent:0.04];
    if (@available(iOS 13.0, *)) {
        UITabBarItemAppearance *inlineLayoutAppearance = [[UITabBarItemAppearance  alloc] init];
        // fix https://github.com/ChenYilong/CYLTabBarController/issues/456
        inlineLayoutAppearance.normal.titlePositionAdjustment = titlePositionAdjustment;

        // set the text Attributes
        // 设置文字属性
        [inlineLayoutAppearance.normal setTitleTextAttributes:normalAttrs];
        [inlineLayoutAppearance.selected setTitleTextAttributes:selectedAttrs];

        UITabBarAppearance *standardAppearance = [[UITabBarAppearance alloc] init];
        standardAppearance.stackedLayoutAppearance = inlineLayoutAppearance;
        [[UITabBar appearance] setBackgroundColor:tabbarBgColor];
        //shadowColor和shadowImage均可以自定义颜色, shadowColor默认高度为1, shadowImage可以自定义高度.
        standardAppearance.shadowColor = [kThemeBeginColor colorWithAlphaComponent:0.5];
         standardAppearance.shadowImage = [[self class] imageWithColor:[kThemeBeginColor colorWithAlphaComponent:0.5] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 1)];
        self.tabBar.standardAppearance = standardAppearance;
    } else {
        // Override point for customization after application launch.
        // set the text Attributes
        // 设置文字属性
        UITabBarItem *tabBar = [UITabBarItem appearance];
        [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
        [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
        [[UITabBar appearance] setBackgroundColor:tabbarBgColor];
        // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
        [[UITabBar appearance] setBackgroundImage:[[self class] imageWithColor:[kThemeBeginColor colorWithAlphaComponent:1] size:CGSizeMake(kScreenWidth, kTabbarHeight)]];
        [[UITabBar appearance] setShadowImage:[[self class] imageWithColor:[kThemeBeginColor colorWithAlphaComponent:0.5] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 1)]];
    }
}

+ (UIImage *)scaleImage:(UIImage *)image {
    CGFloat halfWidth = image.size.width/2;
    CGFloat halfHeight = image.size.height/2;
    UIImage *secondStrechImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(halfHeight, halfWidth, halfHeight, halfWidth) resizingMode:UIImageResizingModeStretch];
    return secondStrechImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//缩放动画
- (void)addOnceScaleAnimationOnView:(UIView *)animationView {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@0.5, @1.0];
    animation.duration = 0.1;
    //    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

#pragma mark - delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    UIView *animationView;
    animationView = [control cyl_tabImageView];

    SPBaseButton *button = CYLExternPlusButton;
    BOOL isPlusButton = [control cyl_isPlusButton];
    // 即使 PlusButton 也添加了点击事件，点击 PlusButton 后也会触发该代理方法。
    if (isPlusButton) {
        animationView = button.imageView;
    }
    [self addScaleAnimationOnView:animationView repeatCount:1];
    [self addRotateAnimationOnView:animationView];//暂时不推荐用旋转方式，badge也会旋转。
}

//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

//旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView {
    // 针对旋转动画，需要将旋转轴向屏幕外侧平移，最大图片宽度的一半
    // 否则背景与按钮图片处于同一层次，当按钮图片旋转时，转轴就在背景图上，动画时会有一部分在背景图之下。
    // 动画结束后复位
    animationView.layer.zPosition = 65.f / 2;
    [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
        } completion:nil];
    });
}

@end
