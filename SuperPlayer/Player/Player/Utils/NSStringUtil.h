//
//  NSStringUtil.h
//  ZHProject
//
//  Created by zhxxxx  ondfasd 2019/6/21.
//  Copyright © 2023 zhssssx. 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSStringUtil : NSObject

+ (NSString *)jsonStrigFromObject:(id)obj;


+ (NSString *)trimingString:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
