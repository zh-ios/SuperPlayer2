//
//  SPAllLocalFoldersController.m
//  Player
//
//  Cressssated by hzdddddd sxxxx on sky dat 2021/11/15.
//

#import "SPAllLocalFoldersController.h"
#import "SPLocalFileManager.h"
#import "SPEmptyControl.h"
#import "SPFileCell.h"

@interface SPAllLocalFoldersController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *folders;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SPEmptyControl *emptyView;

@end

@implementation SPAllLocalFoldersController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadController];
    self.title = kZHLocalizedString(@"请选择要放入的文件夹");
}

- (void)reloadController {
    if (self.model.isLocked) {
        self.folders = [[SPLocalFileManager sharedMgr] getLockedFolders];
    } else {
        self.folders = [[SPLocalFileManager sharedMgr] getLocalFolders];
    }
    
    if (self.folders.count == 0) {
        if (!self.emptyView) {
            SPEmptyControl *control = [SPEmptyControl showEmptyViewOnView:self.view inset:UIEdgeInsetsMake(kNavbarHeight, 0, kTabbarHeight, 0)];
            self.emptyView = control;
            self.emptyView.titleLabel.text = kZHLocalizedString(@"当前目录没有文件夹~_~");
            [self.view addSubview:control];
        } else {
            self.emptyView.hidden = NO;
            self.tableView.hidden = YES;
        }
       
    } else {
        self.tableView.hidden = NO;
        self.emptyView.hidden = YES;
        if (![self.view.subviews containsObject:self.tableView]) {
            [self.view addSubview:self.tableView];
        }
        [self.tableView reloadData];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavbarHeight, kScreenWidth, kScreenHeight-kNavbarHeight-kTabbarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 90;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[SPBaseView alloc] init];
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
    }
    return _tableView;
}

#pragma mark --- tableViewDelegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.folders.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"SPFileCellid";
    SPFileCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SPFileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    }
    [cell updateCellWithModel:self.folders[indexPath.row]];
    cell.operateBtn.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SPFilesModel *folder = self.folders[indexPath.row];
    BOOL success = [[SPLocalFileManager sharedMgr] moveFileFromPath:self.model.fullPath toPath:folder.fullPath];
    if (success) {
        [SPToastUtil showToast:kZHLocalizedString(@"已放入该文件夹,将自动返回上一页面") completed:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        [SPToastUtil showToast:kZHLocalizedString(@"操作失败，请重命名后再进行操作")];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
