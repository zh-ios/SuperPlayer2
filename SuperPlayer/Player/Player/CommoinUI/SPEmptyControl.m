

#import "SPEmptyControl.h"
#import "Lottie.h"

@interface SPEmptyControl ()

@property (nonatomic,strong) UIImageView *topImageView;
@property (nonatomic, strong) LOTAnimationView *lotAnimationView;


@end

@implementation SPEmptyControl

+ (instancetype)showEmptyViewOnView:(UIView *)baseView  inset:(UIEdgeInsets)inset {
    
    SPEmptyControl *emptyView = [baseView viewWithTag:222222];
    if (!emptyView) {
        emptyView = [[SPEmptyControl alloc] init];
        [baseView addSubview:emptyView];
    }else {
        [baseView bringSubviewToFront:emptyView];
    }
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(baseView).insets(inset);
        make.edges.equalTo(baseView).insets(UIEdgeInsetsMake(inset.top+80, inset.left, inset.bottom, inset.right));

    }];
    
    
    
    return emptyView;
}

+ (void)removeEmptyViewOnView:(UIView *)baseView{
    
    UIView *emptyView = [baseView viewWithTag:222222];
    [emptyView removeFromSuperview];
}

- (instancetype)init{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.tag = 222222;
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = RGB(153, 153, 153);
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.text = kZHLocalizedString(@"没有视频了~_~");
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(50);
            make.width.mas_equalTo(kScreenWidth-100);
        }];
        
        self.topImageView = [UIImageView new];
        self.topImageView.clipsToBounds = YES;
        self.topImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.topImageView.image = [UIImage imageNamed:@"sp_icon_empty_file"];
//        [self addSubview:self.topImageView];
        
        self.lotAnimationView = [[LOTAnimationView alloc] init];
        [self addSubview:self.lotAnimationView];
        [self.lotAnimationView setAnimationNamed:[NSString stringWithFormat:@"car-loading%@-data",@(arc4random_uniform(6)+1)]];
        [self.lotAnimationView play];
        self.lotAnimationView.loopAnimation = YES;
        [self.lotAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(150, 120));
            make.bottom.equalTo(self.titleLabel.mas_bottom).offset(-34);
        }];
        
//        [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.bottom.equalTo(self.titleLabel.mas_top).offset(-34);
//        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEmptyView:)];
        
        [self addGestureRecognizer:tap];
    }
    return self;
}


- (void)tapEmptyView:(UITapGestureRecognizer *)tap {
    if (self.emptyViewOnClicked) {
        self.emptyViewOnClicked();
    }
}

@end
