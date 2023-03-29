//
//  ZHPopDownMenu.h
//  
//
//  Created by zh on 2018/12/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHPopDownMenu : UIView



- (instancetype)initWithTitles:(NSArray *)titles images:(NSArray *)images bellowView:(UIView *)view;

- (void)show;

- (void)dismiss;




@end

NS_ASSUME_NONNULL_END
