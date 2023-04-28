//
//  ZHSPVIPPreviewController.m
//  Player
//
//  Created by zhuhao on 2022/12/29.
//

#import "SPVIPPreviewController.h"
#import "SPIAPManager.h"

@interface SPVIPPreviewController ()<UIScrollViewDelegate, SPIAPManagerDelegate>

@property (nonatomic, strong) UIScrollView *containerScrollView;
@property (nonatomic, strong) SPBaseButton *tryButton;
@property (nonatomic, strong) SPBaseButton *onceBuyButton;

@property (nonatomic, strong) NSArray *imageItems;


@end

@implementation SPVIPPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageItems = @[@"vip_preview_1",@"vip_preview_4",@"vip_preview_2",@"vip_preview_3", @"vip_preview_unlock"];
    [self setupSubviews];
    [SPIAPManager shareManager].delegate = self;
}

- (void)setupSubviews {
    self.containerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavbarHeight, kScreenWidth, kScreenHeight - kNavbarHeight)];
    self.containerScrollView.delegate = self;
    [self.view addSubview:self.containerScrollView];
    
    CGFloat imageViewH = kScreenWidth/0.45*0.8;
    for (int i = 0; i<self.imageItems.count; i++) {
        SPBaseImageView *imageView = [[SPBaseImageView alloc] initWithFrame:CGRectMake(0, -60 + i * imageViewH, kScreenWidth, imageViewH)];
        [self.containerScrollView addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:self.imageItems[i]];
        if (i == self.imageItems.count - 1) {
            imageView.size = CGSizeMake(kScreenWidth, kScreenWidth/400*50);
        }
    }
    self.containerScrollView.contentSize = CGSizeMake(0, imageViewH * (self.imageItems.count - 1) + kBottomSafeArea + 30 + kScreenWidth/400*50);
    
    CGFloat leftpadding = 15;
    CGFloat btnWidth = (kScreenWidth - leftpadding * 2 - 20)/2;
    self.tryButton = [[SPBaseButton alloc] initWithFrame:CGRectMake(leftpadding, kScreenHeight - kBottomSafeArea - 50 - 30, btnWidth, 50)];
    self.tryButton.backgroundColor = kThemeEndColor;
    [self.tryButton addTarget:self action:@selector(try) forControlEvents:UIControlEventTouchUpInside];
    self.tryButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.tryButton.layer.cornerRadius = self.tryButton.height*0.5;
    self.tryButton.clipsToBounds = YES;
    [self.tryButton setTitle:kZHLocalizedString(@"试用一个月") forState:UIControlStateNormal];
    [self.view addSubview:self.tryButton];
    
    self.onceBuyButton = [[SPBaseButton alloc] initWithFrame:CGRectMake(self.tryButton.right + 20, kScreenHeight - kBottomSafeArea - 50 - 30, btnWidth, 50)];
    self.onceBuyButton.backgroundColor = kThemeEndColor;
    self.onceBuyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.onceBuyButton addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
    self.onceBuyButton.layer.cornerRadius = self.onceBuyButton.height*0.5;
    self.onceBuyButton.clipsToBounds = YES;
    [self.onceBuyButton setTitle:kZHLocalizedString(@"一次买断,永久VIP🔥") forState:UIControlStateNormal];
    [self.view addSubview:self.onceBuyButton];
}

- (void)try {
    [[SPIAPManager shareManager] requestProductWithPid:kunlockOneMonth];
}

- (void)preview {
    [[SPIAPManager shareManager] requestProductWithPid:kunlockForever];
}

#pragma mark - SPIAPManager
// 完成购买回调
- (void)SPIAPManagerDidFinishPurchase:(NSString *)pid {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 购买凭证校验失败
- (void)SPIAPManagerVerfyFailed {
    
}

- (void)SPIAPManagerCancelledOrFailed:(NSString *)pid {
    
}

@end
