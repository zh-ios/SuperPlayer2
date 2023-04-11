//
//  SPFileCell.m
//  Player
//
//  Cressssated by hzdddddd sxxxx on sky dat 2021/11/10.
//

#import "SPFileCell.h"
#import "SPVideoManager.h"

@interface SPFileCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) SPFilesModel *SPFilesModel;

@end


@implementation SPFileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellFrame:(CGRect)frame {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier cellFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    CGFloat leftPadding = 15;
    CGFloat topPadding = 15;
    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftPadding, topPadding+3, 80, 60)];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.coverImageView];
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.layer.cornerRadius = 4;
    
    self.lockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.coverImageView.width-20, self.coverImageView.height-20, 20, 20)];
    self.lockImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.lockImageView.image = [UIImage imageNamed:@"sp_icon_lock"];
    [self.coverImageView addSubview:self.lockImageView];
    self.lockImageView.hidden = YES;
    
    self.titleL = [[SPBaseLabel alloc] initWithFrame:CGRectMake(self.coverImageView.right+10, self.coverImageView.top+5, kScreenWidth-10*2-self.coverImageView.right- 50, 0)];
    self.titleL.font = [UIFont systemFontOfSize:14];
    self.titleL.numberOfLines = 2;
//    self.titleL.height = self.titleL.font.lineHeight+1;
    self.titleL.textColor = kTextColor3;
    [self.contentView addSubview:self.titleL];
    self.titleL.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    self.sizeLabel = [[SPBaseLabel alloc] initWithFrame:CGRectMake(self.coverImageView.right+10, self.coverImageView.bottom+10, self.titleL.width, 0)];
    
    self.sizeLabel.font = [UIFont systemFontOfSize:12];
    self.sizeLabel.height = self.sizeLabel.font.lineHeight+1;
    self.sizeLabel.bottom = self.coverImageView.bottom-5;
    self.sizeLabel.textColor = kTextColor9;
    [self.contentView addSubview:self.sizeLabel];
    
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
        self.coverImageView.image = [UIImage imageNamed:@"sp_icon_file"];
        self.sizeLabel.text = [NSString stringWithFormat:kZHLocalizedString(@"%@ 共%@个视频"),model.fileSizeStringValue, @(model.filesCount)];
    } else {
        // TODO 由于加载图片需要时间，显示上会有问题， 会先显示文件夹图片然后再显示 封面图
        [[SPVideoManager sharedMgr] getThumbnailImage:model.fullPath completion:^(UIImage * _Nullable image) {
            if (image) {
                self.coverImageView.image = image;
            } else {
                self.coverImageView.image = [UIImage imageFromColor:[UIColor blackColor]];
            }
        }];
        self.sizeLabel.text = model.fileSizeStringValue;
        // 先用黑色照片覆盖
        self.coverImageView.image = [UIImage imageFromColor:[UIColor blackColor]];
    }
    self.titleL.text = model.name;
    // 设置原始最大宽度 ，防止重用的时候，宽度变小的问题
    self.titleL.width = kScreenWidth-10*2-self.coverImageView.right- 50;
    [self.titleL sizeToFit];
    
    self.lockImageView.hidden = !model.isLocked;
    
    if (model.isFolder) {
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill
        ;
    }
}

@end
