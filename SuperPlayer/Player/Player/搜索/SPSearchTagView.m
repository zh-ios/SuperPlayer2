//
//  SPSearchTagView.m
//  ZHProject
//
//  Created by zh on 2019/7/8.
//  Copyright © 2019 autohome. All rights reserved.
//

#import "SPSearchTagView.h"
#import "ZHTagListView.h"
@implementation SPSearchTagView {
    BaseLabel *_title;
    ZHTagListView *_tagView;
    UIButton *_clearBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    CGFloat leftpadding = 15;
    BaseLabel *title = [[BaseLabel alloc] initWithFrame:CGRectMake(leftpadding, 0, self.width-leftpadding, 18)];
    title.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    _title = title;
    _title.textColor = kTextColor3;
    [self addSubview:_title];
    
    _clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width-60, title.top, 60, title.height)];
    [_clearBtn setTitleColor:kTextColor3 forState:UIControlStateNormal];
    _clearBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_clearBtn setTitle:kZHLocalizedString(@"清空") forState:UIControlStateNormal];
    [_clearBtn addTarget:self action:@selector(clearSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_clearBtn];
    
    _tagView = [[ZHTagListView alloc] initWithFrame:CGRectMake(leftpadding, _title.bottom+10, self.width-leftpadding*2, 0)];
    [self addSubview:_tagView];
    _tagView.leftPadding = 0;
//    _tagView.topPadding = 10;
//    _tagView.tagLeftPadding = 10;
//    _tagView.tagTopPadding = 10;
    _tagView.layoutType = TagListViewLayoutType_selfAdjust;
    _tagView.enableDrag = NO;
    _tagView.maxHeight = 200;
    @weakify(self)
    _tagView.btnOnClicked = ^(NSString * _Nonnull title) {
        @strongify(self)
        if (self.btnOnClicked) {
            self.btnOnClicked(title);
        }
    };
}

- (void)updateView:(NSArray *)tags title:(NSString *)title {
    _title.text = title;
    if (tags.count == 0) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
    
    
    [_tagView addTags:tags];
    self.height = _tagView.bottom;
}

- (void)setHideClearBtn:(BOOL)hideClearBtn {
    _hideClearBtn = hideClearBtn;
    if (hideClearBtn) {
        _clearBtn.hidden = YES;
    }
}

- (void)clearSearchHistory:(UIButton *)btn {
    if (self.clearBtnOnClicked) {
        self.clearBtnOnClicked();
    }
}

@end
