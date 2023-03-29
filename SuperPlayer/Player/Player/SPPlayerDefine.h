//
//  TSSCDefine.h
//  ZHProject
//
//  Created by zh on 2019/5/24.
//  Copyright © 2019 autohome. All rights reserved.
//




#import <Foundation/Foundation.h>


#ifndef TSSCDefine_h
#define TSSCDefine_h





#define kAllThemeKey                                    @"AllLocalThemes"
#define kPlaceholderImageName                           @"kPlaceholderImageName"

// 高亮颜色
//#A9D3F1
#define kTextHighlightColor                        [UIColor colorWithHexString:@"30A4F1"]
// 首页诗句字体大小
#define kTextDefaultFontSize                            (22)


// 当设置为44时正好是 nav 高度
#define kMenuViewHieght                                 44


#define kSearchHistoryKey                               @"kSearchHistoryKey"

// 是否设置过密码
#define kHadSetPwd                                      @"kHadSetPwd"
// 设置的密码
#define kPwd                                            @"kUserSetSimplePwd"
// 是否展示过加密提示（只展示一次）
#define kHadShowLockTips                                @"kHadShowLockTips"
// 本地启动不再展示
#define kDontShowThisTime                               @"kDontShowThisTime"

#define kFliterPoetryBelowStars                         (1000)

// 免费加密视频最大数量
#define kLockVideoMaxCount                              (10)
#define kRandomFreeGirlVideoMaxCount                         (5)
#define kRandomFreeGirlVideoMaxCountKey                 @"kRandomFreeGirlVideoMaxCountKey"


#define kThemeBeginColor                                [UIColor colorWithHexString:@"A9D3F1"]
#define kThemeMiddleColor                                [UIColor colorWithHexString:@"62B0EF"]
#define kThemeEndColor                                  [UIColor colorWithHexString:@"30A4F1"]


// 订阅到期
#define kIAP_Expire_Ts                               @"kIAP_Expire_Ts"

#define kSpeedupStatusKey                               @"kSpeedupStatusKey"
#define kUnlockAllFuncForeverKey                        @"kUnlockAllFuncForeverKey"
#define kAllScreenLockKey                               @"kAllScreenLockKey"

//pwdLabel.text = @"●  ●  ●  ○";
//break;
//case 2:
//self.pwdLabel.text = @"●  ●  ○  ○";
//break;
//case 1:
//self.pwdLabel.text = @"●  ○  ○  ○";
//break;
//case 0:
//self.pwdLabel.text = @"○  ○  ○  ○";

#define kPWDInputZeroNumerStr                        @"○   ○   ○   ○"
#define kPWDInputOneNumerStr                         @"●   ○   ○   ○"
#define kPWDInputTwoNumerStr                         @"●   ●   ○   ○"
#define kPWDInputThreeNumerStr                       @"●   ●   ●   ○"
#define kPWDInputFourNumerStr                        @"●   ●   ●   ●"


// 是否已经隐藏vipvideos
#define kHadHideVipVideos                            @"kHadHideVipVideos"
// 用户是否启用摇一摇隐藏功能
#define kUserUseShakeToHideFunc                      @"kUserUseShakeToHideFunc"

#define kUMengAppKey                                 @"6260d31230a4f67780ae65d0"


typedef NS_ENUM(NSInteger, ZHVideoDownloadStatus) {
    ZHVideoDownloadStatus_Downloading,
    ZHVideoDownloadStatus_Paused,
    ZHVideoDownloadStatus_Finished,
    ZHVideoDownloadStatus_Failed
};

// 下载相关key 后续可以优化成 const string 
#define HWDownloadStateChangeNotification               @"HWDownloadStateChangeNotification"
#define HWDownloadMaxConcurrentCountKey                 @"HWDownloadMaxConcurrentCountKey"
#define HWDownloadMaxConcurrentCountChangeNotification  @"HWDownloadMaxConcurrentCountChangeNotification"
#define HWNetworkingReachabilityDidChangeNotification   @"HWNetworkingReachabilityDidChangeNotification"
#define HWDownloadAllowsCellularAccessKey               @"HWDownloadAllowsCellularAccessKey"
#define HWDownloadProgressNotification                  @"HWDownloadProgressNotification"
#define HWDownloadAllowsCellularAccessChangeNotification    @"HWDownloadAllowsCellularAccessChangeNotification"

#define kHadClick18YearOldAlert     @"kHadClick18YearOldAlert"

#define kSupportedVideoFormats      @[@"MP4",@"FLV",@"F4V",@"WEBM",\
                                    @"M4V",@"MOV",@"3GP",@"3G2",\
                                    @"RM",@"RMVB",\
                                    @"WMV",@"WMA",@"AVI",@"ASF",\
                                    @"MPG",@"MPEG",@"MPEG2",@"MPE",@"TS",@"TP",\
                                    @"DIV",@"DV",@"DIVX",\
                                    @"VOB",@"DAT",@"MKV",@"RAM",@"QT",@"FLI",@"MOD",\
                                    @"M3U8",@"M3U",\
                                    @"F4"\
                                    ]

#define kHadShowDemoVideos          @"kHadShowDemoVideos"

#define kRemoteConfigDataKey        @"kRemoteConfigDataKey"

#endif /* TSSCDefine_h */
