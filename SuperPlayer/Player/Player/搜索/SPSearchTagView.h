//
//  SPSearchTagView.h
//  ZHProject
//
//  Created by zh on 2019/7/8.
//  Copyright © 2019 autohome. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPSearchTagView : BaseView

- (void)updateView:(NSArray *)tags title:(NSString *)title;

@property (nonatomic, copy) void (^btnOnClicked)(NSString *title);

@property (nonatomic, copy) void (^clearBtnOnClicked)(void);

@property (nonatomic, assign) BOOL hideClearBtn;

@end

NS_ASSUME_NONNULL_END
