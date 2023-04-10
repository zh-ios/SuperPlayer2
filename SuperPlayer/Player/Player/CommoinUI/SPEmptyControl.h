

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPEmptyControl : UIControl

@property (nonatomic, strong) UILabel *titleLabel;

+ (instancetype)showEmptyViewOnView:(UIView *)SPBaseView  inset:(UIEdgeInsets)inset;
+ (void)removeEmptyViewOnView:(UIView *)SPBaseView;

@property (nonatomic, copy) void (^emptyViewOnClicked)(void);

@end

NS_ASSUME_NONNULL_END
