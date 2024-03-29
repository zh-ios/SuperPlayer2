//
//  SPTableViewCell.h
//  ZHProject
//
//  Created by zhxxxx  ondfasd 2018/7/10.
//  Copyright © 2023 zhsxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPTableViewCell : UITableViewCell


/**
  通过此属性改变分割线的hidden、frame、backgroundColor等
 */
@property (nonatomic, strong, readonly) UIView *splitLine;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                    cellFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

@end
