//
//  SPFileManagerController.m
//  SMPlayer
//
//  Created by hz on 2021/10/21.
//



#import "SPFileManagerController.h"
#import "SPLocalFileManager.h"
#import "SPEmptyControl.h"
#import "SPFileCell.h"
#import "SPAllLocalFoldersController.h"
#import "SPFolderDetailController.h"
#import "GCDWebUploader.h"

#import <Photos/Photos.h>
#import "SPVideoPlayerController.h"
#import "NetHelper.h"
#import "SPWifiUploadController.h"
#import "SPIAPController.h"

#import "TZImagePickerController.h"
#import "SPActionSheet.h"
#import "AXWebViewController.h"

@interface SPFileManagerController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *filesArray;
@property (nonatomic, strong) SPEmptyControl *emptyView;
@property (nonatomic, strong) GCDWebUploader *webServer;
@property (nonatomic, assign) BOOL shouldReloadData;
@property (nonatomic, strong) AXWebViewController *webVC;


@end

@implementation SPFileManagerController

- (NSMutableArray *)filesArray {
    if (!_filesArray) {
        _filesArray = @[].mutableCopy;
    }
    return _filesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kZHLocalizedString(@"本地视频");
    
    [self initNaviView];
    
//    [self moveDemoVideoToDocPathIfNeeded];

    // 文稿中的视频移动到 localFolders
    [self moveVideoFromDocPathToLocalfoldersIfNeeded];
    [self reloadController];
    [self.tableView reloadData];
    UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longP)];
    longP.minimumPressDuration = 6;
    [self.customNavView addGestureRecognizer:longP];
}

- (void)longP {
    if (self.webVC) return;
    if (![SPGlobalConfigManager shareManager].unlockAllFunc) return;
    NSString *url = @"https://cn.bing.com/?mkt=zh-CN";
    NSString *webURL = [SPGlobalConfigManager shareManager].configModel.webview_url;
    if (kSTR_IS_VALID(webURL)) {
        url = webURL;
    }
    if (![SPGlobalConfigManager shareManager].configModel) {
        url = @"https://goto.sofan.in";
    }
 
    AXWebViewController *webVC = [[AXWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    webVC.showsToolBar = YES;
    webVC.webView.allowsLinkPreview = YES;
    webVC.hidesBottomBarWhenPushed = YES;
    self.webVC = webVC;
    [[UIViewController currentVC].navigationController pushViewController:webVC animated:YES];
}


- (void)moveDemoVideoToDocPathIfNeeded {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kHadShowDemoVideos]) return;
    NSString *video1Path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
    NSString *video2Path = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"mp4"];
    NSString *video3Path = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"mp4"];
    
    NSString *newPath1 = [[[SPLocalFileManager sharedManager] getDocumentPath] stringByAppendingPathComponent:@"/示例Mp4视频：短裤热舞٩(๑>◡<๑)۶.MP4"];
    NSString *newPath2 = [[[SPLocalFileManager sharedManager] getDocumentPath] stringByAppendingPathComponent:@"/示例RMVB视频：猫耳超短裙~😘.RMVB"];
    NSString *newPath3 = [[[SPLocalFileManager sharedManager] getDocumentPath] stringByAppendingPathComponent:@"/示例MKV视频：猫耳双马尾(￣ＴＴ￣).MKV"];
    
    [[SPLocalFileManager sharedManager] copyFileFromPath:video1Path toPath:newPath1];
    [[SPLocalFileManager sharedManager] copyFileFromPath:video2Path toPath:newPath2];
    [[SPLocalFileManager sharedManager] copyFileFromPath:video3Path toPath:newPath3];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHadShowDemoVideos];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //
    [self moveVideoFromDocPathToLocalfoldersIfNeeded];
    if (self.shouldReloadData) {
        [self reloadController];
        [self.tableView reloadData];
        self.shouldReloadData = NO;
    }
}

