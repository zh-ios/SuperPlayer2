//
//  SPTagListView.m
//  ZHProject
//
//  Created by zhxxxx  ondfasd 2019/5/13.
//  Copyright © 2023 zhssssx. 
//

#import "SPTagListView.h"

@interface SPTagListView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, assign) BOOL longPressed;
// 记录拖动按钮的原始位置
@property (nonatomic, assign) CGRect originRect;
@property (nonatomic, assign) CGRect targetRect;

@property (nonatomic, strong) UIScrollView *containerView;

@end

@implementation SPTagListView

- (NSMutableArray *)btns {
    if (!_btns) {
        _btns = @[].mutableCopy;
    }
    return _btns;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initDefalutValue];
    }
    return self;
}

- (void)initDefalutValue {
    self.topPadding = 10.f;
    self.leftPadding = 10.f;
    self.lineMargin = 10.f;
    self.rowMargin = 10.f;
    self.tagTopPadding = 6.f;
    self.tagLeftPadding = 10.f;
    self.fontSize =  13;
    self.enableDrag = YES;
    self.containerView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:self.containerView];
    self.containerView.showsHorizontalScrollIndicator = NO;
}

- (void)addTags:(NSArray<NSString *> *)tags {
    self.tags = [tags mutableCopy];
    // 先清除之前的内容
    for (SPBaseButton *btn in self.containerView.subviews) {
        [btn removeFromSuperview];
    }
    [self.btns removeAllObjects];
    
    for (int i = 0; i<tags.count; i++) {
        [self addBtnAtIndex:i title:self.tags[i]];
    }
}

