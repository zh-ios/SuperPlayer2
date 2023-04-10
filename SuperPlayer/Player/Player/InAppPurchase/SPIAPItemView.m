//
//  SPIAPItemView.m
//  Player
//
//  Created by hz on 2021/12/6.
//

#import "SPIAPItemView.h"

@interface SPIAPItemView ()

@property (nonatomic, strong) SPBaseLabel  *discountLabel;
@property (nonatomic, strong) SPBaseLabel *timeLabel;
@property (nonatomic, strong) SPBaseLabel *priceLabel;
@property (nonatomic, strong) SPBaseLabel *typeLabel;

@end

@implementation SPIAPItemView

#define kUnSelectedLayerColor             kTextColor9
#define kSelectedLayerColor               kThemeEndColor

- (instancetype)initWithFrame:(CGRect)frame disCountTitle:(NSString *)dTitle timeTitle:(NSString *)timeTitle price:(NSString *)price type:(NSString *)type {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.discountLabel = [[SPBaseLabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 20)];
        self.discountLabel.textColor = [UIColor whiteColor];
        self.discountLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:self.discountLabel];
        self.discountLabel.textAlignment = NSTextAlignmentCenter;
        if (dTitle.length>0) self.discountLabel.text = dTitle;
        self.discountLabel.backgroundColor = kThemeBeginColor;
        
        self.timeLabel = [[SPBaseLabel alloc] initWithFrame:CGRectMake(0, self.discountLabel.bottom+3, self.width, 20)];
        self.timeLabel.textColor = kTextColor3;
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.timeLabel];
        self.timeLabel.text = timeTitle;
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        
        self.priceLabel = [[SPBaseLabel alloc] initWithFrame:CGRectMake(0, self.timeLabel.bottom+3, self.width, 20)];
        self.priceLabel.textColor = kTextColor9;
        self.priceLabel.font = [UIFont systemFontOfSize:17];
        self.priceLabel.text = price;
        [self addSubview:self.priceLabel];
        self.priceLabel.textColor = kThemeEndColor;
        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        
        self.typeLabel = [[SPBaseLabel alloc] initWithFrame:CGRectMake(0, self.priceLabel.bottom, self.width, 0)];
        self.typeLabel.textColor = kTextColor9;
        self.typeLabel.font = [UIFont systemFontOfSize:12];
        self.typeLabel.numberOfLines = 2;
        [self addSubview:self.typeLabel];
        self.typeLabel.textAlignment = NSTextAlignmentCenter;
        self.typeLabel.text = type;
//        [self.typeLabel sizeToFit];
        
        self.layer.cornerRadius = 5;
//        self.layer.masksToBounds = YES;
        self.layer.borderColor = [kTextColor9 colorWithAlphaComponent:0.3] .CGColor;
        self.layer.borderWidth = 2;
        
        self.viewMaxHeight = CGRectGetMaxY(self.typeLabel.frame)+5;
    }
    
    return self;
}

- (void)setSelectedStatus:(BOOL)selectedStatus {
    _selectedStatus = selectedStatus;
    if (selectedStatus) {
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            
        }];

        self.discountLabel.backgroundColor = kThemeEndColor;
        self.layer.borderColor = kSelectedLayerColor.CGColor;
    } else {
        self.discountLabel.backgroundColor = kThemeBeginColor;
        self.layer.borderColor = [kUnSelectedLayerColor colorWithAlphaComponent:0.3].CGColor;
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
}


@end
