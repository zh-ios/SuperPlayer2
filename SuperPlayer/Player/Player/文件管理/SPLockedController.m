//
//  MovieRepoController.m
//  SMPlayer
//
//  Cressssated by hzdddddd sxxxx on sky dat 2021/10/21.
//

#import "SPLockedController.h"
#import "SPLocalFileManager.h"
#import "SPFileCell.h"
#import "SPFolderDetailController.h"
#import "SPAllLocalFoldersController.h"
#import "SPScreenLockController.h"
#import "SPVideoPlayerController.h"
#import "SPActionSheet.h"

@interface  SPLockedController()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *filesArray;
@property (nonatomic, strong) SPEmptyControl *emptyView;
@property (nonatomic, strong) SPScreenLockController *SPScreenLockController;

// 是否是push到了下一个页面 ，这种情况下调用viewWillApper 不需要弹出加密弹窗
@property (nonatomic, assign) BOOL isPushedToNextPage;

@property (nonatomic, assign) BOOL shouldReloadData;


@end

@implementation SPLockedController

- (NSMutableArray *)filesArray {
    if (!_filesArray) {
        _filesArray = @[].mutableCopy;
    }
    return _filesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kZHLocalizedString(@"Vip视频");
    [self reloadController];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadViewController:) name:@"lockedFilesUpdatedNoti" object:nil];
}

- (void)showLockView {
    BOOL ret = [[NSUserDefaults standardUserDefaults] boolForKey:kDontShowThisTime];
    BOOL hadSetPWD = [[NSUserDefaults standardUserDefaults] boolForKey:kHadSetPwd];
    if (!ret && hadSetPWD && !self.isPushedToNextPage) {
        if (!self.SPScreenLockController) {
            SPScreenLockController *screenLockVC = [[SPScreenLockController alloc] init];
            screenLockVC.customNavView.backBtn.hidden = YES;
            screenLockVC.view.frame = CGRectMake(0, 0, self.view.width, kScreenHeight-kTabbarHeight);
            [self.view addSubview:screenLockVC.view];
            [self addChildViewController:screenLockVC];
            self.SPScreenLockController = screenLockVC;
            @weakify(self)
            self.SPScreenLockController.inputRightPwdCallback = ^{
            @strongify(self)
                [self.SPScreenLockController.view removeFromSuperview];
                [self.SPScreenLockController removeFromParentViewController];
                self.SPScreenLockController = nil;
            };
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.shouldReloadData) {
        [self reloadController];
        [self.tableView reloadData];
        self.shouldReloadData = NO;
    }
    [self showLockView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.navigationController.childViewControllers.count == 1) {
        self.isPushedToNextPage = NO;
    }
}

- (SPEmptyControl *)emptyView {
    if (!_emptyView) {
       _emptyView = [SPEmptyControl showEmptyViewOnView:self.view inset:UIEdgeInsetsMake(kNavbarHeight, 0, kTabbarHeight, 0)];
        _emptyView.titleLabel.text = kZHLocalizedString(@"空空如也，点击上传视频 ~_~");
        [self.view addSubview:_emptyView];
        _emptyView.hidden = YES;
        _emptyView.emptyViewOnClicked = ^{
            [SPToastUtil showToast:kZHLocalizedString(@"请到首页上传视频")];
            AppDelegate *appDelegate = kAppDelegate;
            appDelegate.tabbar.selectedIndex = 0;
        };
    }
    return _emptyView;
}

- (void)reloadViewController:(NSNotification *)noti {
    [self reloadController];
    [self.tableView reloadData];
}

- (void)reloadController {
    NSArray *localFolders = [[SPLocalFileManager sharedMgr] getLocalLockedFiles];
    self.filesArray = [NSMutableArray arrayWithArray:localFolders];
    if (localFolders.count == 0) {
        self.emptyView.hidden = NO;
        self.tableView.hidden = YES;
    } else {
        self.tableView.hidden = NO;
        self.emptyView.hidden = YES;
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
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark --- tableViewDelegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filesArray.count;
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
    [cell updateCellWithModel:self.filesArray[indexPath.row]];
    @weakify(self)
    cell.operateBtnOnClicked = ^(SPFilesModel * _Nonnull model, SPBaseButton *btn){
        @strongify(self)
        [self showOperateAlert:model indexPath:indexPath sourceBtn:btn];
    };

    return cell;		
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SPFilesModel *model = [self.filesArray objectAtIndex:indexPath.row];
        if (model.isFolder) {
            [self deleteFolders:model indexPath:indexPath];
        } else {
            [self deleteOption:model];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kZHLocalizedString(@"删除");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SPFilesModel *model = self.filesArray[indexPath.row];
    if (model.isFolder) {
        SPFolderDetailController *detailVC = [[SPFolderDetailController alloc] init];
        detailVC.folderModel = model;
        detailVC.hidesBottomBarWhenPushed = YES;
        self.shouldReloadData = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
        self.isPushedToNextPage = YES;
    } else {
        NSMutableArray *fileURLArr = @[].mutableCopy;
        for (SPFilesModel *m in self.filesArray) {
            if (!m.isFolder) {
                [fileURLArr addObject:m.fullPath];
            }
        }
        SPVideoPlayerController *playerVC = [[SPVideoPlayerController alloc] init];
        playerVC.hidesBottomBarWhenPushed = YES;
        playerVC.urls = [fileURLArr copy];
        playerVC.currentIndex = [fileURLArr indexOfObject:model.fullPath];
        self.isPushedToNextPage = YES;
        [self.navigationController pushViewController:playerVC animated:YES];
    }
}

- (void)showOperateAlert:(SPFilesModel *)model indexPath:(NSIndexPath *)indexPath sourceBtn:(SPBaseButton *)btn {

    SPActionSheetItem *disableItem = [SPActionSheetItem makeSPActionSheetItemWithTitle:kZHLocalizedString(@"选择您想要进行的操作") style:SPActionSheetItemStyle_Title];
    SPActionSheetItem *deleteItem = [SPActionSheetItem makeSPActionSheetItemWithTitle:kZHLocalizedString(@"删除") style:SPActionSheetItemStyle_Default];
    SPActionSheetItem *renameItem = [SPActionSheetItem makeSPActionSheetItemWithTitle:kZHLocalizedString(@"重命名") style:SPActionSheetItemStyle_Default];
    SPActionSheetItem *moveItem = [SPActionSheetItem makeSPActionSheetItemWithTitle:kZHLocalizedString(@"移动到文件夹") style:SPActionSheetItemStyle_Default];
    
    SPActionSheet *sheet = [[SPActionSheet alloc] init];
    NSMutableArray *items = @[].mutableCopy;
    [items addObject:disableItem];
    [items addObject:deleteItem];
    [items addObject:renameItem];
    if (!model.isFolder) {
        [items addObject:moveItem];
    }
    sheet.dataSource = items;
    [sheet show];
    sheet.selectRowBlock = ^(SPActionSheet *actionSheet, NSString *key, NSInteger index) {
        [actionSheet hideWithCompletionBlock:^{
            if (index == 1) {
                if (model.isFolder) {
                    [self deleteFolders:model indexPath:indexPath];
                } else {
                    [self deleteOption:model];
                }
            }
            if (index == 2) {
                [self reNameFiles:model];
            }
            if (index == 3) {
                SPAllLocalFoldersController *folders = [[SPAllLocalFoldersController alloc] init];
                folders.model = self.filesArray[indexPath.row];
                folders.hidesBottomBarWhenPushed = YES;
                self.isPushedToNextPage = YES;
                self.shouldReloadData = YES;
                [self.navigationController pushViewController:folders animated:YES];
            }
        }];
    };
    
}


- (void)showCreateFolderAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kZHLocalizedString(@"请输入文件夹名字") message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:kZHLocalizedString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *folderName = [alert.textFields firstObject].text;
        BOOL repeated = [[SPLocalFileManager sharedMgr] hasSameNameFolders:folderName folderPath:[[SPLocalFileManager sharedMgr] getGlobalFilePath]];
        if (repeated) {
            [SPToastUtil showToast:kZHLocalizedString(@"重名了，换一个名字吧~")];
        } else {
            [[SPLocalFileManager sharedMgr] createFolders:folderName];
            [self reloadController];
        }
    }];
    [alert addAction:action];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
    }];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}




