//
//  SPCustomPortraitControlView.h
//  Player
//
//  Created by zhuhao on 2023/1/18.
//

#import <UIKit/UIKit.h>
#import "ZFSliderView.h"

#if __has_include(<ZFPlayer/ZFPlayer.h>)
#import <ZFPlayer/ZFPlayerConst.h>
#else
#import "ZFPlayerConst.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface SPCustomPortraitControlView : UIView

/// 底部工具栏
@property (nonatomic, strong, readonly) UIView *bottomToolView;

/// 顶部工具栏
@property (nonatomic, strong, readonly) UIView *topToolView;

@property (nonatomic, strong) SPBaseButton *closeButton;

/// 标题
@property (nonatomic, strong, readonly) SPBaseLabel *titleLabel;

/// 播放或暂停按钮
@property (nonatomic, strong, readonly) SPBaseButton *playOrPauseBtn;

/// 播放的当前时间
@property (nonatomic, strong, readonly) SPBaseLabel *currentTimeLabel;

/// 滑杆
@property (nonatomic, strong, readonly) ZFSliderView *slider;

/// 视频总时间
@property (nonatomic, strong, readonly) SPBaseLabel *totalTimeLabel;

/// 全屏按钮
@property (nonatomic, strong, readonly) SPBaseButton *fullScreenBtn;

/// 播放器
@property (nonatomic, weak) ZFPlayerController *player;

/// slider滑动中
@property (nonatomic, copy, nullable) void(^sliderValueChanging)(CGFloat value,BOOL forward);

/// slider滑动结束
@property (nonatomic, copy, nullable) void(^sliderValueChanged)(CGFloat value);

/// 如果是暂停状态，seek完是否播放，默认YES
@property (nonatomic, assign) BOOL seekToPlay;

@property (nonatomic, copy) void (^downloadBtnClickCallbackBlock)(void);
@property (nonatomic, copy) void (^closeButtonOnClikedCallbackBlock)(void);


/// 全屏模式
@property (nonatomic, assign) ZFFullScreenMode fullScreenMode;

/// 重置控制层
- (void)resetControlView;

/// 显示控制层
- (void)showControlView;

/// 隐藏控制层
- (void)hideControlView;

/// 设置播放时间
- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime;

/// 设置缓冲时间
- (void)videoPlayer:(ZFPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime;

/// 是否响应该手势
- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(ZFPlayerGestureType)type touch:(nonnull UITouch *)touch;

/// 标题和全屏模式
- (void)showTitle:(NSString *_Nullable)title fullScreenMode:(ZFFullScreenMode)fullScreenMode;

/// 根据当前播放状态取反
- (void)playOrPause;

/// 播放按钮状态
- (void)playBtnSelectedState:(BOOL)selected;

/// 调节播放进度slider和当前时间更新
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSString *)timeString;

/// 滑杆结束滑动
- (void)sliderChangeEnded;
// 显示下载按钮
- (void)showDownloadButton;

@end

NS_ASSUME_NONNULL_END
