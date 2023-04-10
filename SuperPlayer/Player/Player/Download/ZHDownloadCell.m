////
////  ZHDownloadCell.m
////  Player
////
////  Created by zhuhao on 2022/10/14.
////
//
//#import "ZHDownloadCell.h"
//#import "SPHWDownloadModel.h"
//
//@interface ZHDownloadCell ()
//
//@property (nonatomic, strong) UILabel *nameLabel;
//@property (nonatomic, strong) UILabel *fileSizeLabel;
//@property (nonatomic, strong) UILabel *progressLabel;
//@property (nonatomic, strong) UIButton *downloadStatusBtn;
//@property (nonatomic, strong) SPHWDownloadModel *downloadModel;
//
//
//@end
//
//#define kDownloadCellLeftPadding 20
//#define kDownloadCellBtnWH       30
//
//@implementation ZHDownloadCell
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self initSubviews];
//    }
//    return self;
//}
//
//- (void)initSubviews {
//    // 18 + 10 + 10 + 15 + 10 /// 
//    self.nameLabel = [[SPBaseLabel alloc] initWithFrame:CGRectMake(kDownloadCellLeftPadding, 10, kScreenWidth - 150, 18)];
//    self.nameLabel.font = [UIFont systemFontOfSize:15];
//    self.nameLabel.textColor = kTextColor3;
//    [self.contentView addSubview:self.nameLabel];
//    
//    self.fileSizeLabel = [[SPBaseLabel alloc] initWithFrame:CGRectMake(self.nameLabel.left, self.nameLabel.bottom + 10, 50, 15)];
//    self.fileSizeLabel.font = [UIFont systemFontOfSize:12];
//    self.fileSizeLabel.textColor = kTextColor9;
//    [self.contentView addSubview:self.fileSizeLabel];
//    
//    self.progressLabel = [[SPBaseLabel alloc] initWithFrame:CGRectMake(self.fileSizeLabel.right + 20, self.fileSizeLabel.top, 50, self.fileSizeLabel.height)];
//    self.progressLabel.textColor = kThemeEndColor;
//    self.progressLabel.font = self.fileSizeLabel.font;
//    [self.contentView addSubview:self.progressLabel];
//    
//    self.downloadStatusBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 15, 10, 35, 35)];
//    [self.contentView addSubview:self.downloadStatusBtn];
//    [self.downloadStatusBtn setImage:[UIImage imageNamed:@"download_page_download"] forState:UIControlStateNormal];
//    [self.downloadStatusBtn addTarget:self action:@selector(downloadStatusBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
//}
//
//- (void)updateUIWithModel:(SPHWDownloadModel *)model {
//    self.downloadModel = model;
//    self.nameLabel.text = model.fileName;
//    self.fileSizeLabel.text = [NSString stringWithFormat:@"%.2f", model.totalFileSize/1000.0/1000.0];
//    self.progressLabel.text = [NSString stringWithFormat:@"%@", @(model.progress)];
//    // 根据下载状态更新按钮图片
//    [self.downloadStatusBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//}
//
//
//- (void)downloadStatusBtnOnClicked:(UIButton *)btn {
//    if (self.downloadBtnOnClickBlock) {
//        self.downloadBtnOnClickBlock(btn, self, self.downloadModel);
//    }
//}
//
//@end
