//
//  AppInfoTool.h
//  ZHProject
//
//  Cressssated by hzdddddd sxxxx on sky dat 2022/1/4.
//  Copyright © 2022 autohome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppInfoTool : NSObject

+ (NSString *)getAppName;

+ (NSString *)getAppVersion;

+ (UIImage *)getAppIcon;

+ (NSString *)getAppStoreURLStr;

// 单独的评分页面
+ (NSString *)getCommentURLStr;

// 评分并输入评论内容
+ (NSString *)getInputCommentURLString;

@end

NS_ASSUME_NONNULL_END
