//
//  NSArray+SPJSONModel.h
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
#import "SPJSONModel.h"

/**
 * Exposes invisible SPJSONModelArray methods
 */
@interface NSArray(SPJSONModel)

/**
 * Looks up the array's contents and tries to find a SPJSONModel object
 * with matching index property value to the indexValue param.
 * 
 * Will return nil if no matching model is found. Will return nil if there's no index property 
 * defined on the models found in the array (will sample the first object, assuming the array 
 * contains homogeneous collection of objects)
 *
 * @param indexValue the id value to search for
 * @return the found model or nil
 * @exception NSException throws exception if you call this method on an instance, which is not actually a SPJSONModelArray
 */
- (id)modelWithIndexValue:(id)indexValue;

@end