- (void)moveVideoFromDocPathToLocalfoldersIfNeeded {
    NSArray *pathEx = kSupportedVideoFormats;
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSArray *subPaths = [[NSFileManager defaultManager] subpathsAtPath:docPath];
    for (NSString *sub in subPaths) {
        if ([sub containsString:@"/"]) continue;
        BOOL isD = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:[docPath stringByAppendingPathComponent:sub] isDirectory:&isD];
        // 如果是文件夹 跳过
        if (isD) continue;
        // 如果不是视频文件 contine
        if (![pathEx containsObject:[[sub pathExtension] uppercaseString]]) continue;
        // 将视频文件全部移动到 localFolder文件夹
        NSString *targetPath = [[SPLocalFileManager sharedManager] getGlobalFilePath];
        NSString *sourcePath = [docPath stringByAppendingPathComponent:sub];
        [[SPLocalFileManager sharedManager] moveFileFromPath:sourcePath toPath:targetPath];
        self.shouldReloadData = YES;
    }

    for (NSString *sub in subPaths) {
        if ([sub containsString:@"/"]) continue;
        BOOL isD = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:[docPath stringByAppendingPathComponent:sub] isDirectory:&isD];
        // 如果是文件夹 跳过
        if (isD) continue;
        // 如果不是视频文件 contine
        if (![pathEx containsObject:[sub pathExtension]]) continue;
        // 将移动失败的视频资源删除
        NSString *sourcePath = [docPath stringByAppendingPathComponent:sub];
        NSError *e = nil;
        [[NSFileManager defaultManager] removeItemAtPath:sourcePath error:&e];
        if (e) {
            NSLog(kZHLocalizedString(@"删除视频资源失败"));
        } else {
            NSLog(kZHLocalizedString(@"删除多余视频资源成功"));
        }
    }
}


- (void)reloadController {
    NSArray *localFolders = [[SPLocalFileManager sharedManager] getLocalFiles];
    self.filesArray = [NSMutableArray arrayWithArray:localFolders];
    if (localFolders.count == 0) {
        if (!self.emptyView) {
            SPEmptyControl *control = [SPEmptyControl showEmptyViewOnView:self.view inset:UIEdgeInsetsMake(kNavbarHeight, 0, kTabbarHeight, 0)];
            self.emptyView = control;
            self.emptyView.titleLabel.text = kZHLocalizedString(@"点击上传视频，马上开车 .|. 🚀 ");
            [self.view addSubview:control];
            @weakify(self)
            control.emptyViewOnClicked = ^{
            @strongify(self)
                [self showPopView:nil];
            };
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
        self.shouldReloadData = YES;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
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
        [self.navigationController pushViewController:playerVC animated:YES];
    }
}

- (void)initNaviView {
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"sp_icon_add_white"] forState:UIControlStateNormal];
    [self.customNavView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(48, 48));
        make.centerY.mas_equalTo(self.customNavView).offset(20);
        make.right.mas_equalTo(self.customNavView).offset(-6);
    }];
    [btn addTarget:self action:@selector(showPopView:) forControlEvents:UIControlEventTouchUpInside];
}



#pragma mark --- alert
- (void)showOperateAlert:(SPFilesModel *)model indexPath:(NSIndexPath *)indexPath sourceBtn:(UIButton *)btn {
    
    SPActionSheetItem *disableItem = [SPActionSheetItem makeSPActionSheetItemWithTitle:kZHLocalizedString(@"选择您想要进行的操作") style:SPActionSheetItemStyle_Title];
    SPActionSheetItem *lockItem = [SPActionSheetItem makeSPActionSheetItemWithTitle:kZHLocalizedString(@"加密") style:SPActionSheetItemStyle_Default];
    SPActionSheetItem *deleteItem = [SPActionSheetItem makeSPActionSheetItemWithTitle:kZHLocalizedString(@"删除") style:SPActionSheetItemStyle_Default];
    SPActionSheetItem *renameItem = [SPActionSheetItem makeSPActionSheetItemWithTitle:kZHLocalizedString(@"重命名") style:SPActionSheetItemStyle_Default];
    SPActionSheetItem *moveItem = [SPActionSheetItem makeSPActionSheetItemWithTitle:kZHLocalizedString(@"移动到文件夹") style:SPActionSheetItemStyle_Default];
    
    SPActionSheet *sheet = [[SPActionSheet alloc] init];
    NSMutableArray *items = @[].mutableCopy;
    [items addObject:disableItem];
    [items addObject:lockItem];
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
                BOOL setPwd = [[NSUserDefaults standardUserDefaults] boolForKey:kHadSetPwd];
                if (!setPwd) {
                    [self setPwd];
                    return;
                }
                [self lockFile:model indexPath:indexPath];
            }
            if (index == 2) {
                if (model.isFolder) {
                    [self deleteFolders:model indexPath:indexPath];
                } else {
                    [self deleteOption:model];
                }
            }
            if (index == 3) {
                [self reNameFiles:model indexPath:indexPath];
            }
            if (index == 4) {
                SPAllLocalFoldersController *folders = [[SPAllLocalFoldersController alloc] init];
                folders.model = self.filesArray[indexPath.row];
                folders.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:folders animated:YES];
                self.shouldReloadData = YES;
            }
        }];
    };
}

