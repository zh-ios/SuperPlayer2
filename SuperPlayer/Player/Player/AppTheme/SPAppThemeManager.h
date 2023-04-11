//
//  AppThemeTool.h
//  X-Box
//
//  Created by zhuhao on 2023/2/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AppThemeMode) {
    AppThemeModeDark = 0,
    AppThemeModeLight = 1
};

@interface SPAppThemeManager : NSObject

+ (instancetype)sharedMgr;

@property (nonatomic, assign) AppThemeMode themeMode;

@property (nonatomic, strong, nullable) UIColor *appHighlighColor;

@property (nonatomic, strong, nullable) UIColor *warningColor;


@property (nonatomic, strong, nullable) UIColor *gradientBeginColor;
@property (nonatomic, strong, nullable) UIColor *gradientEndColor;

@property (nonatomic, strong, nullable) UIColor *textHlColor;
@property (nonatomic, strong, nullable) UIColor *textNormalColor;

@property (nonatomic, strong, nullable) UIColor *lableTitleColor;
@property (nonatomic, strong, nullable) UIColor *lableSubtitleColor;

@property (nonatomic, strong, nullable) UIColor *buttonBgColor;
@property (nonatomic, strong, nullable) UIColor *buttonTitleColor;
@property (nonatomic, strong, nullable) UIColor *buttonTitleHlColor;
@property (nonatomic, copy, nullable) NSString *buttonBgImageName;
@property (nonatomic, copy, nullable) NSString *buttonImageName;
@property (nonatomic, copy, nullable) NSString *buttonHlImageName;
@property (nonatomic, copy, nullable) UIColor *buttonHlImageColor;


@property (nonatomic, strong, nullable) UIColor *viewBgColor;
@property (nonatomic, strong, nullable) UIColor *viewLightBgColor;
@property (nonatomic, strong, nullable) UIColor *viewLayerColor;
@property (nonatomic, strong, nullable) UIColor *viewShadowColor;

@property (nonatomic, strong, nullable) UIImageView *imageViewBgColor;

@property (nonatomic, strong, nullable) UIColor *naviTitleColor;
@property (nonatomic, strong, nullable) UIColor *naviBgColor;
@property (nonatomic, copy, nullable) NSString *naviBgImageName;

@property (nonatomic, strong, nullable) UIColor *tabbarTitleNormalColor;
@property (nonatomic, strong, nullable) UIColor *tabbarTitleHlColor;
@property (nonatomic, strong, nullable) UIColor *tabbarBgColor;
@property (nonatomic, copy, nullable) NSString *tabbarBgImageName;

@property (nonatomic, strong, nullable) UIColor *cellBgColor;
@property (nonatomic, strong, nullable) UIColor *cellLineColor;
@property (nonatomic, strong, nullable) UIColor *cellHlBgColor;

@property (nonatomic, strong, nullable) UIColor *tableViewBgColor;

@property (nonatomic, strong, nullable) UIColor *collectionViewBgColor;

@property (nonatomic, strong, nullable) UIColor *switchHlColor;

@property (nonatomic, strong, nullable) UIColor *greenColor;
@property (nonatomic, strong, nullable) UIColor *pinkHlColor;
@property (nonatomic, strong, nullable) UIColor *purpleColor;

@end

NS_ASSUME_NONNULL_END
