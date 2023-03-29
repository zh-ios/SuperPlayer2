//
//  ZHDownloadController.m
//  Player
//
//  Created by zhuhao on 2022/10/14.
//

#import "ZHDownloadController.h"
#import "ZHDownloadCell.h"
#import "HWDownloadModel.h"
#import "HWDownloadManager.h"
#import "SPLocalFileManager.h"

@interface ZHDownloadController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray<HWDownloadModel *> *downloadDatas;


@end

@implementation ZHDownloadController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.downloadDatas = @[].mutableCopy;
    
    [self initSubviews];
    [self addNotifications];
}

- (void)initSubviews {
    self.tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kNavbarHeight, kScreenWidth, kScreenHeight - kNavbarHeight) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)addNotifications {
    // 进度通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadProgressChanged:) name:HWDownloadProgressNotification object:nil];
    // 状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadStateChanged:) name:HWDownloadStateChangeNotification object:nil];
}

#pragma mark - noti
- (void)downLoadProgressChanged:(NSNotification *)noti {
    HWDownloadModel *downloadModel = noti.object;
    @weakify(self);
    [self.downloadDatas enumerateObjectsUsingBlock:^(HWDownloadModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        if ([model.url isEqualToString:downloadModel.url]) {
            // 主线程更新cell进度
            dispatch_async(dispatch_get_main_queue(), ^{
                ZHDownloadCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
                [cell updateUIWithModel:downloadModel];
            });
            *stop = YES;
        }
    }];
}

- (void)downLoadStateChanged:(NSNotification *)noti {
    HWDownloadModel *downloadModel = noti.object;
    @weakify(self);
    [self.downloadDatas enumerateObjectsUsingBlock:^(HWDownloadModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        if ([model.url isEqualToString:downloadModel.url]) {
            // 更新数据源
            self.downloadDatas[idx] = downloadModel;
            // 主线程刷新cell
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            });
            *stop = YES;
        }
    }];
}


#pragma mark --- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.downloadDatas.count;
}

static NSString *const downloadCellID = @"downloadCellID";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:downloadCellID];
    if (!cell) {
        cell = [[ZHDownloadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:downloadCellID];
    }
    HWDownloadModel *model = self.downloadDatas[indexPath.row];
    [cell updateUIWithModel:model];
    @weakify(self);
    cell.downloadBtnOnClickBlock = ^(UIButton * _Nonnull downloadBtn, ZHDownloadCell *cell, HWDownloadModel *model) {
        @strongify(self);
        [self handleDownloadEventWithModel:model cell:cell btn:downloadBtn];
    };
    return cell;
}

- (void)handleDownloadEventWithModel:(HWDownloadModel *)model cell:(ZHDownloadCell *)cell btn:(UIButton *)btn {
    if (!model.url) return;
    @weakify(self);
    HWDownloadState downloadState = model.state;
    if (downloadState == HWDownloadStateDefault || downloadState == HWDownloadStatePaused || downloadState == HWDownloadStateError) {
        // 点击默认、暂停、失败状态，调用开始下载
        [[HWDownloadManager shareManager] startDownloadTask:model];
        
    } else if (downloadState == HWDownloadStateDownloading || downloadState == HWDownloadStateWaiting) {
        // 点击正在下载、等待状态，调用暂停下载
        [[HWDownloadManager shareManager] pauseDownloadTask:model];
    }
}


@end
