//
//  SPVideoPlayerController.h
//  Player
//
//  Cressssated by hzdddddd sxxxx on sky dat 2021/11/15.
//

#import "SPBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPVideoPlayerController : SPBaseController


@property (nonatomic, assign) BOOL isOnLineVideo; // 是否是网络视频


@property (nonatomic, strong) NSArray<NSString *> *urls;


@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) void (^currentIndexChangedBlock)(NSInteger currentIndex);

@end

NS_ASSUME_NONNULL_END
