//
//  SPIAPManager.m
//  ZHProject
//
//  Created by hz on 2021/10/25.
//  Copyright © 2021 autohome. All rights reserved.
//

#import "SPIAPManager.h"
#import <StoreKit/StoreKit.h>
#import "NetHelper.h"



@interface SPIAPManager ()<SKPaymentTransactionObserver, SKProductsRequestDelegate>

/// 如果校验结果是21007 错误，更改校验地址为沙盒重新进行校验
@property (nonatomic, assign) BOOL is21007;

@end

@implementation SPIAPManager

static SPIAPManager *_mgr = nil;

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_mgr) {
            _mgr = [[self alloc] init];
        }
    });
    return _mgr;
}

- (NSMutableArray *)iapInfos {
    if (!_iapInfos) {
        _iapInfos = @[].mutableCopy;
    }
    return _iapInfos;
}


- (void)startMagager {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)stopManager {
    
    // 退出后结束所有未完成trans
    for (SKPaymentTransaction *trans in [SKPaymentQueue defaultQueue].transactions) {
        // 以下三种状态的结束交易
        if(trans.transactionState==SKPaymentTransactionStateFailed||trans.transactionState==SKPaymentTransactionStateDeferred) {
            [[SKPaymentQueue defaultQueue] finishTransaction:trans];
        }
    }
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
}

- (void)restoreIAP {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)requestProductWithPid:(NSString *)pid {
    [ZHToastUtil showLoadingWithTitle:kZHLocalizedString(@"数据加载中...") onView:[UIViewController currentVC].view];
    if ([SKPaymentQueue canMakePayments]) {
        if (pid) {
            NSSet *set = [NSSet setWithArray:@[pid]];
            SKProductsRequest *req = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
            req.delegate = self;
            [req start];
        } else {
            [ZHToastUtil showToast:kZHLocalizedString(@"无效产品id")];
            [ZHToastUtil endLoadingOnView:[UIViewController currentVC].view];
        }
    } else {
        [ZHToastUtil endLoadingOnView:[UIViewController currentVC].view];
        [ZHToastUtil showToast:kZHLocalizedString(@"不支持内购功能，需要去设置中进行修改")];
    }
}

#pragma mark ---SKPaymentTransactionObserver

// 支持从 appstore 购买
- (BOOL)paymentQueue:(SKPaymentQueue *)queue shouldAddStorePayment:(SKPayment *)payment forProduct:(SKProduct *)product {
    return YES;
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *trans in transactions) {
        switch (trans.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                
                break;
            case SKPaymentTransactionStateFailed:
                [ZHToastUtil endLoadingOnView:[UIViewController currentVC].view];
                if (self.delegate && [self.delegate respondsToSelector:@selector(SPIAPManagerCancelledOrFailed:)]) {
                    [self.delegate SPIAPManagerCancelledOrFailed:trans.payment.productIdentifier];
                }
                [queue finishTransaction:trans];
                break;
                // 购买成功
            case SKPaymentTransactionStatePurchased:
                [queue finishTransaction:trans];
                [ZHToastUtil endLoadingOnView:[UIViewController currentVC].view];
                [self verifyTransactionResultWithPid:trans.payment.productIdentifier];
                break;
            // 恢复购买，已经购买过该商品
            case SKPaymentTransactionStateRestored:
                [queue finishTransaction:trans];
                [self verifyTransactionResultWithPid:trans.payment.productIdentifier];

                break;
            
            default:
                break;
        }
    }
}

// 恢复购买失败
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    [ZHToastUtil showToast:kZHLocalizedString(@"恢复购买失败")];
}

// 恢复购买
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    if (queue.transactions.count>0) {
        for (SKPaymentTransaction *trans in queue.transactions) {
            if(trans.transactionState==SKPaymentTransactionStateFailed||trans.transactionState==SKPaymentTransactionStatePurchased) {
                [queue finishTransaction:trans];
            }
        }
        // 需要进行校验
        [ZHToastUtil showToast:kZHLocalizedString(@"已为您恢复购买")];
    } else {
        [ZHToastUtil showToast:kZHLocalizedString(@"未查询到购买记录")];
    }
}


