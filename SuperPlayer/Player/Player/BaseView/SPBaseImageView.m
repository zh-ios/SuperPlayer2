//
//  SPBaseImageView.m
//  FMProject
//
//  Created by zhxxxx  ondfasd 2019/2/12.
//  Copyright © 2019 zz  ll rights reserved..
//

#import "SPBaseImageView.h"

@implementation SPBaseImageView


// jnit withframge 是指定初始化方式 及时 imageView 只调用了 alloc init ，也会走这个方法，frame 此时是 CGRectZero
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeScaleAspectFill;
//        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

@end
