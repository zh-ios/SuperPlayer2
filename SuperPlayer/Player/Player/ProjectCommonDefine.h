//
//  ProjectCommonDefine.h
//  ZHProject
//
//  Created by hz on 2021/11/8.
//  Copyright © 2021 autohome. All rights reserved.
//

#ifndef ProjectCommonDefine_h
#define ProjectCommonDefine_h

#import "AppDelegate.h"


#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif




#define kIsIphoneX ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom>0)

#define kNavbarHeight (kIsIphoneX ? 88 : 64)
#define kTabbarHeight (kIsIphoneX ? 83 : 49)
// 底部的安全距离
#define kBottomSafeArea     (kIsIphoneX ? 34 : 0)
// 顶部的安全距离,包括状态栏的高度
#define kTopSafeArea        (kIsIphoneX ? 44 : 20)

#define kStatusBarHeight    ([[UIApplication sharedApplication] statusBarFrame].size.heigh)

// iphoneX 顶部多出的距离
#define kTopInsetAreaOfIphoneX      (kIsIphoneX ? (kTopSafeArea-20) : 0)

#define kRandomColor            [UIColor colorWithRed:arc4random_uniform(125)/255.0 green:arc4random_uniform(125)/255.0 blue:arc4random_uniform(125)/255.0 alpha:0.7]
#define RGB(r,g,b)                                      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r,g,b,a)                                      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


#define onePixel 1/[UIScreen mainScreen].scale//一像素

#define kScreenWidth                                    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight                                   [UIScreen mainScreen].bounds.size.height

#define RUN_IN_MAIN_THREAD(block) dispatch_async(dispatch_get_main_queue(),block);



#define kSeparatorLineColor                             [UIColor colorWithHexString:@"eeeeee"]

#define kTextColor3                                     [UIColor colorWithHexString:@"333332"]
#define kTextColor6                                     [UIColor colorWithHexString:@"666667"]
#define kTextColor8                                     [UIColor colorWithHexString:@"888887"]
#define kTextColor9                                     [UIColor colorWithHexString:@"999998"]
#define kTextColore                                     [UIColor colorWithHexString:@"eeeeef"]

#define kOnlineVersionKey                               @"k_OnlineVersionKeyss"
#define kNewVersionIsOnline                             @"kNewVersionIsOnliness"
#define khadClickGoodCmtKey                             @"khadClickGoodCmtKeyss"
#define khadInstallApp                                  @"khadInstallAppss"

#define kAppDelegate                                    (AppDelegate *)[UIApplication sharedApplication].delegate


#define kFeedbackLight [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight] impactOccurred];
#define kFeedbackMedium [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium] impactOccurred];
#define kFeedbackHeavy [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy] impactOccurred];


// 判断字符串是否为空
#define kIS_STR_NIL(objStr) (![objStr isKindOfClass:[NSString class]] || objStr == nil || [objStr length] <= 0)

#define kSTR_IS_VALID(objStr) (!((![objStr isKindOfClass:[NSString class]] || objStr == nil || [objStr length] <= 0)))

#define kIS_DICT_NIL(objDict) (![objDict isKindOfClass:[NSDictionary class]] || objDict == nil || [objDict count] <= 0)
#define kIS_ARRAY_NIL(objArray) (![objArray isKindOfClass:[NSArray class]] || objArray == nil || [objArray count] <= 0)
#define kIS_NUM_NIL(objNum) (![objNum isKindOfClass:[NSNumber class]] || objNum == nil)
#define kIS_DATA_NIL(objData) (![objData isKindOfClass:[NSData class]] || objData == nil || [objData length] <= 0)
#define kIS_URL_NIL(objURL) (![objURL isKindOfClass:[NSURL class]] || objURL == nil || [[objURL absoluteString] length] <= 0)


#ifdef DEBUG
    #define NSLog(...) NSLog(__VA_ARGS__)
#else
    # define NSLog(...) {}
#endif


#define kResizedImage(name, imageWH) [[UIImage imageNamed:name] sd_resizedImageWithSize:CGSizeMake(imageWH, imageWH) scaleMode:2]

#define kZHLocalizedString(x)   NSLocalizedString(x, x)

#endif /* ProjectCommonDefine_h */