- (void)addBtnAtIndex:(NSInteger)index title:(NSString *)title {
    
    SPBaseButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = index;
    [self.btns addObject:btn];
    [self updateBtnFrame:btn title:title type:self.layoutType];
    btn.titleLabel.font = [UIFont systemFontOfSize:self.fontSize weight:UIFontWeightThin];
    btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = btn.height * 0.5;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    [btn setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHexString:@"f5f5f5"] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self.containerView addSubview:btn];
    [btn addTarget:self action:@selector(btnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (self.enableDrag&&self.layoutType==TagListViewLayoutType_default) {
        UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longP.minimumPressDuration = 0.6;
        [btn addGestureRecognizer:longP];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [btn addGestureRecognizer:pan];
        longP.delegate = self;
        pan.delegate = self;
    }
    // 设置自身高度
    if (index == self.tags.count - 1) {
        self.height = btn.bottom + self.topPadding;
        self.containerView.contentSize = CGSizeMake(0, self.height);
        self.containerView.frame = self.bounds;
    }
    if (self.maxHeight>0 && self.height>self.maxHeight) {
        self.height = self.maxHeight;
        self.containerView.frame = self.bounds;
    }
}

- (void)updateBtnFrame:(SPBaseButton *)btn title:(NSString *)title type:(TagListViewLayoutType)type{
    if (type == TagListViewLayoutType_selfAdjust) {
        SPBaseButton *previousBtn = nil;
        if (btn.tag != 0) {
            previousBtn = self.btns[btn.tag-1];
        }
        CGSize textSize = [title sizeWithAttributes:@{NSFontAttributeName : [UIFont  systemFontOfSize:self.fontSize weight:UIFontWeightThin]}];
        // 如果文字太长 width = self.width-self.leftPadding*2
        CGFloat btnW = 0;
        BOOL tooLong = textSize.width>(self.width-self.leftPadding*2);
        if (tooLong) {
            btnW = (self.width-self.leftPadding*2);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, self.tagLeftPadding, 0, self.tagLeftPadding);
        } else {
            btnW = self.tagLeftPadding*2+textSize.width;
        }
        CGFloat btnH = textSize.height+self.tagTopPadding*2;
        if (!previousBtn) {
            btn.frame = CGRectMake(self.leftPadding, self.topPadding, btnW, btnH);
            return;
        }
        // 按钮是否需要加到下一行
        BOOL nextRow = previousBtn.right+self.lineMargin*2+btnW>self.width;
        if (!nextRow) {
            btn.frame = CGRectMake(previousBtn.right+self.lineMargin, previousBtn.top, btnW, btnH);
        } else {
            btn.frame = CGRectMake(self.leftPadding, previousBtn.bottom+self.rowMargin, btnW, btnH);
        }
    } else {
        NSInteger columnCount = 4;
        CGFloat btnW = (self.width-self.leftPadding*2-(columnCount-1)*self.lineMargin)/columnCount;
        CGFloat btnH = btn.height;
        if (btnH==0) {
            CGSize textSize = [title sizeWithAttributes:@{NSFontAttributeName : [UIFont  systemFontOfSize:self.fontSize]}];
            btnH = textSize.height+self.tagTopPadding;
        }
        CGFloat btnX = self.leftPadding + (btn.tag%columnCount)*(btnW+self.lineMargin);
        CGFloat btnY = self.topPadding + (btn.tag/4)*(btnH+self.rowMargin);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

- (void)updateBtnsFrameFromIndex:(NSInteger)index  selectedBtn:(SPBaseButton *)b{
    for (NSInteger i = index; i<self.btns.count; i++) {
        SPBaseButton *btn = (SPBaseButton *)self.btns[i];
        if (btn == b) continue;
        [self updateBtnFrame:btn title:btn.titleLabel.text type:TagListViewLayoutType_default];
    }
}

- (void)updateBtnTags {
    for (int i = 0; i<self.btns.count; i++) {
        SPBaseButton *btn = (SPBaseButton *)self.btns[i];
        btn.tag = i;
    }
}

- (void)scaleBtn:(SPBaseButton *)btn {
    btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
}
- (void)resetBtn:(SPBaseButton *)btn {
    btn.transform = CGAffineTransformIdentity;
    [btn setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHexString:@"f5f5f5"] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
}

// 获取需要移动的目标按钮
- (SPBaseButton *)getTargetBtn:(SPBaseButton *)btn {
    for (SPBaseButton *b in self.btns) {
        if (b == btn) continue;
        if (CGRectContainsPoint(b.frame, btn.center)) {
            return b;
        }
    }
    return nil;
}

#pragma mark --- targetAction

- (void)btnOnClicked:(SPBaseButton *)btn {
    if (self.btnOnClicked) {
        self.btnOnClicked(btn.titleLabel.text);
    }
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    SPBaseButton *btn = (SPBaseButton *)pan.view;
    [self bringSubviewToFront:btn];
    CGPoint translation = [pan translationInView:self];
    btn.x += translation.x;
    btn.y += translation.y;
    [pan setTranslation:CGPointZero inView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan){}
    if (pan.state == UIGestureRecognizerStateChanged) {
        SPBaseButton *targetBtn = [self getTargetBtn:btn];
        if (targetBtn) {
            self.targetRect = targetBtn.frame;
            [self.tags removeObjectAtIndex:btn.tag];
            [self.tags insertObject:btn.titleLabel.text atIndex:targetBtn.tag];
            [self.btns removeObject:btn];
            [self.btns insertObject:btn atIndex:targetBtn.tag];
            [self updateBtnTags];
            NSInteger index = MIN(btn.tag, targetBtn.tag);
            [UIView animateWithDuration:0.25 animations:^{
                [self updateBtnsFrameFromIndex:index selectedBtn:btn];
            }];
        }
    }
    if (pan.state == UIGestureRecognizerStateEnded||pan.state == UIGestureRecognizerStateCancelled) {
        self.longPressed = NO;
        [self resetBtn:btn];
        [UIView animateWithDuration:0.25 animations:^{
            if (CGRectEqualToRect(self.originRect, CGRectZero)) {
                btn.frame = self.originRect;
            } else {
                btn.frame = self.targetRect;
            }
        } completion:^(BOOL finished) {
            self.originRect = CGRectZero;
        }];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)longP {
    self.longPressed = YES;
    SPBaseButton *btn = (SPBaseButton *)longP.view;
    if (longP.state == UIGestureRecognizerStateBegan) {
        self.originRect = btn.frame;
        [self scaleBtn:btn];
        [btn setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHexString:@"d7d7d7"] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        if (@available(iOS 10.0,  *)) {
            UIImpactFeedbackGenerator *g = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
            [g prepare];
            [g impactOccurred];
        }
        [btn setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHexString:@"d7d7d7"] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    }
    if (longP.state == UIGestureRecognizerStateEnded||longP.state == UIGestureRecognizerStateCancelled) {
        self.longPressed = NO;
    }
}

#pragma UIGestureDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && !self.longPressed) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
