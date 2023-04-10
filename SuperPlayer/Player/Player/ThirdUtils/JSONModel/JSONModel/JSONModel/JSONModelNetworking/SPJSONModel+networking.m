//
//  SPJSONModel+networking.m
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


#import "SPJSONModel+networking.h"
#import "SPJSONHTTPClient.h"

BOOL _isLoading;

@implementation SPJSONModel(Networking)

@dynamic isLoading;

-(BOOL)isLoading
{
    return _isLoading;
}

-(void)setIsLoading:(BOOL)isLoading
{
    _isLoading = isLoading;
}

-(instancetype)initFromURLWithString:(NSString *)urlString completion:(SPJSONModelBlock)completeBlock
{
    id placeholder = [super init];
    __block id blockSelf = self;
    
    if (placeholder) {
        //initialization
        self.isLoading = YES;
        
        [SPJSONHTTPClient getJSONFromURLWithString:urlString
                                      completion:^(NSDictionary *json, SPJSONModelError* e) {
                                          
                                          SPJSONModelError* initError = nil;
                                          blockSelf = [self initWithDictionary:json error:&initError];
                                          
                                          if (completeBlock) {
                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
                                                  completeBlock(blockSelf, e?e:initError );
                                              });
                                          }
                                          
                                          self.isLoading = NO;
                                          
                                      }];
    }
    return placeholder;
}

+ (void)getModelFromURLWithString:(NSString*)urlString completion:(SPJSONModelBlock)completeBlock
{
	[SPJSONHTTPClient getJSONFromURLWithString:urlString
								  completion:^(NSDictionary* jsonDict, SPJSONModelError* err)
	{
		SPJSONModel* model = nil;

		if(err == nil)
		{
			model = [[self alloc] initWithDictionary:jsonDict error:&err];
		}

		if(completeBlock != nil)
		{
			dispatch_async(dispatch_get_main_queue(), ^
			{
				completeBlock(model, err);
			});
		}
    }];
}

+ (void)postModel:(SPJSONModel*)post toURLWithString:(NSString*)urlString completion:(SPJSONModelBlock)completeBlock
{
	[SPJSONHTTPClient postJSONFromURLWithString:urlString
								   bodyString:[post toJSONString]
								   completion:^(NSDictionary* jsonDict, SPJSONModelError* err)
	{
		SPJSONModel* model = nil;

		if(err == nil)
		{
			model = [[self alloc] initWithDictionary:jsonDict error:&err];
		}

		if(completeBlock != nil)
		{
			dispatch_async(dispatch_get_main_queue(), ^
			{
				completeBlock(model, err);
			});
		}
	}];
}

@end
