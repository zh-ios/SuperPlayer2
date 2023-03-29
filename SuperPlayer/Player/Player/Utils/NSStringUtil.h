//
//  NSStringUtil.h
//  ZHProject
//
//  Created by zh on 2019/6/21.
//  Copyright © 2019 autohome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSStringUtil : NSObject

+ (NSString *)jsonStrigFromObject:(id)obj;


+ (NSString *)trimingString:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
