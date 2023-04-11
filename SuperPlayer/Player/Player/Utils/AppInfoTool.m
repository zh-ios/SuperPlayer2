//
//  AppInfoTool.m
//  ZHProject
//
//  Cressssated by hzdddddd sxxxx on sky dat 2022/1/4.
//  Copyright © 2022 autohome. All rights reserved.
//

#import "AppInfoTool.h"

@implementation AppInfoTool

+ (NSString *)getAppName {
    NSDictionary  *infoDictionary = [[NSBundle mainBundle] infoDictionary];//获取app相关信息
    NSString *aName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return aName;
}

+ (NSString *)getAppVersion {
    NSDictionary  *infoDictionary = [[NSBundle mainBundle] infoDictionary];//获取app相关信息
    NSString *aVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return aVersion;
}

+ (UIImage *)getAppIcon {
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
       
   //获取app中所有icon名字数组
   NSArray *iconsArr = infoDict[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
   //取最后一个icon的名字
   NSString *iconLastName = [iconsArr lastObject];
   
   //打印icon名字
   NSLog(@"iconsArr: %@", iconsArr);
   NSLog(@"iconLastName: %@", iconLastName);
   /*
    打印日志：
    iconsArr: (
        AppIcon29x29,
        AppIcon40x40,
        AppIcon60x60
    )
    iconLastName: AppIcon60x60
    */
    return [UIImage imageNamed:iconLastName];
}

+ (NSString *)getAppStoreURLStr {
    NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@", @(1598269158)];
    return str;
}

+ (NSString *)getCommentURLStr {
    
    // 跳转到写好评评分页面
//    NSString *appID = @"1598269158";
//       NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", appID];
//    return str;
    
    // 跳转到评分reviews页面
    NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",1598269158];
    return str;
}

+ (NSString *)getInputCommentURLString {
    NSString *appID = @"1598269158";
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", appID];
    return str;
}

@end