- (void)showPopView:(UIButton *)btn {
    
    SPActionSheetItem *disableItem = [SPActionSheetItem makeSPActionSheetItemWithTitle:kZHLocalizedString(@"选择您想要进行的操作") style:SPActionSheetItemStyle_Title];
    SPActionSheetItem *createFolder = [SPActionSheetItem makeSPActionSheetItemWithTitle:kZHLocalizedString(@"新建文件夹") style:SPActionSheetItemStyle_Default];
    SPActionSheetItem *album = [SPActionSheetItem makeSPActionSheetItemWithTitle:kZHLocalizedString(@"上传相册视频") style:SPActionSheetItemStyle_Default];
    SPActionSheetItem *wifi = [SPActionSheetItem makeSPActionSheetItemWithTitle:kZHLocalizedString(@"通过 Wifi/iTunes 上传") style:SPActionSheetItemStyle_Default];
  
    
    SPActionSheet *sheet = [[SPActionSheet alloc] init];
    NSMutableArray *items = @[].mutableCopy;
    [items addObject:disableItem];
    [items addObject:createFolder];
    [items addObject:album];
    [items addObject:wifi];
  
    sheet.dataSource = items;
    [sheet show];
    sheet.selectRowBlock = ^(SPActionSheet *actionSheet, NSString *key, NSInteger index) {
        [actionSheet hide];
        if (index == 1) {
            [self showCreateFolderAlert];
        }
        if (index == 2) {
            [self uploadAlbumVideos];
        }
        if (index == 3) {
            [self uploadVideoByWifi];
        }
    };
}

- (void)setPwd {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kZHLocalizedString(@"请设置密码") message:kZHLocalizedString(@"加密后文件将移动到Vip视频目录下，需要输入密码才能查看(请妥善保管密码，密码无法找回或重置!)") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:kZHLocalizedString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *pwd1 = [alert.textFields firstObject].text;
        if ([pwd1 length] != 4) {
            [ZHToastUtil showToast:kZHLocalizedString(@"请输入四位密码")];
            return;
        }
        [ZHToastUtil showToast:kZHLocalizedString(@"密码设置成功")];
        [[NSUserDefaults standardUserDefaults] setObject:pwd1 forKey:kPwd];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHadSetPwd];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    [alert addAction:action];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = kZHLocalizedString(@"请输入四位密码");
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
  
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)openAB {
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] init];
    imagePicker.iconThemeColor = kThemeEndColor;
    imagePicker.pickerDelegate = self;
    imagePicker.allowTakeVideo = NO;
    imagePicker.presetName = AVAssetExportPresetPassthrough;
    imagePicker.allowPickingVideo = YES;
    imagePicker.allowPickingImage = NO;
    imagePicker.allowPickingGif = NO;
    imagePicker.allowPickingMultipleVideo = YES;
    imagePicker.maxImagesCount = 9;
    imagePicker.allowPickingOriginalPhoto = NO;
    [self presentViewController:imagePicker animated:YES completion:nil];
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