#pragma mark 客户端验证购买凭据
- (void)verifyTransactionResultWithPid:(NSString *)pid {
    // 本地校验并不安全，server校验或者本地校验，不推荐客户端verfy这种方式校验
    if ([NetHelper getProxyStatus]) {
        return;
    }
   // 验证凭据，获取到苹果返回的交易凭据
   // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
   NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
   // 从沙盒中获取到购买凭据
   NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
   // 传输的是BASE64编码的字符串
   /**
      BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传 输的稳定性
      BASE64是可以编码和解码的
    */
//    8150b99dfc2d499ba64189fefeb35da7 app专用共享秘钥，订阅模式专用
    NSDictionary *requestContents = @{@"receipt-data":[receipt base64EncodedStringWithOptions:0],@"password":@"8150b99dfc2d499ba64189fefeb35da7"};
   NSError *error;
   // 转换为 JSON 格式
   NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents options:0 error:&error];
    
   // 不存在
   if (!requestData) {
       if (self.delegate && [self.delegate respondsToSelector:@selector(SPIAPManagerVerfyFailed)]) {
           dispatch_async(dispatch_get_main_queue(), ^{
               [self.delegate SPIAPManagerVerfyFailed];
           });
           return;
       }
   }
 
   // 发送网络POST请求，对购买凭据进行验证
   NSString *verifyUrlString;
    if (!self.is21007) {
        verifyUrlString = @"https://buy.itunes.apple.com/verifyReceipt";
    } else {
        verifyUrlString = @"https://sandbox.itunes.apple.com/verifyReceipt";
    }
   
   // 国内访问苹果服务器比较慢，timeoutInterval 需要长一点
   NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:verifyUrlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
 
   [storeRequest setHTTPMethod:@"POST"];
   [storeRequest setHTTPBody:requestData];
 
   // 在后台对列中提交验证请求，并获得官方的验证JSON结果
   NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    RUN_IN_MAIN_THREAD(^{
        [ZHToastUtil showLoadingWithTitle:kZHLocalizedString(@"购买成功正在进行校验...") onView:[UIViewController currentVC].view];
    })
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:queue];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:storeRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

          if (error) {
              NSLog(kZHLocalizedString(@"链接失败"));
              RUN_IN_MAIN_THREAD(^{
                  [ZHToastUtil showToast:kZHLocalizedString(@"网络连接失败,请重试")];
                  [ZHToastUtil endLoadingOnView:[UIViewController currentVC].view];
              });
          } else {
              NSError *error;
              NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
              if (!jsonResponse) {
                  NSLog(kZHLocalizedString(@"验证失败"));
                  RUN_IN_MAIN_THREAD(^{
                      [ZHToastUtil endLoadingOnView:[UIViewController currentVC].view];
                      [ZHToastUtil showToast:kZHLocalizedString(@"验证失败")];
                  })
              }

              // 比对 jsonResponse 中以下信息基本上可以保证数据安全
              /*
               bundle_id
               application_version
               product_id
               transaction_id
               */
              NSDictionary *valueDic = jsonResponse[@"receipt"];
              
              /////////////// 订阅模式下 最近订阅的数组
              // 最近内购选项（包含已经过期的订阅，在恢复购买时需要剔除）
              NSArray *inAppIap = valueDic[@"in_app"];
              NSString *iden = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
              if (valueDic && [valueDic[@"bundle_id"] isEqualToString:iden]&&[inAppIap count]>0) {
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                     
                      long long expireTs = [[NSDate date] timeIntervalSince1970]*1000;
                      long long initExpireTs = expireTs;
                      for (NSDictionary *dic in inAppIap) {
                          /////////////////////  永久解锁情况
                          if ([dic[@"product_id"] isEqualToString:kunlockForever]) {
                              [ZHToastUtil endLoadingOnView:[UIViewController currentVC].view];
                              [ZHToastUtil showToast:kZHLocalizedString(@"校验成功，感谢您的支持！")];
                              // 永久激活
                              [SPGlobalConfigManager shareManager].unlockAllFuncForeverStatus = YES;
                              if (self.delegate && [self.delegate respondsToSelector:@selector(SPIAPManagerDidFinishPurchase:)]) {
                                    [self.delegate SPIAPManagerDidFinishPurchase:pid];
                                  return;
                              }
                          }
                          
                          if ([dic[@"expires_date_ms"] longLongValue]>expireTs) {
                              expireTs = [dic[@"expires_date_ms"] longLongValue];
                          }
                      }
                      // 有有效的订阅内容
                      if (expireTs>initExpireTs) {
                          [ZHToastUtil endLoadingOnView:[UIViewController currentVC].view];
                          [ZHToastUtil showToast:kZHLocalizedString(@"校验成功，感谢您的支持！")];
                          [[SPGlobalConfigManager shareManager] updateIAPWithExpireTs:expireTs];
                          if (self.delegate && [self.delegate respondsToSelector:@selector(SPIAPManagerDidFinishPurchase:)]) {
                                [self.delegate SPIAPManagerDidFinishPurchase:pid];
                          }
                          // 订阅失效或者过期了
                      } else {
                          [ZHToastUtil endLoadingOnView:[UIViewController currentVC].view];
                          [ZHToastUtil showToast:kZHLocalizedString(@"订阅已过期，请重新订阅！")];
                      }
                      
                  });
                  
                  RUN_IN_MAIN_THREAD(^{
                      
                  })
              }
              
            if ([jsonResponse[@"status"] integerValue] == 21007) {
                self.is21007 = YES;
                  // 重新进行校验
                [self verifyTransactionResultWithPid:pid];
            }
          }
      }];
      //4.执行task
      [dataTask resume];
}


#pragma mark ---SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *products = response.products;
    // 说明不是购买行为，是单纯获取内购信息
    if (products.count>1) {
        [self.iapInfos removeAllObjects];
        for (int i = 0; i<products.count; i++) {
            SKProduct *p = products[i];
            if ([p.productIdentifier isEqualToString:kunlockOneYear]) [self.iapInfos addObject:p];
            if ([p.productIdentifier isEqualToString:kunlockOneMonth]) [self.iapInfos addObject:p];
            if ([p.productIdentifier isEqualToString:kunlockForever]) [self.iapInfos addObject:p];
        }
    } else if (products.count == 0) {
        RUN_IN_MAIN_THREAD(^{
            [ZHToastUtil showToast:kZHLocalizedString(kZHLocalizedString(@"无可购买产品"))];
        })
        
    } else {
        SKPayment *payment = [SKPayment paymentWithProduct:[products firstObject]];
        // 发起购买请求
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}


- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [ZHToastUtil showToast:kZHLocalizedString(@"查询信息失败，请稍后再试")];
    RUN_IN_MAIN_THREAD(^{
        [ZHToastUtil endLoadingOnView:[UIViewController currentVC].view];
    })
}

- (void)getIAPInfo {
    NSSet *set = [NSSet setWithArray:@[kunlockForever,kunlockOneYear,kunlockOneMonth]];
    SKProductsRequest *req = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    req.delegate = self;
    [req start];
}

- (BOOL)isMainland {
    // iOS 获取设备当前语言和地区的代码
    NSString *currentLanguageRegion = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] firstObject];
    if ([currentLanguageRegion isEqualToString:@"zh-Hans-CN"]) {
        return YES;
    }
    return NO;
}
@end
