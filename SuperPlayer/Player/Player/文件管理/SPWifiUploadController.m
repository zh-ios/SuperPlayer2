//
//  SPWifiUploadController.m
//  Player
//
//  Created by hz on 2021/12/7.
//

#import "SPWifiUploadController.h"
#import "SPLocalFileManager.h"
#import "GCDWebUploader.h"
#import "NetHelper.h"
#import "UIView+gradient.h"

@interface SPWifiUploadController ()<GCDWebUploaderDelegate>

@property (nonatomic, strong) GCDWebUploader *webServer;

@end

@implementation SPWifiUploadController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kZHLocalizedString(@"Wifi / iTunes 上传");
    
    [self uploadByWifi];
    [self initSubViews];

}

- (void)dealloc {
    [self.webServer stop];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)initSubViews {
    
    UIScrollView *containerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavbarHeight, self.view.width, kScreenHeight-kNavbarHeight)];
    [self.view addSubview:containerScrollView];
    
    CGFloat leftpadding = 15;

    CGFloat btnWH = 30;
    UIImageView *wifi = [[UIImageView alloc] initWithFrame:CGRectMake(leftpadding, 10, btnWH, btnWH)];
    wifi.image = [UIImage imageNamed:@"sp_icon_wifi_upload"];
    wifi.contentMode = UIViewContentModeScaleAspectFit;
    [containerScrollView addSubview:wifi];

    
    UILabel *titleLabel = [[SPBaseLabel alloc] initWithFrame:CGRectMake(wifi.right+13, 10, btnWH, btnWH)];
    titleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightLight];
    titleLabel.text = kZHLocalizedString(@"Wifi 快速传输");
    [titleLabel sizeToFit];
    titleLabel.textColor = kThemeMiddleColor;
    [containerScrollView addSubview:titleLabel];
    
    UILabel *tipLabel = [[SPBaseLabel alloc] initWithFrame:CGRectMake(leftpadding, wifi.bottom+15, self.view.width-leftpadding, 18)];
    tipLabel.text = kZHLocalizedString(@"请在浏览器里输入以下地址：");
    tipLabel.textColor = kTextColor3;
    [containerScrollView addSubview:tipLabel];
    
    UILabel *ipLabel = [[SPBaseLabel alloc] initWithFrame:CGRectMake(leftpadding, tipLabel.bottom+15, self.view.width-leftpadding*2, 30)];
    ipLabel.font = [UIFont boldSystemFontOfSize:25];
    ipLabel.text = [self.webServer.serverURL absoluteString];
    ipLabel.textColor = kTextColor3;
    [containerScrollView addSubview:ipLabel];
    ipLabel.backgroundColor = kThemeBeginColor;
    
    UILabel *attentionLabel = [[SPBaseLabel alloc] initWithFrame:CGRectMake(leftpadding, ipLabel.bottom+15, self.view.width-leftpadding*2, 200)];
    attentionLabel.textColor = kTextColor6;
    attentionLabel.numberOfLines = 0;
    attentionLabel.font = [UIFont systemFontOfSize:14];
    [containerScrollView addSubview:attentionLabel];
    attentionLabel.text = kZHLocalizedString(@"Wifi 传输说明：\n1、请确保手机和电脑处于同一个 Wifi 环境下\n2、传输完成前请不要退出此页面或者将App退入后台\n3、传输完成后返回上一页面即可看到上传的文件");
    [attentionLabel sizeToFit];
    
    UIView *lineView = [[SPBaseView alloc] initWithFrame:CGRectMake(leftpadding, attentionLabel.bottom+10, kScreenWidth-leftpadding*2, 10)];
    [lineView addGradientColorsFrom:nil toColor:nil];
    [containerScrollView addSubview:lineView];
    
    
    ////////////////////////////
    ///
    
    UIImageView *itunesImage = [[UIImageView alloc] initWithFrame:CGRectMake(leftpadding, lineView.bottom+10, btnWH, btnWH)];
    itunesImage.image = [UIImage imageNamed:@"sp_icon_itunes"];
    itunesImage.contentMode = UIViewContentModeScaleAspectFit;
    [containerScrollView addSubview:itunesImage];

    
    UILabel *itunesTitleLabel = [[SPBaseLabel alloc] initWithFrame:CGRectMake(itunesImage.right+13, lineView.bottom+10, btnWH, btnWH)];
    itunesTitleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightLight];
    itunesTitleLabel.text = kZHLocalizedString(@"iTunes 快速传输");
    [itunesTitleLabel sizeToFit];
    itunesTitleLabel.textColor = kThemeMiddleColor;
    [containerScrollView addSubview:itunesTitleLabel];
    
    UILabel *itunesLabel = [[SPBaseLabel alloc] initWithFrame:CGRectMake(leftpadding, itunesTitleLabel.bottom+10, lineView.width, 200)];
    itunesLabel.numberOfLines = 0;
    itunesLabel.font = [UIFont systemFontOfSize:14];
    itunesLabel.textColor = kTextColor6;
    itunesLabel.text = kZHLocalizedString(@"iTunes 传输说明：\n\n💡 在 iPhone 和 Windows PC 之间传输文件：\n\n1、在 PC 上安装或更新到最新版本的 iTunes。\n\n2、将 iPhone 连接到 Windows PC。\n\n3、在 Windows PC 上的 iTunes 中，单击 iTunes 窗口左上方附近的 iPhone 按钮。\n\n4、单击“文件共享”，在列表中选择 App，然后执行以下一项操作：\n\n● 将文件从 iPhone传输到电脑：\n\n在右侧列表中选择要传输的文件，单击“保存到”，选择要保存文件的位置(localfolders)，然后单击“保存到”。\n\n● 将文件从电脑传输到 iPhone：\n\n单击“添加”，选择要传输的文件，然后单击“添加”。\n\n💡 在 iPhone 和 Mac 之间传输文件： \n\n1、将 iPhone 连接到 Mac。\n\n2、在 Mac 上的“访达”边栏中，选择您的 iPhone。\n\n3、在“访达”窗口顶部，点按“文件”，然后执行以下操作：\n\n● 从 Mac 传输到 iPhone：\n\n将文件或所选文件从“访达”窗口拖到列表中的 App 名称上。\n");
    [itunesLabel sizeToFit];
    [containerScrollView addSubview:itunesLabel];
    
    UIImageView *tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftpadding, itunesLabel.bottom+5, kScreenWidth-leftpadding*2, (kScreenWidth-leftpadding*2)/7*5)];
    tipImageView.image = [UIImage imageNamed:@"Itunes_chuanshu"];
    [containerScrollView addSubview:tipImageView];
    
    containerScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(tipImageView.frame)+40);
}