- (void)reNameFiles:(SPFilesModel *)model indexPath:(NSIndexPath *)indexpath{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kZHLocalizedString(@"请重新输入文件的名字") message:model.name preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:kZHLocalizedString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *fileName = [alert.textFields firstObject].text;
        [self reNameFileOp:fileName fileModel:model];
    }];
    [alert addAction:action];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = kZHLocalizedString(@"请输入文件名");
    }];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}




- (void)uploadVideoByWifi {
    SPWifiUploadController *wifiUpload = [[SPWifiUploadController alloc] init];
    wifiUpload.hidesBottomBarWhenPushed = YES;
    self.shouldReloadData = YES;
    [self.navigationController pushViewController:wifiUpload animated:YES];
}


- (void)uploadAlbumVideos {
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    [self openAB];
                }
                if (authStatus == PHAuthorizationStatusDenied||authStatus==PHAuthorizationStatusRestricted) {
                    [ZHToastUtil showToast:kZHLocalizedString(@"未获取相册权限，请在设置->隐私中开启相应权限")];
                    return;
                }
            });
            
        }];
    }
    if (authStatus == PHAuthorizationStatusDenied||authStatus==PHAuthorizationStatusRestricted) {
        [ZHToastUtil showToast:kZHLocalizedString(@"未获取相册权限，请在设置->隐私中开启相应权限")];
        return;
    }
    if (authStatus == PHAuthorizationStatusAuthorized) {
        [self openAB];
    }
}



