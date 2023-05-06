//
//  SPScreenLockController.m
//  Player
//
//  Cressssated by hzdddddd sxxxx on sky dat 2021/11/15.
//

#import "SPScreenLockController.h"

@interface SPScreenLockController ()

@property (nonatomic, strong) SPBaseLabel *pwdLabel;
@property (nonatomic, copy) NSString *currentInputPwd;
@property (nonatomic, strong) NSMutableArray *inpuNumbers;
@property (nonatomic, strong) SPBaseButton *dtShowBtn;
@end

#define kScreenLockThemeColor kTextHighlightColor

@implementation SPScreenLockController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inpuNumbers = @[].mutableCopy;
    [self setupSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupSubviews {
    SPBaseLabel *inputTipLabel = [[SPBaseLabel alloc] initWithFrame:CGRectMake(0, kNavbarHeight+40, self.view.width, 20)];
    inputTipLabel.textColor = kScreenLockThemeColor;
    inputTipLabel.textAlignment = NSTextAlignmentCenter;
    inputTipLabel.text = kZHLocalizedString(@"请 输 入 密 码");
    inputTipLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:inputTipLabel];
    
    self.pwdLabel = [[SPBaseLabel alloc] initWithFrame:CGRectMake(0, inputTipLabel.bottom+10, self.view.width, 18)];
    self.pwdLabel.text = kPWDInputZeroNumerStr;
    self.pwdLabel.font = [UIFont systemFontOfSize:17];
    self.pwdLabel.textAlignment = NSTextAlignmentCenter;
    self.pwdLabel.textColor = kScreenLockThemeColor;
    [self.view addSubview:self.pwdLabel];
    
    SPBaseButton *dtShow = [[SPBaseButton alloc] initWithFrame:CGRectMake(50, self.pwdLabel.bottom, kScreenWidth-50*2, 40)];
    [dtShow setTitle:kZHLocalizedString(@"本次启动不再展示输入") forState:UIControlStateNormal];
    [dtShow setTitleColor:kTextColor9 forState:UIControlStateNormal];
    [dtShow setTitleColor:kScreenLockThemeColor forState:UIControlStateSelected];
    [dtShow addTarget:self action:@selector(dtShow:) forControlEvents:UIControlEventTouchUpInside];
    dtShow.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:dtShow];
    dtShow.titleLabel.font = [UIFont systemFontOfSize:13];
    [dtShow setImage:[UIImage imageNamed:@"sp_icon_checkbox_selected"] forState:UIControlStateSelected];
    [dtShow setImage:[UIImage imageNamed:@"sp_icon_checkbox_unselected"] forState:UIControlStateNormal];
    self.dtShowBtn = dtShow;
    dtShow.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    dtShow.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    
    CGFloat btnWH = 75;
    CGFloat btnMargin = 22;
    CGFloat btnUpDownMargin = 24;
    CGFloat leftPadding = (kScreenWidth-btnMargin*2-btnWH*3)/2;
    
    CGFloat btnX = leftPadding;
    CGFloat btnY = 0;
    NSInteger column = 0;
    NSInteger row = 0;
    for (int i = 0; i<9; i++) {
        column = i % 3;
        row = i / 3;
        btnX = leftPadding+(btnWH+btnMargin)*column;
        btnY = self.pwdLabel.bottom + 80 +(btnWH+btnUpDownMargin)*row;
        
        [self addBtnWithFrame:CGRectMake(btnX, btnY, btnWH, btnWH) tag:i+1];
    }
    
    // 0 按钮
    [self addBtnWithFrame:CGRectMake((kScreenWidth-btnWH)/2, btnY+btnWH+btnUpDownMargin, btnWH, btnWH) tag:0];
    
    
    CGFloat opBtnLeftPadding = 20;
    CGFloat opBtnW = 100;
    SPBaseButton *cancelButton = [[SPBaseButton alloc] initWithFrame:CGRectMake(opBtnLeftPadding, self.view.height-130-kBottomSafeArea, opBtnW, 40)];
    [cancelButton setTitle:kZHLocalizedString(@"取 消") forState:UIControlStateNormal];
    [cancelButton setTitleColor:kScreenLockThemeColor forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
    cancelButton.layer.cornerRadius = cancelButton.height*0.5;
    cancelButton.layer.borderWidth = onePixel;
    cancelButton.layer.borderColor = kScreenLockThemeColor.CGColor;
    // 暂时用不到
    cancelButton.hidden = YES;
    
    SPBaseButton *deleteBtn = [[SPBaseButton alloc] initWithFrame:CGRectMake(kScreenWidth-opBtnLeftPadding-opBtnW, cancelButton.top, opBtnW, 40)];
    [deleteBtn setTitle:kZHLocalizedString(@"删 除") forState:UIControlStateNormal];
    [deleteBtn setTitleColor:kScreenLockThemeColor forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    deleteBtn.layer.cornerRadius = cancelButton.height*0.5;
    deleteBtn.layer.borderWidth = onePixel;
    deleteBtn.layer.borderColor = kScreenLockThemeColor.CGColor;

}

- (void)addBtnWithFrame:(CGRect)frame tag:(NSInteger)tag {
    SPBaseButton *btn = [[SPBaseButton alloc] initWithFrame:frame];
    [btn setTitleColor:kScreenLockThemeColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:24];
    [self.view addSubview:btn];
    btn.tag = tag;
    [btn addTarget:self action:@selector(numberBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = frame.size.width*0.5;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = kScreenLockThemeColor.CGColor;
    [btn setTitle:[NSString stringWithFormat:@"%@",@(tag)] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageFromColor:kRandomColor size:frame.size] forState:UIControlStateHighlighted];
    btn.layer.masksToBounds = YES;
}

- (void)dtShow:(SPBaseButton *)btn {
    btn.selected = !btn.selected;
}

- (void)numberBtnOnClicked:(SPBaseButton *)btn {
    kFeedbackMedium
    
    [self.inpuNumbers addObject:[NSString stringWithFormat:@"%@",@(btn.tag)]];
    
    switch (self.inpuNumbers.count) {
        case 1:
            self.pwdLabel.text = kPWDInputOneNumerStr;
            break;
        case 2:
            self.pwdLabel.text = kPWDInputTwoNumerStr;
            break;
        case 3:
            self.pwdLabel.text = kPWDInputThreeNumerStr;
            break;
        case 4:
            self.pwdLabel.text = kPWDInputFourNumerStr;
            break;
        default:
            break;
    }
    
    // 已经输入4位进行判断
    if (self.inpuNumbers.count >= 4) {
        self.inpuNumbers = [[self.inpuNumbers subarrayWithRange:NSMakeRange(0, 4)] mutableCopy];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableString *muStr = @"".mutableCopy;
            for (NSString *s in self.inpuNumbers) {
                [muStr appendString:[s mutableCopy]];
            }
            NSString *inputStr = [muStr copy];
            if ([inputStr isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kPwd]]) {
                if (self.inputRightPwdCallback) {
                    self.inputRightPwdCallback();
                }
                if (self.dtShowBtn.selected) {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDontShowThisTime];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                return;
            }
            
            if (self.inpuNumbers.count>=4) {
                [SPToastUtil showToast:kZHLocalizedString(@"密码输入错误！")];
                [self shakeAnimationForView:self.pwdLabel];
                [self.inpuNumbers removeAllObjects];
                self.pwdLabel.text = kPWDInputZeroNumerStr;
            }
        });
    }
}

- (void)shakeAnimationForView:(UIView *) view {
    // 获取到当前的View
    CALayer *viewLayer = view.layer;
    // 获取当前View的位置
    CGPoint position = viewLayer.position;
    // 移动的两个终点位置
    CGPoint x = CGPointMake(position.x + 6, position.y);
    CGPoint y = CGPointMake(position.x - 6, position.y);
    // 设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    // 设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    // 设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    // 设置自动反转
    [animation setAutoreverses:YES];
    // 设置时间
    [animation setDuration:.07];
    // 设置次数
    [animation setRepeatCount:3];
    // 添加上动画
    [viewLayer addAnimation:animation forKey:nil];
}


- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)delete {
    if (self.inpuNumbers.count == 0) return;
    [self.inpuNumbers removeLastObject];
    switch (self.inpuNumbers.count) {
        case 3:
            self.pwdLabel.text = kPWDInputThreeNumerStr;
            break;
        case 2:
            self.pwdLabel.text = kPWDInputTwoNumerStr;
            break;
        case 1:
            self.pwdLabel.text = kPWDInputOneNumerStr;
            break;
        case 0:
            self.pwdLabel.text = kPWDInputZeroNumerStr;
            break;
        default:
            break;
    }
}

@end
