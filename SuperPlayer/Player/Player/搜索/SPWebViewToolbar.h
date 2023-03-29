//
//  SPWebViewToolbar.h
//  Player
//
//  Created by hz on 2022/4/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPWebViewToolbar : UIView


@property (nonatomic, copy) void (^gobackBtnOnClickedBlock)(UIButton *btn);
@property (nonatomic, copy) void (^goforwardBtnOnClickedBlock)(UIButton *btn);
@property (nonatomic, copy) void (^refreshOnClickedBlock)(UIButton *btn);


- (void)refreshBtnStausGobackEnable:(BOOL)benable gofordBtnEnable:(BOOL)fenable;


@end

NS_ASSUME_NONNULL_END
