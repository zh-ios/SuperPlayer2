//
//  SPFolderDetailController.m
//  Player
//
//  Created by hz on 2021/11/15.
//

#import "SPFolderDetailController.h"
#import "SPEmptyControl.h"
#import "SPLocalFileManager.h"
#import "SPFileCell.h"
#import "SPVideoPlayerController.h"
#import "SPAllLocalFoldersController.h"
#import "SPActionSheet.h"


@interface SPFolderDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *filesArray;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SPEmptyControl *emptyView;

@end

@implementation SPFolderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.filesArray = @[].mutableCopy;
    [self reloadController];
    self.title = [NSString stringWithFormat:kZHLocalizedString(@"文件夹：%@"),self.folderModel.name];
}

- (void)reloadController {
    self.filesArray = [[[SPLocalFileManager sharedManager] getFilesInFolder:self.folderModel.fullPath fliterFiles:NO] mutableCopy];
    // 更新是否是加密文件属性
    for (SPFilesModel *m in self.filesArray) {
        m.isLocked = self.folderModel.isLocked;
    }
    
    if (self.filesArray.count == 0) {
        if (!self.emptyView) {
            SPEmptyControl *control = [SPEmptyControl showEmptyViewOnView:self.view inset:UIEdgeInsetsMake(kNavbarHeight, 0, kTabbarHeight, 0)];
            self.emptyView = control;
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
        _tableView.tableFooterView = [[BaseView alloc] init];
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
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
    [cell updateCellWithFileModel:self.filesArray[indexPath.row]];
    @weakify(self)
    cell.operateBtnOnClicked = ^(SPFilesModel * _Nonnull model, UIButton *btn){
        @strongify(self)
        [self showOperateAlert:model indexPath:indexPath  sourceBtn:btn];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SPVideoPlayerController *playerVC = [[SPVideoPlayerController alloc] init];
    playerVC.hidesBottomBarWhenPushed = YES;
    
    
    NSArray *filesArr = [[SPLocalFileManager sharedManager] getFilesInFolder:self.folderModel.fullPath fliterFiles:NO];
    NSMutableArray *filesURLArr = @[].mutableCopy;
    for (SPFilesModel *model in filesArr) {
        [filesURLArr addObject:model.fullPath];
    }
    
    playerVC.urls = [filesURLArr copy];
    playerVC.currentIndex = indexPath.row;
    [self.navigationController pushViewController:playerVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SPFilesModel *model = [self.filesArray objectAtIndex:indexPath.row];
        [self deleteFiles:model indexPath:indexPath];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kZHLocalizedString(@"删除");
}


- (void)deleteFiles:(SPFilesModel *)model indexPath:(NSIndexPath *)indexPath {
    [self.filesArray removeObject:model];

    [[SPLocalFileManager sharedManager] deleteFile:model.fullPath];
    [self reloadController];
}

- (void)showOperateAlert:(SPFilesModel *)model indexPath:(NSIndexPath *)indexPath sourceBtn:(UIButton *)btn {
    
    SPActionSheetItem *disableItem = [SPActionSheetItem makeSPActionSheetItemWithTitle:kZHLocalizedString(@"选择您想要进行的操作") style:SPActionSheetItemStyle_Title];
    SPActionSheetItem *deleteItem = [SPActionSheetItem makeSPActionSheetItemWithTitle:kZHLocalizedString(@"删除") style:SPActionSheetItemStyle_Default];
    SPActionSheetItem *renameItem = [SPActionSheetItem makeSPActionSheetItemWithTitle:kZHLocalizedString(@"重命名") style:SPActionSheetItemStyle_Default];
    SPActionSheetItem *moveItem = [SPActionSheetItem makeSPActionSheetItemWithTitle:kZHLocalizedString(@"将文件移出该文件夹") style:SPActionSheetItemStyle_Default];
    
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
                [self deleteFiles:model indexPath:indexPath];
            }
            if (index == 2) {
                [self reNameFiles:model];
            }
            if (index == 3) {
                NSString *targetPath = (model.isLocked?[[SPLocalFileManager sharedManager] getLockedFilePath]:[[SPLocalFileManager sharedManager] getGlobalFilePath]);
                
                if ([[SPLocalFileManager sharedManager] hasSameNameFile:model.name folderPath:targetPath]) {
                    [ZHToastUtil showToast:kZHLocalizedString(@"已存在同名文件，请重命名后再试~")];
                    return;
                }

                BOOL success = [[SPLocalFileManager sharedManager] moveFileFromPath:model.fullPath toPath:targetPath];
                if (success) {
                    [self.filesArray removeObject:model];
                    [self.tableView reloadData];
                    [self reloadController];
                } else {
                    [ZHToastUtil showToast:kZHLocalizedString(@"操作失败，请重命名后再进行操作")];
                }
            }
        }];
    };
}

- (void)reNameFiles:(SPFilesModel *)model {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kZHLocalizedString(@"请重新输入文件的名字") message:model.name preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:kZHLocalizedString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *folderName = [alert.textFields firstObject].text;
        if ([folderName trimingWhiteSpaceAndNewline] == 0) {
            [ZHToastUtil showToast:kZHLocalizedString(@"请输入有效文件名")];
            return;
        }
        BOOL repeated = NO;
        repeated = [[SPLocalFileManager sharedManager] hasSameNameFile:folderName folderPath:self.folderModel.fullPath];
        if (repeated) {
            [ZHToastUtil showToast:kZHLocalizedString(@"重名了，换一个名字吧~")];
        } else {
            [[SPLocalFileManager sharedManager] reNameFoldersWithName:folderName folderPath:model.fullPath];
            [self reloadController];
        }
    }];
    [alert addAction:action];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = kZHLocalizedString(@"请输入文件名");
    }];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

@end
