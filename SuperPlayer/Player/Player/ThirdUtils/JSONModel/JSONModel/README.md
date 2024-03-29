## Magical Data Modelling Framework for JSON

### Version 1.2.0

#####NB: Swift works in a different way under the hood than Objective-C. Therefore I can't find a way to re-create SPJSONModel in Swift. SPJSONModel in Objective-C works in Swift apps through CocoaPods or as an imported Objective-C library.

---
If you like SPJSONModel and use it, could you please:

 * star this repo

 * send me some feedback. Thanks!

---

![SPJSONModel for iOS and OSX](http://SPJSONModel.com/img/SPJSONModel_logolike.png)

SPJSONModel is a library, which allows rapid creation of smart data models. You can use it in your iOS or OSX apps.

SPJSONModel automatically introspects your model classes and the structure of your JSON input and reduces drastically the amount of code you have to write.

[![](http://www.touch-code-magazine.com/img/json.png)](http://www.touch-code-magazine.com/img/json.png)


------------------------------------
Adding SPJSONModel to your project
====================================

#### Requirements

* ARC only; iOS 5.0+ / OSX 10.7+
* **SystemConfiguration.framework**

#### Get it as: 1) source files

1. Download the SPJSONModel repository as a [zip file](https://github.com/icanzilb/SPJSONModel/archive/master.zip) or clone it
2. Copy the SPJSONModel sub-folder into your Xcode project
3. Link your app to SystemConfiguration.framework

#### or 2) via Cocoa pods

In your project's **Podfile** add the SPJSONModel pod:

```ruby
pod 'SPJSONModel'
```
If you want to read more about CocoaPods, have a look at [this short tutorial](http://www.raywenderlich.com/12139/introduction-to-cocoapods).

#### or 3) via Carthage

In your project's **Cartfile** add the SPJSONModel:

```ruby
github "icanzilb/SPJSONModel"
```

#### Source code documentation
The source code includes class docs, which you can build yourself and import into Xcode:

1. If you don't already have [appledoc](http://gentlebytes.com/appledoc/) installed, install it with [homebrew](http://brew.sh/) by typing `brew install appledoc`.
2. Install the documentation into Xcode by typing `appledoc .` in the root directory of the repository.
3. Restart Xcode if it's already running.

------------------------------------
Basic usage
====================================

Consider you have a JSON like this:
```javascript
{"id":"10", "country":"Germany", "dialCode": 49, "isInEurope":true}
```

 * Create a new Objective-C class for your data model and make it inherit the SPJSONModel class.
 * Declare properties in your header file with the name of the JSON keys:

```objective-c
#import "SPJSONModel.h"

@interface CountryModel : SPJSONModel

@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString* country;
@property (strong, nonatomic) NSString* dialCode;
@property (assign, nonatomic) BOOL isInEurope;

@end
```
There's no need to do anything in the **.m** file.

 * Initialize your model with data:

```objective-c
#import "CountryModel.h"
...

NSString* json = (fetch here JSON from Internet) ...
NSError* err = nil;
CountryModel* country = [[CountryModel alloc] initWithString:json error:&err];

```

If the validation of the JSON passes you have all the corresponding properties in your model populated from the JSON. SPJSONModel will also try to convert as much data to the types you expect, in the example above it will:

* convert "id" from string (in the JSON) to an int for your class
* just copy country's value
* convert dialCode from number (in the JSON) to an NSString value
* finally convert isInEurope to a BOOL for your BOOL property

And the good news is all you had to do is define the properties and their expected types.

-------
#### Online tutorials


Official website: [http://www.SPJSONModel.com](http://www.SPJSONModel.com)

Class docs online: [http://SPJSONModel.com/docs/](http://SPJSONModel.com/docs/)

Step-by-step tutorials:

 * [How to fetch and parse JSON by using data models](http://www.touch-code-magazine.com/how-to-fetch-and-parse-json-by-using-data-models/)

 * [Performance optimisation for working with JSON feeds via SPJSONModel](http://www.touch-code-magazine.com/performance-optimisation-for-working-with-json-feeds-via-SPJSONModel/)

 * [How to make a YouTube app using MGBox and SPJSONModel](http://www.touch-code-magazine.com/how-to-make-a-youtube-app-using-mgbox-and-SPJSONModel/)

-------
Examples
=======

#### Automatic name based mapping
<table>
<tr>
<td valign="top">
<pre>
{
  "id": "123",
  "name": "Product name",
  "price": 12.95
}
</pre>
</td>
<td>
<pre>
@interface ProductModel : SPJSONModel
@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) float price;
@end

@implementation ProductModel
@end
</pre>
</td>
</tr>
</table>

#### Model cascading (models including other models)
<table>
<tr>
<td valign="top">
<pre>
{
  "order_id": 104,
  "total_price": 13.45,
  "product" : {
    "id": "123",
    "name": "Product name",
    "price": 12.95
  }
}
</pre>
</td>
<td valign="top">
<pre>
@interface OrderModel : SPJSONModel
@property (assign, nonatomic) int order_id;
@property (assign, nonatomic) float total_price;
@property (strong, nonatomic) <b>ProductModel*</b> product;
@end

@implementation OrderModel
@end
</pre>
</td>
</tr>
</table>

#### Model collections
<table>
<tr>
<td valign="top">
<pre>
{
  "order_id": 104,
  "total_price": 103.45,
  "products" : [
    {
      "id": "123",
      "name": "Product #1",
      "price": 12.95
    },
    {
      "id": "137",
      "name": "Product #2",
      "price": 82.95
    }
  ]
}
</pre>
</td>
<td valign="top">
<pre>
<b>@protocol ProductModel
@end</b>

@interface ProductModel : SPJSONModel
@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) float price;
@end

@implementation ProductModel
@end

@interface OrderModel : SPJSONModel
@property (assign, nonatomic) int order_id;
@property (assign, nonatomic) float total_price;
@property (strong, nonatomic) <b>NSArray&lt;ProductModel&gt;*</b> products;
@end

@implementation OrderModel
@end
</pre>
</td>
</tr>
</table>

#### Key mapping
<table>
<tr>
<td valign="top">
<pre>
{
  "order_id": 104,
  "order_details" : [
    {
      "name": "Product#1",
      "price": {
        "usd": 12.95
      }
    }
  ]
}
</pre>
</td>
<td valign="top">
<pre>
@interface OrderModel : SPJSONModel
@property (assign, nonatomic) int id;
@property (assign, nonatomic) float price;
@property (strong, nonatomic) NSString* productName;
@end

@implementation OrderModel

+(JSONKeyMapper*)keyMapper
{
  return [[JSONKeyMapper alloc] initWithDictionary:@{
  <b>  @"order_id": @"id",
    @"order_details.name": @"productName",
    @"order_details.price.usd": @"price"</b>
  }];
}

@end
</pre>
</td>
</tr>
</table>

#### Global key mapping (applies to all models in your app)
<table>
<tr>
<td valign="top">
<pre>
<b>[SPJSONModel setGlobalKeyMapper:[</b>
    [JSONKeyMapper alloc] initWithDictionary:@{
      @"item_id":@"ID",
      @"item.name": @"itemName"
   }]
<b>];</b>

</pre>
</td>
</tr>
</table>

#### Map automatically under_score case to camelCase
<table>
<tr>
<td valign="top">
<pre>
{
  "order_id": 104,
  "order_product" : @"Product#1",
  "order_price" : 12.95
}
</pre>
</td>
<td valign="top">
<pre>
@interface OrderModel : SPJSONModel

@property (assign, nonatomic) int orderId;
@property (assign, nonatomic) float orderPrice;
@property (strong, nonatomic) NSString* orderProduct;

@end

@implementation OrderModel

+(JSONKeyMapper*)keyMapper
{
  return <b>[JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];</b>
}

@end
</pre>
</td>
</tr>
</table>

#### Optional properties (i.e. can be missing or null)
<table>
<tr>
<td valign="top">
<pre>
{
  "id": "123",
  "name": null,
  "price": 12.95
}
</pre>
</td>
<td>
<pre>
@interface ProductModel : SPJSONModel
@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString<b>&lt;Optional&gt;</b>* name;
@property (assign, nonatomic) float price;
@property (strong, nonatomic) NSNumber<b>&lt;Optional&gt;</b>* uuid;
@end

@implementation ProductModel
@end
</pre>
</td>
</tr>
</table>

#### Ignored properties (i.e. SPJSONModel completely ignores them)
<table>
<tr>
<td valign="top">
<pre>
{
  "id": "123",
  "name": null
}
</pre>
</td>
<td>
<pre>
@interface ProductModel : SPJSONModel
@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString<b>&lt;Ignore&gt;</b>* customProperty;
@end

@implementation ProductModel
@end
</pre>
</td>
</tr>
</table>


#### Make all model properties optional (avoid if possible)
<table>
<tr>
<td valign="top">
<pre>
@implementation ProductModel
<b>+(BOOL)propertyIsOptional:(NSString*)propertyName
{
  return YES;
}</b>
@end
</pre>
</td>
</tr>
</table>


#### Lazy convert collection items from dictionaries to models
<table>
<tr>
<td valign="top">
<pre>
{
  "order_id": 104,
  "total_price": 103.45,
  "products" : [
    {
      "id": "123",
      "name": "Product #1",
      "price": 12.95
    },
    {
      "id": "137",
      "name": "Product #2",
      "price": 82.95
    }
  ]
}
</pre>
</td>
<td valign="top">
<pre>
@protocol ProductModel
@end

@interface ProductModel : SPJSONModel
@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) float price;
@end

@implementation ProductModel
@end

@interface OrderModel : SPJSONModel
@property (assign, nonatomic) int order_id;
@property (assign, nonatomic) float total_price;
@property (strong, nonatomic) NSArray&lt;ProductModel, <b>ConvertOnDemand</b>&gt;* products;
@end

@implementation OrderModel
@end
</pre>
</td>
</tr>
</table>

#### Using the built-in thin HTTP client

```objective-c

//add extra headers
[[SPJSONHTTPClient requestHeaders] setValue:@"MySecret" forKey:@"AuthorizationToken"];

//make post, get requests
[SPJSONHTTPClient postJSONFromURLWithString:@"http://mydomain.com/api"
                                   params:@{@"postParam1":@"value1"}
                               completion:^(id json, SPJSONModelError *err) {

                                   //check err, process json ...

                               }];
```

#### Export model to NSDictionary or to JSON text

```objective-c

ProductModel* pm = [[ProductModel alloc] initWithString:jsonString error:nil];
pm.name = @"Changed Name";

//convert to dictionary
NSDictionary* dict = [pm toDictionary];

//convert to text
NSString* string = [pm toJSONString];

```

#### Custom data transformers

```objective-c

@implementation JSONValueTransformer (CustomTransformer)

- (NSDate *)NSDateFromNSString:(NSString*)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:APIDateFormat];
    return [formatter dateFromString:string];
}

- (NSString *)JSONObjectFromNSDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:APIDateFormat];
    return [formatter stringFromDate:date];
}

@end

```

#### Custom handling for specific properties

```objective-c

@interface ProductModel : SPJSONModel
@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) float price;
@property (strong, nonatomic) NSLocale *locale;
@end

@implementation ProductModel

// Convert and assign the locale property
- (void)setLocaleWithNSString:(NSString*)string {
    self.locale = [NSLocale localeWithLocaleIdentifier:string];
}

- (NSString *)JSONObjectForLocale {
    return self.locale.localeIdentifier;
}

@end

```

* json validation
* error handling
* custom data validation
* automatic compare and equality features
* and more.

-------

Misc
=======

Author: [Marin Todorov](http://www.touch-code-magazine.com)

Contributors: Christian Hoffmann, Mark Joslin, Julien Vignali, Symvaro GmbH, BB9z.
Also everyone who did successful [pull requests](https://github.com/icanzilb/SPJSONModel/graphs/contributors).

Change log : [https://github.com/icanzilb/SPJSONModel/blob/master/Changelog.md](https://github.com/icanzilb/SPJSONModel/blob/master/Changelog.md)

-------
#### License
This code is distributed under the terms and conditions of the MIT license.

-------
#### Contribution guidelines

**NB!** If you are fixing a bug you discovered, please add also a unit test so I know how exactly to reproduce the bug before merging.

