//
//  BTActionSheetView.h
//  BanTang
//
//  Created by liaoyp on 15/5/21.
//  Copyright (c) 2015年 JiuZhouYunDong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SPActionSheetItemStyle) {
    SPActionSheetItemStyle_Default      = 0,
    SPActionSheetItemStyle_Disabled     = 1,
    SPActionSheetItemStyle_Title        = 2,
    SPActionSheetItemStyle_Custom       = 3,
};

@interface SPActionSheetItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *titleColor; // style is SPActionSheetItemStyle_Custom available;
@property (nonatomic, assign) SPActionSheetItemStyle style;

+ (instancetype)makeSPActionSheetItemWithTitle:(NSString *)title;
+ (instancetype)makeSPActionSheetItemWithTitle:(NSString *)title style:(SPActionSheetItemStyle)style;

@end

@class SPActionSheet;
typedef void (^SPActionSheetSelectHandler)(SPActionSheet *actionSheet, NSString* key, NSInteger index);

@interface SPActionSheet : UIView<UITableViewDataSource, UITableViewDelegate>

//旋转后再次显示
- (void)show;
- (void)hide;
- (void)hideWithCompletionBlock:(dispatch_block_t)completed;
- (void)hideWithoutAnimation;
/**
 *  数据源
 */
@property(nonatomic, strong) NSArray<SPActionSheetItem *> *dataSource;

/**
 *  actionSheet 点击回调
 */
@property(nonatomic, copy) SPActionSheetSelectHandler selectRowBlock;
/**
 * cancelItemName (key)
 */
@property(nonatomic, copy) NSString *cancelItemName;

@end
