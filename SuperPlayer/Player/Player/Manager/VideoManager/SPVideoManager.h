//
//  SPVideoManager.h
//  Player
//
//  Cressssated by hzdddddd sxxxx on sky dat 2021/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MyImageBlock)(UIImage * _Nullable image);

@interface SPVideoManager : NSObject

+ (instancetype)sharedMgr;

- (void)getThumbnailImage:(NSString *)videoPath completion:(MyImageBlock)handler;

@end

NS_ASSUME_NONNULL_END
