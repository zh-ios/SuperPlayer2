//
//  SPGoodCommentManager.m
//  Player
//
//  Cressssated by hzdddddd sxxxx on sky dat 2022/1/5.
//

#import "SPGoodCommentManager.h"

#import "SPGoodCommentManager.h"
#import "SPIAPManager.h"
#import <StoreKit/StoreKit.h>
#import "SPIAPController.h"
#import "AppDelegate.h"
#import <StoreKit/StoreKit.h>
#import "SPVersionManager.h"

@interface SPGoodCommentManager ()



@end

@implementation SPGoodCommentManager

static SPGoodCommentManager *_mgr;

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_mgr) {
            _mgr = [[self alloc] init];
        }
    });
    return _mgr;
}


- (void)startGoodCmt{
    [SKStoreReviewController requestReview];
}

@end
