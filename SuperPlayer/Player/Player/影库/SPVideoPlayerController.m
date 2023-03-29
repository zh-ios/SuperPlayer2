//
//  SPVideoPlayerController.m
//  Player
//
//  Created by hz on 2021/11/15.
//

#import "SPVideoPlayerController.h"
#import "ZFPlayer.h"
#import "ZFPlayerControlView.h"
#import "ZFIJKPlayerManager.h"
#import "ZFAVPlayerManager.h"
#import "AppDelegate.h"
#import "SPCustomControlView.h"
#import "YYCache.h"
#import "SPVideoPlayerController.h"
#import "HWDownloadModel.h"
#import "SPLocalFileManager.h"
#import "NSString+Encryption.h"
#import "HWDownloadManager.h"

static NSString *kVideoProgressCache = @"videoProgressCache";

@interface SPVideoPlayerController ()

/** 播放器View的父视图*/
@property(nonatomic) UIView *                 playerFatherView;
/** 离开页面时候是否在播放 */
@property(nonatomic, assign) BOOL           isPlaying;

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;

@property (nonatomic, strong) SPCustomControlView *customControlView;

@property (nonatomic, strong) UIButton *oprateButton;
@property (nonatomic, assign) BOOL isLandScape;
@property (nonatomic, strong) UIButton *replayBtn;

// 播放当前进度的缓存,用于追踪播放历史进度
@property (nonatomic, strong) YYCache *playCache;

@end



@implementation SPVideoPlayerController

static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}


- (YYCache *)playCache {
    if (!_playCache) {
        _playCache = [YYCache cacheWithName:kVideoProgressCache];
    }
    return _playCache;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self)
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.panGestureEnabled = NO;
      
    [self.view addSubview:self.containerView];
    self.customNavView.hidden = YES;

    self.customControlView.portraitControlView.closeButtonOnClikedCallbackBlock = ^{
        @strongify(self)
        [self savePlayProgress];
        [self.player stop];
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterbackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    [self setupPlayer];
    [self.player playTheIndex:self.currentIndex];

    self.player.playerReadyToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
        @strongify(self)
        [self seekToLastPlayTime];
    };
    
    // 在线视频显示下载按钮
//    if (self.isOnLineVideo && [SPGlobalConfigManager shareManager].configModel.is_new_version_online) {
//        [self.customControlView.portraitControlView showDownloadButton];
//        [self.customControlView.landScapeControlView showDownloadButton];
//    }
}


- (void)seekToLastPlayTime {
    if ([self.playCache containsObjectForKey:self.urls[self.currentIndex]]) {
        NSNumber *ts = (NSNumber *)[self.playCache objectForKey:self.urls[self.currentIndex]];
        [self.player.currentPlayerManager seekToTime:[ts doubleValue] completionHandler:nil];
    }
}

