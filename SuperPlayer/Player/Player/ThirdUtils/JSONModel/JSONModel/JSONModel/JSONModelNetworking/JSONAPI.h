//
//  JSONAPI.h
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


#import <Foundation/Foundation.h>
#import "SPJSONHTTPClient.h"

/////////////////////////////////////////////////////////////////////////////////////////////

/**
 * @discussion Class for working with JSON APIs. It builds upon the SPJSONHTTPClient class
 * and facilitates making requests to the same web host. Also features helper
 * method for making calls to a JSON RPC service
 */
@interface JSONAPI : NSObject

/////////////////////////////////////////////////////////////////////////////////////////////

/** @name Configuring the API */
/**
 * Sets the API url
 * @param base the API url as a string
 */
+(void)setAPIBaseURLWithString:(NSString*)base;

/**
 * Sets the default content type for the requests/responses
 * @param ctype The content-type as a string. Some possible types, 
 * depending on the service: application/json, text/json, x-application/javascript, etc.
 */
+(void)setContentType:(NSString*)ctype;

/////////////////////////////////////////////////////////////////////////////////////////////

/** @name Making GET API requests */
/**
 * Makes an asynchronous GET request to the API
 * @param path the URL path to add to the base API URL for this HTTP call
 * @param params the variables to pass to the API
 * @param completeBlock a JSONObjectBlock block to execute upon completion
 */
+(void)getWithPath:(NSString*)path andParams:(NSDictionary*)params completion:(JSONObjectBlock)completeBlock;

/////////////////////////////////////////////////////////////////////////////////////////////

/** @name Making POST API requests */
/**
 * Makes a POST request to the API
 * @param path the URL path to add to the base API URL for this HTTP call
 * @param params the variables to pass to the API
 * @param completeBlock a JSONObjectBlock block to execute upon completion
 */
+(void)postWithPath:(NSString*)path andParams:(NSDictionary*)params completion:(JSONObjectBlock)completeBlock;

/////////////////////////////////////////////////////////////////////////////////////////////

/** @name JSON RPC methods */
/**
 * Makes an asynchronous JSON RPC request to the API. Read more: http://www.jsonrpc.org
 * @param method the HTTP method name; GET or POST only
 * @param args the list of arguments to pass to the API
 * @param completeBlock JSONObjectBlock to execute upon completion
 */
+(void)rpcWithMethodName:(NSString*)method andArguments:(NSArray*)args completion:(JSONObjectBlock)completeBlock;

/** @name JSON RPC (2.0) request method */
/**
 * Makes an asynchronous JSON RPC 2.0 request to the API. Read more: http://www.jsonrpc.org
 * @param method the HTTP method name; GET or POST only
 * @param params the params to pass to the API - an NSArray or an NSDictionary, 
 * depending whether you're using named or unnamed parameters
 * @param completeBlock JSONObjectBlock to execute upon completion
 */
+(void)rpc2WithMethodName:(NSString*)method andParams:(id)params completion:(JSONObjectBlock)completeBlock;

/////////////////////////////////////////////////////////////////////////////////////////////

@end
