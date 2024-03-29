//
//  JSONAPI.m
//
//  @version 1.2
//  @author Marin Todorov (http://www.underplot.com) and contributors
//

// Copyright (c) 2012-2015 Marin Todorov, Underplot ltd.
// This code is distributed under the terms and conditions of the MIT license.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


#import "JSONAPI.h"

#pragma mark - helper error model class
@interface JSONAPIRPCErrorModel: SPJSONModel
@property (assign, nonatomic) int code;
@property (strong, nonatomic) NSString* message;
@property (strong, nonatomic) id<Optional> data;
@end

#pragma mark - static variables

static JSONAPI* sharedInstance = nil;
static long jsonRpcId = 0;

#pragma mark - JSONAPI() private interface

@interface JSONAPI ()
@property (strong, nonatomic) NSString* baseURLString;
@end

#pragma mark - JSONAPI implementation

@implementation JSONAPI

#pragma mark - initialize

+(void)initialize
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[JSONAPI alloc] init];
    });
}

#pragma mark - api config methods

+(void)setAPIBaseURLWithString:(NSString*)base
{
    sharedInstance.baseURLString = base;
}

+(void)setContentType:(NSString*)ctype
{
    [SPJSONHTTPClient setRequestContentType: ctype];
}

#pragma mark - GET methods
+(void)getWithPath:(NSString*)path andParams:(NSDictionary*)params completion:(JSONObjectBlock)completeBlock
{
    NSString* fullURL = [NSString stringWithFormat:@"%@%@", sharedInstance.baseURLString, path];
    
    [SPJSONHTTPClient getJSONFromURLWithString: fullURL params:params completion:^(NSDictionary *json, SPJSONModelError *e) {
        completeBlock(json, e);
    }];
}

#pragma mark - POST methods
+(void)postWithPath:(NSString*)path andParams:(NSDictionary*)params completion:(JSONObjectBlock)completeBlock
{
    NSString* fullURL = [NSString stringWithFormat:@"%@%@", sharedInstance.baseURLString, path];
    
    [SPJSONHTTPClient postJSONFromURLWithString: fullURL params:params completion:^(NSDictionary *json, SPJSONModelError *e) {
        completeBlock(json, e);
    }];
}

#pragma mark - RPC methods
+(void)__rpcRequestWithObject:(id)jsonObject completion:(JSONObjectBlock)completeBlock
{
    
    NSData* jsonRequestData = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                              options:kNilOptions
                                                                error:nil];
    NSString* jsonRequestString = [[NSString alloc] initWithData:jsonRequestData encoding: NSUTF8StringEncoding];

    NSAssert(sharedInstance.baseURLString, @"API base URL not set");
    [SPJSONHTTPClient postJSONFromURLWithString: sharedInstance.baseURLString
                                   bodyString: jsonRequestString
                                   completion:^(NSDictionary *json, SPJSONModelError* e) {

                                       if (completeBlock) {
                                           //handle the rpc response
                                           NSDictionary* result = json[@"result"];

                                           if (!result) {
                                               JSONAPIRPCErrorModel* error = [[JSONAPIRPCErrorModel alloc] initWithDictionary:json[@"error"] error:nil];
                                               if (error) {
                                                   //custom server error
                                                   if (!error.message) error.message = @"Generic json rpc error";
                                                   e = [SPJSONModelError errorWithDomain:SPJSONModelErrorDomain
                                                                                  code:error.code
                                                                              userInfo: @{ NSLocalizedDescriptionKey : error.message}];
                                               } else {
                                                   //generic error
                                                   e = [SPJSONModelError errorBadResponse];
                                               }
                                           }
                                           
                                           //invoke the callback
                                           completeBlock(result, e);
                                       }
                                   }];
}

+(void)rpcWithMethodName:(NSString*)method andArguments:(NSArray*)args completion:(JSONObjectBlock)completeBlock
{
    NSAssert(method, @"No method specified");
    if (!args) args = @[];
    
    [self __rpcRequestWithObject:@{
                                  //rpc 1.0
                                  @"id": @(++jsonRpcId),
                                  @"params": args,
                                  @"method": method
     } completion:completeBlock];
}

+(void)rpc2WithMethodName:(NSString*)method andParams:(id)params completion:(JSONObjectBlock)completeBlock
{
    NSAssert(method, @"No method specified");
    if (!params) params = @[];
    
    [self __rpcRequestWithObject:@{
                                  //rpc 2.0
                                  @"jsonrpc": @"2.0",
                                  @"id": @(++jsonRpcId),
                                  @"params": params,
                                  @"method": method
     } completion:completeBlock];
}

@end

#pragma mark - helper rpc error model class implementation
@implementation JSONAPIRPCErrorModel
@end