- (void)savePlayProgress {
    NSTimeInterval currentTime = self.player.currentTime;
    if (self.currentIndex <= self.urls.count-1) {
        [self.playCache setObject:@(currentTime) forKey:self.urls[self.currentIndex] withBlock:nil];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = kScreenHeight - kBottomSafeArea;
    self.containerView.frame = CGRectMake(x, y, w, h);
}


- (void)setupPlayer {
        
    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
    playerManager.shouldAutoPlay = YES;
    
    ZFAVPlayerManager *avPlayermanager = [[ZFAVPlayerManager alloc] init];
    avPlayermanager.shouldAutoPlay = YES;

    playerManager.view.scalingMode = ZFPlayerScalingModeAspectFill;
    
    NSArray *avPlayerSupported = kSupportedVideoFormats;
    NSString *fileExt = [[self.urls[self.currentIndex] pathExtension] uppercaseString];
    if ([avPlayerSupported containsObject:fileExt]) {
        /// IJPPlayer
        self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    } else {
        [ZHToastUtil showToast:@"不支持的格式,请输入http开头的视频链接！"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    self.player.controlView = self.customControlView;
    
    /// 设置退到后台停止播放
    self.player.pauseWhenAppResignActive = YES;
    
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        AppDelegate *mainDelegate  =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        mainDelegate.allowOrentitaionRotation = isFullScreen;
        self.isLandScape = isFullScreen;
    };
    
    self.player.playerPlayStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerPlaybackState playState) {
            @strongify(self)
            // 暂停了更新进度 ，注意：stopped状态是永远是 0
            if (playState==ZFPlayerPlayStatePaused) {
                [self savePlayProgress];
            }
            if (playState == ZFPlayerPlayStatePlaying) {
                
            }
            if (playState == ZFPlayerPlayStatePlayFailed) {
                [ZHToastUtil endLoadingOnView:self.view];
            }
        };
    
    self.player.playerLoadStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerLoadState loadState) {};
    self.player.playerReadyToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {};
        
    /// 播放完成
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager pause];
//        if (self.player.isLastAssetURL) {
////            self.currentIndex = 0;
//            [self.player.currentPlayerManager pause];
////            [self.player playTheIndex:0];
//        } else {
//            [self.player playTheNext];
//            self.currentIndex += 1;
//            self.player.controlView = self.customControlView;
//            [self showCustomControlView];
//            if (self.currentIndexChangedBlock) {
//                self.currentIndexChangedBlock(self.currentIndex);
//            }
//        }
    };

    
    self.customControlView.downloadBtnClickCallback = ^{
        @strongify(self);
        [self downloadCurrentVideo];
        [ZHToastUtil showToast:kZHLocalizedString(@"已加入下载队列，请勿重复下载，下载完成后会自动存储到首页！")];
    };
    
    if (self.isOnLineVideo) {
        NSMutableArray *urls = @[].mutableCopy;
        for (NSString *url in self.urls) {
            NSURL *u = [NSURL URLWithString:url];
            if (u) [urls addObject:u];
        }
        self.player.assetURLs = urls;
    } else {
        NSMutableArray *urlArr = @[].mutableCopy;
        for (NSString *str in self.urls) {
            NSURL *url = [NSURL fileURLWithPath:str];
            [urlArr addObject:url];
        }
        self.player.assetURLs = [urlArr copy];
    }
    
    [self showCustomControlView];
}

- (void)showCustomControlView {
    [self.customControlView showTitle:@"" coverURLString:@"" fullScreenMode:ZFFullScreenModeAutomatic];
}

- (void)downloadCurrentVideo {
    NSString *url = self.urls[self.currentIndex];
    HWDownloadModel *model = [[HWDownloadModel alloc] init];
    NSString *name = [[url pathComponents] lastObject];
    NSString *ext = [url pathExtension];
    model.fileName = [name stringByAppendingPathExtension:ext];
    model.url = url;
    NSString *targetPath = [[[SPLocalFileManager sharedManager] getDocumentPath] stringByAppendingPathComponent:[model.fileName stringByDeletingPathExtension]];
//    model.localPath = targetPath;
    model.vid = [url MD5Str];
    [[HWDownloadManager shareManager] startDownloadTask:model];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (SPCustomControlView *)customControlView {
    if (!_customControlView) {
        _customControlView = [SPCustomControlView new];
    }
    return _customControlView;
}


- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [UIImageView new];
        UIImage *p = [UIImage imageFromColor:[UIColor blackColor] size:CGSizeMake(1, 1)];
        _containerView.image = p;
        _containerView.contentMode = UIViewContentModeScaleToFill;
    }
    return _containerView;
}


#pragma mark --- noti {
- (void)appDidEnterbackground:(NSNotification *)noti {

}

- (void)appWillResignActive:(NSNotification *)noti {
    // 如果正在播放，暂停播放
    if (self.player.currentPlayerManager.isPlaying) {
        [self.player.currentPlayerManager pause];
    }
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player stop];
}


@end
