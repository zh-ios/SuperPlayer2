//
//  SPMultiSpeedView.m
//  Player
//
//  Created by hz on 2021/12/17.
//

#import "SPMultiSpeedView.h"

@interface SPMultiSpeedView ()

@property (nonatomic, strong) UIButton *lastSelectedBtn;
@property (nonatomic, strong) NSMutableArray *btns;

@end

@implementation SPMultiSpeedView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.btns = @[].mutableCopy;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {

    NSArray *titles = @[@"0.5 X",@"1.0 X",@"1.5 X",@"2.0 X"];
    CGFloat btnW = self.width;
    CGFloat btnH = 30;
    CGFloat btnMargin = 5;
    for (int i = 0; i<titles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, (btnH+btnMargin)*i, btnW, btnH)];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(speedBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.btns addObject:btn];
        [btn setExtendedHitArea:CGRectMake(20, 0, 20, 0)];
    }
}

- (void)updateUIWithCurrentRate:(NSInteger)rate {
    if (self.lastSelectedBtn) {
        [UIView animateWithDuration:0.2 animations:^{
            self.lastSelectedBtn.transform = CGAffineTransformIdentity;
        }];
    }
    self.lastSelectedBtn.selected = NO;
    
    NSInteger index = 0;
    if (rate == 5) index = 0;
    if (rate == 10) index = 1;
    if (rate == 15) index = 2;
    if (rate == 20) index = 3;
    UIButton *btn = self.btns[index];
    btn.selected = YES;
    self.lastSelectedBtn = btn;
    [UIView animateWithDuration:0.2 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }];
}

- (void)speedBtnOnClicked:(UIButton *)btn {
    if (btn.selected) return;
    self.lastSelectedBtn.selected = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.lastSelectedBtn.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        if (finished) {
            btn.selected = YES;
            self.lastSelectedBtn = btn;
            if (self.multiSpeedBtnOnClicked) {
                self.multiSpeedBtnOnClicked(btn, (([self.btns indexOfObject:btn]*0.5)+0.5));
            }
        }
    }];
}

@end
