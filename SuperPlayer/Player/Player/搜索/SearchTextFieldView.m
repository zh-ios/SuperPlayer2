//
//  SearchTextFiledView.m
//  ZHProject
//
//  Created by zh on 2019/7/8.
//  Copyright © 2019 autohome. All rights reserved.
//

#import "SearchTextFieldView.h"



@implementation SearchTextFieldView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.height = 35;
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, self.width-15*2, self.height)];
        _textField = tf;
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        tf.layer.cornerRadius = 12;
        tf.clipsToBounds = YES;
        tf.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        UIView *leftView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, self.height, 25)];
        UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, self.height, 25)];
        searchImage.image = [UIImage imageNamed:@"search"];
        searchImage.contentMode = UIViewContentModeScaleAspectFit;
        [leftView addSubview:searchImage];
        tf.leftView = leftView;
        tf.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:tf];
    }
    return self;
}


@end
