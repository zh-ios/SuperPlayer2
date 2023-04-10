//
//  SPScreenLockController.h
//  Player
//
//  Created by hz on 2021/11/15.
//

#import "SPBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPScreenLockController : SPBaseController

@property (nonatomic, copy) void (^inputRightPwdCallback)(void);

@end

NS_ASSUME_NONNULL_END
