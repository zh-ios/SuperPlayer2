//
//  SPMultiSpeedView.h
//  Player
//
//  Created by hz on 2021/12/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPMultiSpeedView : UIView

@property (nonatomic, copy) void (^multiSpeedBtnOnClicked)(UIButton *btn, CGFloat speed);

- (void)updateUIWithCurrentRate:(NSInteger)rate;

@end

NS_ASSUME_NONNULL_END
