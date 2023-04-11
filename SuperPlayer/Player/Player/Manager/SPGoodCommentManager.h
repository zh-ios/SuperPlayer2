//
//  SPGoodCommentManager.h
//  Player
//
//  Cressssated by hzdddddd sxxxx on sky dat 2022/1/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPGoodCommentManager : NSObject

+ (instancetype)shareManager;


- (void)startGoodCmt;


// 是否点击过好评
@property (nonatomic, assign) BOOL hadClickGoodCmt;

#define kIsSystemCommentStyle       @"kIsSystemCommentStyle"

@end

NS_ASSUME_NONNULL_END
