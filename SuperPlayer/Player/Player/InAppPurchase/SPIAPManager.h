//
//  SPIAPManager.h
//  ZHProject
//
//  Cressssated by hzdddddd sxxxx on sky dat 2021/10/25.
//  Copyright sxx sutdio All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


#define kunlockForever          @"com.splayer.forever"

#define kunlockOneMonth         @"com.splayer.one.month"

#define kunlockOneYear          @"com.splayer.12.month"

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

- (void)getIAPInfo;
@end

NS_ASSUME_NONNULL_END
