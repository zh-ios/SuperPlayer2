//
//  BTActionSheetView.m
//  BanTang
//
//  Created by liaoyp on 15/5/21.
//  Copyright (c) 2015年 JiuZhouYunDong. All rights reserved.
//



#import "SPActionSheet.h"
#import "SPBaseController.h"

#define TEXT_COLOR RGBA(68, 68, 68, 1)
#define DISABLED_TEXT_COLOR RGBA(0, 0, 0, 0.15)
#define TITLE_TEXT_FONT_SIZE 12.0f
#define TEXT_FONT_SIZE  15.0f
#define SPActionSheet_ANIMATION_DURING  0.25f
#define KKROWCELLHEIGHT 50


@implementation SPActionSheetItem

+ (instancetype)makeSPActionSheetItemWithTitle:(NSString *)title {
    SPActionSheetItem *item = [[SPActionSheetItem alloc] init];
    if (item != nil) {
        item.title = title;
        item.style = SPActionSheetItemStyle_Default;
        item.titleColor = RGBA(0, 0, 0, 0.3);
    }
    return item;
}

+ (instancetype)makeSPActionSheetItemWithTitle:(NSString *)title style:(SPActionSheetItemStyle)style {
    SPActionSheetItem *item = [self makeSPActionSheetItemWithTitle:title];
    if (item != nil) {
        item.style = style;
    }
    return item;
}

@end


@implementation SPActionSheet {
    UIView *_backView;
    UIView *_containerView;
    BOOL _isShow;
    BOOL _isAutorotate;
    BOOL _reShow;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width,
                                  [[UIScreen mainScreen] bounds].size.height);
        self.frame = frame;
        [self initContentView];
    }
    return self;
}

- (void)initContentView {
    _backView = [[BaseView alloc] initWithFrame:self.frame];
    _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self addSubview:_backView];

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:_backView];
    if (!CGRectContainsPoint([_containerView frame], pt)) {
        if (_selectRowBlock) {
            _selectRowBlock(self, [self cancelItemName], -1);
        } else {
            [self hide];
        }
    }
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    float height = (dataSource.count + 1) * KKROWCELLHEIGHT + 5;
   
    
    _containerView = [[BaseView alloc] initWithFrame:CGRectMake(0, kScreenHeight-height-kBottomSafeArea, kScreenWidth, height+kBottomSafeArea)];
    _containerView.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:_containerView];
    
    CGFloat btnH = 50;
    NSMutableArray *datas = @[].mutableCopy;
    [datas addObjectsFromArray:dataSource];
    
    for (int i = 0; i<datas.count; i++) {
        SPActionSheetItem *item = datas[i];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50*i, kScreenWidth, btnH)];
        [btn setBackgroundImage:[UIImage imageFromColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageFromColor:RGBA(242, 242, 242, 1)] forState:UIControlStateHighlighted];
        if (item.style == SPActionSheetItemStyle_Title) {
            btn.titleLabel.font = [UIFont systemFontOfSize:TITLE_TEXT_FONT_SIZE];
            [btn setTitleColor:RGBA(0, 0, 0, 0.3) forState:UIControlStateNormal];
            btn.enabled = NO;
        }
        if (item.style == SPActionSheetItemStyle_Default) {
            btn.titleLabel.font = [UIFont systemFontOfSize:TEXT_FONT_SIZE];
            [btn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
            btn.enabled = YES;
        }
        if (item.style == SPActionSheetItemStyle_Disabled) {
            btn.titleLabel.font = [UIFont systemFontOfSize:TEXT_FONT_SIZE];
            [btn setTitleColor:DISABLED_TEXT_COLOR forState:UIControlStateNormal];
            btn.enabled = YES;
        }
        
        if (item.style == SPActionSheetItemStyle_Disabled) {
            btn.titleLabel.font = [UIFont systemFontOfSize:TEXT_FONT_SIZE];
            [btn setTitleColor:item.titleColor forState:UIControlStateNormal];
            btn.enabled = NO;
        }
        btn.tag = i+1;
        if (i != datas.count-1) {
            UIView *lineView = [[BaseView alloc] initWithFrame:CGRectMake(0, btnH-onePixel, kScreenWidth, onePixel)];
            lineView.backgroundColor = RGBA(0, 0, 0, 0.1);
            [btn addSubview:lineView];
        } else {
            UIView *view = [[BaseView alloc] initWithFrame:CGRectMake(0, dataSource.count*btnH, kScreenWidth, 5)];
            view.backgroundColor = RGBA(238, 238, 238, 1);
            [_containerView addSubview:view];
        }
        [btn addTarget:self action:@selector(btnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:item.title forState:UIControlStateNormal];
        [_containerView addSubview:btn];
    }
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, btnH*dataSource.count+5, kScreenWidth, btnH+kBottomSafeArea)];
    [cancelBtn setBackgroundImage:[UIImage imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageFromColor:RGBA(242, 242, 242, 1)] forState:UIControlStateHighlighted];
    [cancelBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:TEXT_FONT_SIZE];
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:cancelBtn];
    
    UILabel *cancelLabel = [[BaseLabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, btnH)];
    cancelLabel.textColor = TEXT_COLOR;
    cancelLabel.font = [UIFont systemFontOfSize:TEXT_FONT_SIZE];
    cancelLabel.textAlignment = NSTextAlignmentCenter;
    [cancelBtn addSubview:cancelLabel];
    cancelLabel.text = [self cancelItemName];
}

- (void)btnOnClicked:(UIButton *)btn {
    if (self.selectRowBlock) {
        SPActionSheetItem *it = self.dataSource[btn.tag-1];
        self.selectRowBlock(self, it.title, btn.tag-1);
    }
}

- (void)cancel:(UIButton *)btn {
    [self hide];
}

#pragma mark - public
- (void)show {
    if (_isShow) {
        return;
    }
    _isShow = YES;
    
    float height = (_dataSource.count + 1) * KKROWCELLHEIGHT + 5 + kBottomSafeArea;
    _containerView.frame = CGRectMake(0, kScreenHeight-height, kScreenWidth, height);
    
    _containerView.y += _containerView.height;
    [_containerView addCornerRadius:UIRectCornerTopLeft|UIRectCornerTopRight size:CGSizeMake(20, 20)];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:SPActionSheet_ANIMATION_DURING
                     animations:^{
                        self->_containerView.y -= self->_containerView.height;
                     } completion:^(BOOL finished) {
                     }];
}

- (void)hide {
    _isShow = NO;
    [UIView animateWithDuration:SPActionSheet_ANIMATION_DURING
        animations:^{
        self->_backView.alpha = 0.0;
        self->_containerView.y += self->_containerView.height;

        }
        completion:^(BOOL finished) {
            
        if (finished) {
            [self removeFromSuperview];
            [self->_backView removeFromSuperview];
        }
        }];
}

- (void)hideWithCompletionBlock:(dispatch_block_t)completed {
    _isShow = NO;
    [UIView animateWithDuration:SPActionSheet_ANIMATION_DURING
        animations:^{
        self->_backView.alpha = 0.0;
        self->_containerView.y += self->_containerView.height;

        }
        completion:^(BOOL finished) {
            
        if (finished) {
            [self removeFromSuperview];
            [self->_backView removeFromSuperview];
        }
        if (completed) {
            completed();
        }
        }];
}

- (void)hideWithoutAnimation {
    _isShow = NO;
    [self removeFromSuperview];
}

- (NSString *)cancelItemName {
    return kZHLocalizedString(@"取消");
}

@end
