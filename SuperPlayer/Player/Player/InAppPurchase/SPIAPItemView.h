//
//  SPIAPItemView.h
//  Player
//
//  Created by hz on 2021/12/6.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPIAPItemView : UIControl


/// 创建内购item
/// @param frame frame
/// @param dTitle 折扣标题
/// @param timeTitle 时长标题
/// @param price 价格
/// @param type 购买类型 自动续费，一次购买永久使用
- (instancetype)initWithFrame:(CGRect)frame disCountTitle:(nullable NSString *)dTitle timeTitle:(NSString *)timeTitle price:(NSString *)price type:(NSString *)type;


// 不知为何直接使用 selected 属性，有问题，不管事,这里自定义一个
@property (nonatomic, assign) BOOL selectedStatus;

@property (nonatomic, assign) CGFloat viewMaxHeight;

@end

NS_ASSUME_NONNULL_END
