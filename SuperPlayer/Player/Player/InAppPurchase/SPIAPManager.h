//
//  SPIAPManager.h
//  ZHProject
//
//  Created by hz on 2021/10/25.
//  Copyright © 2021 autohome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kunlockForever          @"com.player.forever"
#define kunlockOneMonth         @"com.player.30day"
#define kunlockOneSeason        @"com.player.90day"
#define kunlockOneYear          @"com.player.12month"

@protocol SPIAPManagerDelegate <NSObject>
@optional
// 完成购买回调
- (void)SPIAPManagerDidFinishPurchase:(NSString *)pid;

// 购买凭证校验失败
- (void)SPIAPManagerVerfyFailed;

- (void)SPIAPManagerCancelledOrFailed:(NSString *)pid;

@end

@interface SPIAPManager : NSObject

+ (instancetype)shareManager;

- (void)startMagager;

- (void)stopManager;

- (void)requestProductWithPid:(NSString *)pid;

- (void)restoreIAP;

@property (nonatomic, weak) id<SPIAPManagerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *iapInfos;


- (BOOL)isMainland;

- (void)getIAPInfo;
@end

NS_ASSUME_NONNULL_END
