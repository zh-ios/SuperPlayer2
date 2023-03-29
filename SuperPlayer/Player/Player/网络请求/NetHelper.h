



#import <Foundation/Foundation.h>
#import "AFNetworking.h"


typedef NS_ENUM(NSUInteger, MiNetworkStatusType) {
    /** 未知网络*/
    MiNetworkStatusUnknown,
    /** 无网络*/
    MiNetworkStatusNotReachable,
    /** 手机网络*/
    MiNetworkStatusReachableViaWWAN,
    /** WIFI网络*/
    MiNetworkStatusReachableViaWiFi
};

typedef NS_ENUM(NSUInteger, ZZRequestSerializer) {
    /** 设置请求数据为JSON格式*/
    MiRequestSerializerJSON,
    /** 设置请求数据为二进制格式*/
    MiRequestSerializerHTTP,
};

typedef NS_ENUM(NSUInteger, ZZResponseSerializer) {
    /** 设置响应数据为JSON格式*/
    MiResponseSerializerJSON,
    /** 设置响应数据为二进制格式*/
    MiResponseSerializerHTTP,
};

typedef NS_ENUM(NSInteger, ZZNetErrorCode) {
    MiNetErrorTimedOut = -100001
};

/* 错误码 封装 */
@interface MiNetError : NSObject

@property (nonatomic,assign) BOOL isNotReachable;

@property (nonatomic,copy) NSString *msg;

@property (nonatomic,assign) NSInteger code;

@end

/** 请求成Block */

/**
 通用callBack
 
 @param success 接口是否请求成功
 @param responseObject 返回数据
 @param error 错误信息
 */
typedef void(^HttpRequestCallBack)(BOOL success,id responseObject,NSError *error);

/** 请求成功的Block */
typedef void(^MiHttpRequestSuccess)(id responseObject);

/** 请求失败的Block */
typedef void(^MiHttpRequestFailed)(MiNetError *error);

/** 缓存的Block */
typedef void(^MiHttpRequestCache)(id responseCache);


/** 网络状态的Block*/
typedef void(^MiNetworkStatus)(MiNetworkStatusType status);

@class AFHTTPSessionManager;
@interface NetHelper : NSObject

/**
 有网YES, 无网:NO
 */
+ (BOOL)isNetwork;

/**
 手机网络:YES, 反之:NO
 */
+ (BOOL)isWWANNetwork;

/**
 WiFi网络:YES, 反之:NO
 */
+ (BOOL)isWiFiNetwork;

/**
 取消所有HTTP请求
 */
+ (void)cancelAllRequest;

/**
 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
 */
+ (void)networkStatusWithBlock:(MiNetworkStatus)networkStatus;

/**
 取消指定URL的HTTP请求
 */
+ (void)cancelRequestWithURL:(NSString *)URL;

/**
 开启日志打印 (Debug级别)
 */
+ (void)openLog;

/**
 关闭日志打印,默认关闭
 */
+ (void)closeLog;

/*
 *  GET请求,无缓存
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(id)parameters
                           success:(MiHttpRequestSuccess)success
                           failure:(MiHttpRequestFailed)failure;

/**
 *  GET请求,自动缓存
 *
 *  @param URL           请求地址
 *  @param parameters    请求参数
 *  @param responseCache 缓存数据的回调
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(id)parameters
                     responseCache:(MiHttpRequestCache)responseCache
                           success:(MiHttpRequestSuccess)success
                           failure:(MiHttpRequestFailed)failure;

/**
 *  POST请求,无缓存
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id)parameters
                            success:(MiHttpRequestSuccess)success
                            failure:(MiHttpRequestFailed)failure;

/**
 *  POST请求,自动缓存
 *
 *  @param URL           请求地址
 *  @param parameters    请求参数
 *  @param responseCache 缓存数据的回调
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id)parameters
                      responseCache:(MiHttpRequestCache)responseCache
                            success:(MiHttpRequestSuccess)success
                            failure:(MiHttpRequestFailed)failure;


#pragma mark - 设置AFHTTPSessionManager相关属性
/**
 *  此方法获取AFHTTPSessionManager实例进行自定义设置
 *
 *  @param sessionManager AFHTTPSessionManager的实例
 */
+ (void)setAFHTTPSessionManagerProperty:(void(^)(AFHTTPSessionManager *sessionManager))sessionManager;

/**
 *  设置网络请求参数的格式:默认为二进制格式
 *
 *  @param requestSerializer PPRequestSerializerJSON(JSON格式),PPRequestSerializerHTTP(二进制格式),
 */
+ (void)setRequestSerializer:(ZZRequestSerializer)requestSerializer;

/**
 *  设置服务器响应数据格式:默认为JSON格式
 *
 *  @param responseSerializer PPResponseSerializerJSON(JSON格式),PPResponseSerializerHTTP(二进制格式)
 */
+ (void)setResponseSerializer:(ZZResponseSerializer)responseSerializer;

/**
 *  设置请求超时时间:默认为30S
 *
 *  @param time 时长
 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

/**
 *  设置请求头
 */
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/**
 *  是否打开网络状态转圈菊花:默认打开
 *
 *  @param open YES(打开), NO(关闭)
 */
+ (void)openNetworkActivityIndicator:(BOOL)open;

/**
 *  配置自建证书的Https请求
 *
 *  @param cerPath 自建Https证书的路径
 */
+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName;

// 是否使用了代理
+ (BOOL)getProxyStatus;
@end
