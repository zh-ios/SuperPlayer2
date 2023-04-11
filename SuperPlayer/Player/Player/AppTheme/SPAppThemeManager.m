//
//  AppThemeTool.m
//  X-Box
//
//  Created by zhuhao on 2023/2/17.
//

#import "SPAppThemeManager.h"

@implementation SPAppThemeManager

static SPAppThemeManager *_mgr = nil;

+ (instancetype)sharedMgr {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_mgr) {
            _mgr = [[self alloc] init];
        }
    });
    return _mgr;
}

- (instancetype)init {
    if (self = [super init]) {
        [self getThemeColors];
    }
    return self;
}

- (void)getThemeColors {
    if (self.themeMode == AppThemeModeDark) {
        
        self.appHighlighColor = RGB(109, 146, 233);
        
        self.warningColor = RGBA(255, 0, 0, 0.7);
        
        self.gradientBeginColor = RGB(141, 161, 246);
        self.gradientEndColor = self.appHighlighColor;

        self.textHlColor = self.appHighlighColor;
        self.textNormalColor = [UIColor colorWithHexString:@"b7c3e9"];
        
        self.lableTitleColor = self.appHighlighColor;
        self.lableSubtitleColor = self.textNormalColor;

        self.buttonBgColor = nil;
        self.buttonTitleColor = self.appHighlighColor;
        self.buttonTitleHlColor = nil;
        self.buttonBgImageName = nil;
        self.buttonImageName = nil;
        self.buttonHlImageName = nil;
        self.buttonHlImageColor = RGB(32, 31, 37);

        self.viewBgColor = RGB(255, 252, 244);
        
        self.viewLightBgColor = [self.viewBgColor colorWithAlphaComponent:0.8];
        self.viewLayerColor = [UIColor redColor];
        self.viewShadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];

        self.imageViewBgColor = nil;

        self.naviTitleColor = self.appHighlighColor;
        self.naviBgColor = RGB(48, 47, 60);
        self.naviBgImageName = nil;

        self.tabbarTitleNormalColor = self.lableSubtitleColor;;
        self.tabbarTitleHlColor = self.lableTitleColor;
        self.tabbarBgColor = RGBA(44, 44, 60,0.7);
        self.tabbarBgImageName = nil;

        self.cellBgColor = self.viewBgColor;
        self.cellLineColor = RGB(22, 22, 22);
        self.cellHlBgColor = RGBA(44, 44, 60,0.7);

        self.tableViewBgColor = nil;

        self.collectionViewBgColor = nil;

        self.switchHlColor = self.appHighlighColor;
        
        
        self.greenColor = RGB(187, 239, 198);
        self.pinkHlColor = RGB(225, 191, 200);
        self.purpleColor = [UIColor colorWithHexString:@"f0e9f5"];
        
    }
}

@end
