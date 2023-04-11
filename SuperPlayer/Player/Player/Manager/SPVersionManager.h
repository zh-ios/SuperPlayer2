//
//  SPVersionManager.h
//  Player
//
//  Cressssated by hzdddddd sxxxx on sky dat 2022/1/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPVersionManager : NSObject

+ (instancetype)sharedMgr;

@property (nonatomic, copy) NSString *currentVersion;

@property (nonatomic, copy) NSString *onlineVersion;

@property (nonatomic, copy) NSString *weburl;

// 根据此判断新版本是否上线
@property (nonatomic, assign) BOOL isNewVersionAvailable;

// 当前版本是否是最新的版本
@property (nonatomic, assign) BOOL isLatestVersion;


// 检测最新版本已经上线的回调
@property (nonatomic, copy) void (^latestVersionOnlineCallback)(void);


- (void)getAppVersionInfo;

// 强制升级
- (void)forceUpdate;

@end

NS_ASSUME_NONNULL_END
