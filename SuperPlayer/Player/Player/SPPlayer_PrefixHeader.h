//
//  ZHProject_PrefixHeader.h
//  ZHProject
//
//  Created by zhxxxx  ondfasd 2018/5/30.
//  Copyright © 2018年 autohome. All rights reserved.
//

#ifndef ZHProject_PrefixHeader_h
#define ZHProject_PrefixHeader_h

// @import引入动态库，使用里面的类的时候也不需要导入。

//@import CommonFunction;
//@import YYCache;
//@import AFNetworking;


// 或者使用下面这种引入方式
//#import <CommonFunction/CommonFunction.h>

#import <Availability.h>

#import "SPPlayerDefine.h"



#ifndef NDEBUG
#define APLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define APLog(format, ...)
#endif

#define MEDIA_PLAYBACK_DEBUG 0
#define MEDIA_DISCOVERY_DEBUG 0
#define MEDIA_DOWNLOAD_DEBUG 0
#define WIFI_SHARING_DEBUG 0


#import "ZFPlayer.h"
#import "SPGlobalConfigManager.h"

#import "ProjectCommonDefine.h"
#import "ProjectCommonHeaders.h"

#ifndef NDEBUG
#define APLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define APLog(format, ...)
#endif

#define MEDIA_PLAYBACK_DEBUG 0
#define MEDIA_DISCOVERY_DEBUG 0
#define MEDIA_DOWNLOAD_DEBUG 0
#define WIFI_SHARING_DEBUG 0

//@import ZHNetwork;

#endif /* ZHProject_PrefixHeader_h */