- (void)uploadByWifi {
    // 文件存储位置
    NSString* filePath = [[SPLocalFileManager sharedManager] getGlobalFilePath];
    NSLog(kZHLocalizedString(@"文件存储位置 : %@"), filePath);
    
    // 创建webServer，设置根目录
    _webServer = [[GCDWebUploader alloc] initWithUploadDirectory:filePath];
    // 设置代理
    _webServer.delegate = self;
    _webServer.allowHiddenItems = YES;
    
    NSArray *upperExt = kSupportedVideoFormats;
    NSMutableArray *mExt = @[].mutableCopy;
    for (NSString *ext in upperExt) {
        [mExt addObject:[ext lowercaseString]];
    }
    
    [mExt addObjectsFromArray:upperExt];
    // 限制文件上传类型
    _webServer.allowedFileExtensions = [mExt copy];
    // 设置网页标题
    _webServer.title = kZHLocalizedString(@"极简极好用的播放器");
    // 设置展示在网页上的文字(开场白)
    _webServer.prologue = kZHLocalizedString(@"安全、高效、方便、快捷的专业播放器");
    // 设置展示在网页上的文字(收场白)
    _webServer.epilogue = kZHLocalizedString(@"持续更新，不断优化，放心使用");
    
    if ([_webServer start]) {
    } else {
    }
}

    
#pragma mark - <GCDWebUploaderDelegate>
- (void)webUploader:(GCDWebUploader*)uploader didUploadFileAtPath:(NSString*)path {
}

- (void)webUploader:(GCDWebUploader*)uploader didMoveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
}

- (void)webUploader:(GCDWebUploader*)uploader didDeleteItemAtPath:(NSString*)path {
    NSLog(@"[DELETE] %@", path);
}

- (void)webUploader:(GCDWebUploader*)uploader didCreateDirectoryAtPath:(NSString*)path {
    NSLog(@"[CREATE] %@", path);
}

@end