- (void)deleteFolders:(SPFilesModel *)model indexPath:(NSIndexPath *)indexPath{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kZHLocalizedString(@"确定删除吗？") message:kZHLocalizedString(@"删除该文件夹后，文件下内的所有视频也将被删除!") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:kZHLocalizedString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteOption:model];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:kZHLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)reNameFiles:(SPFilesModel *)model {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kZHLocalizedString(@"请重新输入文件的名字") message:model.name preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:kZHLocalizedString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *folderName = [alert.textFields firstObject].text;
        [self reNameFileOp:folderName fileModel:model];
    }];
    [alert addAction:action];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = kZHLocalizedString(@"请输入文件名");
    }];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark --文件各种操作
- (void)deleteOption:(SPFilesModel *)file {
    [[SPLocalFileManager sharedMgr] deleteFolders:file.fullPath];
    NSInteger index = [self.filesArray indexOfObject:file];
    [self.filesArray removeObject:file];
    NSIndexPath *deletedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[deletedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if (self.filesArray.count == 0) {
        self.emptyView.hidden = NO;
        self.tableView.hidden = YES;
    }
}


- (void)reNameFileOp:(NSString *)fileName fileModel:(SPFilesModel *)model {
    if ([fileName trimingWhiteSpaceAndNewline].length == 0) {
        [SPToastUtil showToast:kZHLocalizedString(@"请输入有效文件名")];
        return;
    }
    BOOL repeated = NO;
    if (model.isFolder) {
       repeated = [[SPLocalFileManager sharedMgr] hasSameNameFolders:fileName folderPath:[[SPLocalFileManager sharedMgr] getGlobalFilePath]];
    } else {
       repeated = [[SPLocalFileManager sharedMgr] hasSameNameFile:fileName folderPath:[[SPLocalFileManager sharedMgr] getGlobalFilePath]];
    }
     
    if (repeated) {
        [SPToastUtil showToast:kZHLocalizedString(@"重名了，换一个名字吧~")];
        return;
    } else {
        NSInteger index = [self.filesArray indexOfObject:model];
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [[SPLocalFileManager sharedMgr] reNameFoldersWithName:fileName folderPath:model.fullPath];
        NSString *targetName = [fileName stringByAppendingPathExtension:[model.fullPath pathExtension]];
        model.fullPath = [model.fullPath stringByReplacingOccurrencesOfString:model.name withString:targetName];

        model.name = targetName;
        [self.tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
