//
//  NSStringUtil.m
//  ZHProject
//
//  Created by zh on 2019/6/21.
//  Copyright © 2019 autohome. All rights reserved.
//

#import "NSStringUtil.h"

@implementation NSStringUtil

+ (NSString *)jsonStrigFromObject:(id)obj {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


+ (NSString *)trimingString:(NSString *)str {
    if (!str) return nil;
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
