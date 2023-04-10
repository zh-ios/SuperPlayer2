//
//  SPJSONModelError.h
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

/////////////////////////////////////////////////////////////////////////////////////////////
typedef NS_ENUM(int, kSPSPJSONModelErrorTypes)
{
    kSPSPJSONModelErrorInvalidData = 1,
    kSPSPJSONModelErrorBadResponse = 2,
    kSPSPJSONModelErrorBadJSON = 3,
    kSPSPJSONModelErrorModelIsInvalid = 4,
    kSPSPJSONModelErrorNilInput = 5
};

/////////////////////////////////////////////////////////////////////////////////////////////
/** The domain name used for the SPJSONModelError instances */
extern NSString* const SPJSONModelErrorDomain;

/** 
 * If the model JSON input misses keys that are required, check the
 * userInfo dictionary of the SPJSONModelError instance you get back - 
 * under the kSPJSONModelMissingKeys key you will find a list of the
 * names of the missing keys.
 */
extern NSString* const kSPJSONModelMissingKeys;

/**
 * If JSON input has a different type than expected by the model, check the
 * userInfo dictionary of the SPJSONModelError instance you get back -
 * under the kSPJSONModelTypeMismatch key you will find a description
 * of the mismatched types.
 */
extern NSString* const kSPJSONModelTypeMismatch;

/**
 * If an error occurs in a nested model, check the userInfo dictionary of
 * the SPJSONModelError instance you get back - under the kSPJSONModelKeyPath
 * key you will find key-path at which the error occurred.
 */
extern NSString* const kSPJSONModelKeyPath;

/////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Custom NSError subclass with shortcut methods for creating 
 * the common SPJSONModel errors
 */
@interface SPJSONModelError : NSError

@property (strong, nonatomic) NSHTTPURLResponse* httpResponse;

@property (strong, nonatomic) NSData* responseData;

/**
 * Creates a SPJSONModelError instance with code kSPSPJSONModelErrorInvalidData = 1
 */
+(id)errorInvalidDataWithMessage:(NSString*)message;

/**
 * Creates a SPJSONModelError instance with code kSPSPJSONModelErrorInvalidData = 1
 * @param keys a set of field names that were required, but not found in the input
 */
+(id)errorInvalidDataWithMissingKeys:(NSSet*)keys;

/**
 * Creates a SPJSONModelError instance with code kSPSPJSONModelErrorInvalidData = 1
 * @param mismatchDescription description of the type mismatch that was encountered.
 */
+(id)errorInvalidDataWithTypeMismatch:(NSString*)mismatchDescription;

/**
 * Creates a SPJSONModelError instance with code kSPSPJSONModelErrorBadResponse = 2
 */
+(id)errorBadResponse;

/**
 * Creates a SPJSONModelError instance with code kSPSPJSONModelErrorBadJSON = 3
 */
+(id)errorBadJSON;

/**
 * Creates a SPJSONModelError instance with code kSPSPJSONModelErrorModelIsInvalid = 4
 */
+(id)errorModelIsInvalid;

/**
 * Creates a SPJSONModelError instance with code kSPSPJSONModelErrorNilInput = 5
 */
+(id)errorInputIsNil;

/**
 * Creates a new SPJSONModelError with the same values plus information about the key-path of the error.
 * Properties in the new error object are the same as those from the receiver,
 * except that a new key kSPJSONModelKeyPath is added to the userInfo dictionary.
 * This key contains the component string parameter. If the key is already present
 * then the new error object has the component string prepended to the existing value.
 */
- (instancetype)errorByPrependingKeyPathComponent:(NSString*)component;

/////////////////////////////////////////////////////////////////////////////////////////////
@end