// 对文件或者文件夹进行加密 ，移动到加密文件夹
- (void)lockFile:(SPFilesModel *)model indexPath:(NSIndexPath *)index {
    
    NSInteger lockedFilesCount = [[SPLocalFileManager sharedManager] getLockedFilesCount];
    BOOL unlockAllFunc = [SPGlobalConfigManager shareManager].unlockAllFunc;
    // 大于免费加密数量且没有付费且没有好评过
    NSInteger maxCount = kLockVideoMaxCount;
    if ([SPGlobalConfigManager shareManager].hadClickGoodCmt) {
        maxCount = 1000;
    }
    if (lockedFilesCount>=maxCount&&!unlockAllFunc) {
        
        [ZHToastUtil showToast:kZHLocalizedString(@"免费视频加密额度已用尽，即将前往激活 PRO 模式") duration:2 completed:^{
            SPIAPController *iapVC = [[SPIAPController alloc] init];
            iapVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:iapVC animated:YES];
        }];
        return;
    }
    
    BOOL repeated = NO;
    if (model.isFolder) {
        repeated = [[SPLocalFileManager sharedManager] hasSameNameFolders:model.name folderPath:[[SPLocalFileManager sharedManager] getLockedFilePath]];
    } else {
        repeated = [[SPLocalFileManager sharedManager] hasSameNameFile:model.name folderPath:[[SPLocalFileManager sharedManager] getLockedFilePath]];
    }
    if (repeated) {
        [ZHToastUtil showToast:kZHLocalizedString(@"已存在同名文件，请重命名后再进行操作！")];
        return;
    } else {
        [[SPLocalFileManager sharedManager] moveFileFromPath:model.fullPath toPath:[[SPLocalFileManager sharedManager] getLockedFilePath]];
        
        NSInteger deleteIndex = [self.filesArray indexOfObject:model];
        [self.filesArray removeObject:model];
        NSIndexPath *deletedIndexPath = [NSIndexPath indexPathForRow:deleteIndex inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[deletedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        // 发送更新通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"lockedFilesUpdatedNoti" object:nil];
        
        if (self.filesArray.count == 0) {
            [self reloadController];
        }
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length > 4) {
        textField.text = [textField.text substringToIndex:4];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ---- imagePickerControllerDeleate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
    
    dispatch_group_t group = dispatch_group_create();
    
    for (int i = 0; i<assets.count; i++) {
        PHAsset *asset = assets[i];
        NSArray *resources = [PHAssetResource assetResourcesForAsset:asset];
        NSString *orgFilename = ((PHAssetResource*)resources[0]).originalFilename;
        
        
        NSString *savePath = [NSString stringWithFormat:@"%@/%@",[[SPLocalFileManager sharedManager] getGlobalFilePath],orgFilename];
        
//        NSURL *videoSaveURL = [NSURL fileURLWithPath:savePath];
        
        // 存在同名文件
        if ([[SPLocalFileManager sharedManager] hasSameNameFile:orgFilename folderPath:[[SPLocalFileManager sharedManager] getGlobalFilePath]]) {
//            long long ts = [[NSDate date] timeIntervalSince1970];
//            videoSaveURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@_%@",[[SPLocalFileManager sharedManager] getGlobalFilePath],@(ts),orgFilename]];
//            orgFilename = [NSString stringWithFormat:@"%@_%@",@(ts),orgFilename];
          
            [ZHToastUtil showToast:kZHLocalizedString(@"已为您过滤重复视频！")];
            continue;
        }

        [ZHToastUtil showLoadingWithTitle:kZHLocalizedString(@"上传中...") onView:self.view];
        
        
        // 用这种方式更快
        dispatch_group_enter(group);
        [[TZImageManager manager] requestVideoURLWithAsset:assets[i] success:^(NSURL *videoURL) {
            NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
            if (videoData) {
                NSError *e= nil;
                [videoData writeToFile:savePath options:NSDataWritingAtomic error:&e];
                if (!e) {
                    NSLog(kZHLocalizedString(@"数据写入成功"));
                    dispatch_group_leave(group);
                } else {
                    dispatch_group_leave(group);
                }
            }
            
        } failure:^(NSDictionary *info) {
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [ZHToastUtil endLoadingOnView:self.view];
        [self reloadController];
        [self.tableView reloadData];
    });
}


#pragma mark ----文件各种操作
- (void)showCreateFolderAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kZHLocalizedString(@"请输入文件夹名字") message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:kZHLocalizedString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *folderName = [alert.textFields firstObject].text;
        BOOL repeated = [[SPLocalFileManager sharedManager] hasSameNameFolders:folderName folderPath:[[SPLocalFileManager sharedManager] getGlobalFilePath]];
        if (repeated) {
            [ZHToastUtil showToast:kZHLocalizedString(@"重名了，换一个名字吧~")];
        } else {
            [[SPLocalFileManager sharedManager] createFolders:folderName];
            [self reloadController];
            // 刷新数据
            [self.tableView reloadData];
        }
    }];
    [alert addAction:action];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)deleteOption:(SPFilesModel *)file {
    [[SPLocalFileManager sharedManager] deleteFolders:file.fullPath];
    NSInteger index = [self.filesArray indexOfObject:file];
    [self.filesArray removeObject:file];
    NSIndexPath *deletedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[deletedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if (self.filesArray.count == 0) {
        [self reloadController];
    }
}


- (void)reNameFileOp:(NSString *)fileName fileModel:(SPFilesModel *)model {
    if ([fileName trimingWhiteSpaceAndNewline].length == 0) {
        [ZHToastUtil showToast:kZHLocalizedString(@"请输入有效文件名")];
        return;
    }
    BOOL repeated = NO;
    if (model.isFolder) {
       repeated = [[SPLocalFileManager sharedManager] hasSameNameFolders:fileName folderPath:[[SPLocalFileManager sharedManager] getGlobalFilePath]];
    } else {
       repeated = [[SPLocalFileManager sharedManager] hasSameNameFile:fileName folderPath:[[SPLocalFileManager sharedManager] getGlobalFilePath]];
    }
     
    if (repeated) {
        [ZHToastUtil showToast:kZHLocalizedString(@"重名了，换一个名字吧~")];
        return;
    } else {
        NSInteger index = [self.filesArray indexOfObject:model];
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [[SPLocalFileManager sharedManager] reNameFoldersWithName:fileName folderPath:model.fullPath];
        NSString *targetName = [fileName stringByAppendingPathExtension:[model.fullPath pathExtension]];
        model.fullPath = [model.fullPath stringByReplacingOccurrencesOfString:model.name withString:targetName];

        model.name = targetName;
        [self.tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
