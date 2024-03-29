//
//  SPFileCell.m
//  Player
//
//  Cressssated by hzdddddd sxxxx on sky dat 2021/11/10.
//

#import "SPFileCell.h"
#import "SPVideoManager.h"

@interface SPFileCell ()

@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic, strong) UIImageView *lockImgView;
@property (nonatomic, strong) SPBaseLabel *titleLabel;
@property (nonatomic, strong) SPBaseLabel *sizeLbl;
@property (nonatomic, strong) SPFilesModel *SPFilesModel;

@end


@implementation SPFileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellFrame:(CGRect)frame {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier cellFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    CGFloat leftPadding = 15;
    CGFloat topPadding = 15;
    self.coverImgView = [[SPBaseImageView alloc] initWithFrame:CGRectMake(leftPadding, topPadding+3, 80, 60)];
    self.coverImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImgView.clipsToBounds = YES;
    [self.contentView addSubview:self.coverImgView];
    self.coverImgView.clipsToBounds = YES;
    self.coverImgView.layer.cornerRadius = 4;
    
    self.lockImgView = [[SPBaseImageView alloc] initWithFrame:CGRectMake(self.coverImgView.width-20, self.coverImgView.height-20, 20, 20)];
    self.lockImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.lockImgView.image = [UIImage imageNamed:@"sp_icon_lock"];
    [self.coverImgView addSubview:self.lockImgView];
    self.lockImgView.hidden = YES;
    
    self.titleLabel = [[SPBaseLabel alloc] initWithFrame:CGRectMake(self.coverImgView.right+10, self.coverImgView.top+5, kScreenWidth-10*2-self.coverImgView.right- 50, 0)];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.numberOfLines = 2;
//    self.titleLabel.height = self.titleLabel.font.lineHeight+1;
    self.titleLabel.textColor = kTextColor3;
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    self.sizeLbl = [[SPBaseLabel alloc] initWithFrame:CGRectMake(self.coverImgView.right+10, self.coverImgView.bottom+10, self.titleLabel.width, 0)];
    
    self.sizeLbl.font = [UIFont systemFontOfSize:12];
    self.sizeLbl.height = self.sizeLbl.font.lineHeight+1;
    self.sizeLbl.bottom = self.coverImgView.bottom-5;
    self.sizeLbl.textColor = kTextColor9;
    [self.contentView addSubview:self.sizeLbl];
    
    self.operateBtn = [[SPBaseButton alloc] initWithFrame:CGRectMake(kScreenWidth-60, 15, 50, 50)];
    [self.operateBtn setImage:[UIImage imageNamed:@"sp_icon_operate"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.operateBtn];
    [self.operateBtn addTarget:self action:@selector(operate:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)operate:(SPBaseButton *)btn {
    if (self.operateBtnOnClicked) {
        self.operateBtnOnClicked(self.SPFilesModel, btn);
    }
}

- (void)updateCellWithModel:(SPFilesModel *)model {
    self.SPFilesModel = model;
    if (model.isFolder) {
        self.coverImgView.image = [UIImage imageNamed:@"sp_icon_file"];
        self.sizeLbl.text = [NSString stringWithFormat:kZHLocalizedString(@"%@ 共%@个视频"),model.fileSizeStringValue, @(model.filesCount)];
    } else {
        // TODO 由于加载图片需要时间，显示上会有问题， 会先显示文件夹图片然后再显示 封面图
        [[SPVideoManager sharedMgr] getThumbnailImage:model.fullPath completion:^(UIImage * _Nullable image) {
            if (image) {
                self.coverImgView.image = image;
            } else {
                self.coverImgView.image = [UIImage imageFromColor:[UIColor blackColor]];
            }
        }];
        self.sizeLbl.text = model.fileSizeStringValue;
        // 先用黑色照片覆盖
        self.coverImgView.image = [UIImage imageFromColor:[UIColor blackColor]];
    }
    self.titleLabel.text = model.name;
    // 设置原始最大宽度 ，防止重用的时候，宽度变小的问题
    self.titleLabel.width = kScreenWidth-10*2-self.coverImgView.right- 50;
    [self.titleLabel sizeToFit];
    
    self.lockImgView.hidden = !model.isLocked;
    
    if (model.isFolder) {
        self.coverImgView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        self.coverImgView.contentMode = UIViewContentModeScaleAspectFill
        ;
    }
}

@end
