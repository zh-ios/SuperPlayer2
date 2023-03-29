

#import "NetHelper.h"
#import "NetCache.h"
#import "AFNetworkReachabilityManager.h"
@implementation MiNetError

- (NSString *)description
{
    return [NSString stringWithFormat:@"isNotReachable:%@\nmsg:%@\ncode:%@\n",@(self.isNotReachable),self.msg,@(self.code)];
}

@end

@implementation NetHelper

static BOOL _isOpenLog = YES;   // 是否已开启日志打印
static BOOL _isOpenAES;   // 是否已开启加密传输
static NSMutableArray *_allSessionTask;
static AFHTTPSessionManager *_sessionManager;

#pragma mark - 开始监听网络
+ (void)networkStatusWithBlock:(MiNetworkStatus)networkStatus {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    networkStatus ? networkStatus(MiNetworkStatusUnknown) : nil;
                    if (_isOpenLog) NSLog(kZHLocalizedString(@"未知网络"));
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    networkStatus ? networkStatus(MiNetworkStatusNotReachable) : nil;
                    if (_isOpenLog) NSLog(kZHLocalizedString(@"无网络"));
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    networkStatus ? networkStatus(MiNetworkStatusReachableViaWWAN) : nil;
                    if (_isOpenLog) NSLog(kZHLocalizedString(@"手机自带网络"));
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    networkStatus ? networkStatus(MiNetworkStatusReachableViaWiFi) : nil;
                    if (_isOpenLog) NSLog(@"WIFI");
                    break;
            }
        }];
    });
}

+ (BOOL)isNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isWWANNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isWiFiNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

+ (void)openLog {
    _isOpenLog = YES;
}

+ (void)closeLog {
    _isOpenLog = NO;
}
#pragma mark - ——————— 开关加密 ————————


+ (void)cancelAllRequest {
    // 锁操作
    @synchronized(self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)URL {
    if (!URL) { return; }
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

#pragma mark - GET请求无缓存
+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(id)parameters
                  success:(MiHttpRequestSuccess)success
                  failure:(MiHttpRequestFailed)failure {
    return [self GET:URL parameters:parameters responseCache:nil success:success failure:failure];
}

#pragma mark - POST请求无缓存
+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(id)parameters
                   success:(MiHttpRequestSuccess)success
                   failure:(MiHttpRequestFailed)failure {
    return [self POST:URL parameters:parameters responseCache:nil success:success failure:failure];
}

#pragma mark - GET请求自动缓存
+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(id)parameters
            responseCache:(MiHttpRequestCache)responseCache
                  success:(MiHttpRequestSuccess)success
                  failure:(MiHttpRequestFailed)failure {
    
    if ([self getProxyStatus]) {
        return nil;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if (parameters) {
        [dic addEntriesFromDictionary:parameters];
    }
    //读取缓存
    responseCache!=nil ? responseCache([NetCache httpCacheForURL:URL parameters:dic]) : nil;

    
    NSURLSessionTask *sessionTask = [_sessionManager GET:URL parameters:dic headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (_isOpenLog) {NSLog(@"responseObject = %@",[self jsonToString:responseObject]);}
            [[self allSessionTask] removeObject:task];
           
            [self handelSuccess:success failure:failure withResponse:responseObject];
            //对数据进行异步缓存
            responseCache!=nil ? [NetCache setHttpCache:responseObject URL:URL parameters:parameters] : nil;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (_isOpenLog) {NSLog(@"error = %@",error);}
            [[self allSessionTask] removeObject:task];
            failure ? failure([self getErrorMsgInfoWithError:error]) : nil;
        }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark - POST请求自动缓存
+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(id)parameters
             responseCache:(MiHttpRequestCache)responseCache
                   success:(MiHttpRequestSuccess)success
                   failure:(MiHttpRequestFailed)failure {
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if (parameters) {
        [dic addEntriesFromDictionary:parameters];
    }
    
    //读取缓存
    responseCache!=nil ? responseCache([NetCache httpCacheForURL:URL parameters:dic]) : nil;

    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:dic headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (_isOpenLog) {NSLog(@"responseObject = %@",[self jsonToString:responseObject]);}
        [[self allSessionTask] removeObject:task];
        [self handelSuccess:success failure:failure withResponse:responseObject];
        //对数据进行异步缓存
        responseCache!=nil ? [NetCache setHttpCache:responseObject URL:URL parameters:parameters] : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (_isOpenLog) {NSLog(@"error = %@",error);}
        [[self allSessionTask] removeObject:task];
        failure ? failure([self getErrorMsgInfoWithError:error]) : nil;
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}

/**
 *  json转字符串
 */
+ (NSString *)jsonToString:(id)data {
    if(data == nil) { return nil; }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

#pragma mark - 初始化AFHTTPSessionManager相关属性
/**
 开始监测网络状态
 */
+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)initialize {
    _sessionManager = [AFHTTPSessionManager manager];
    // 设置请求的超时时间
    _sessionManager.requestSerializer.timeoutInterval = 30.f;
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*",@"text/encode", nil];
}

#pragma mark - 重置AFHTTPSessionManager相关属性

+ (void)setAFHTTPSessionManagerProperty:(void (^)(AFHTTPSessionManager *))sessionManager {
    sessionManager ? sessionManager(_sessionManager) : nil;
}

+ (void)setRequestSerializer:(ZZRequestSerializer)requestSerializer {
    _sessionManager.requestSerializer = requestSerializer==MiRequestSerializerHTTP ? [AFHTTPRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
}

+ (void)setResponseSerializer:(ZZResponseSerializer)responseSerializer {
    _sessionManager.responseSerializer = responseSerializer==MiResponseSerializerHTTP ? [AFHTTPResponseSerializer serializer] : [AFJSONResponseSerializer serializer];
}

+ (void)setRequestTimeoutInterval:(NSTimeInterval)time {
    _sessionManager.requestSerializer.timeoutInterval = time;
}

+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}

+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName {
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    // 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 如果需要验证自建证书(无效证书)，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    // 是否需要验证域名，默认为YES;
    securityPolicy.validatesDomainName = validatesDomainName;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    
    [_sessionManager setSecurityPolicy:securityPolicy];
}
#pragma mark -- net block handle

//处理网络请求回调
+ (void)handelSuccess:(MiHttpRequestSuccess)success failure:(MiHttpRequestFailed)failure withResponse:(id)responseObject {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (success) {
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        NSString *desc = [responseObject objectForKey:@"msg"];
        if (code == 0) {
            success(responseObject);
        }else{
            MiNetError *errorInfo = [MiNetError new];
            errorInfo.isNotReachable = NO;
            errorInfo.code = code;
            errorInfo.msg = desc;
            failure(errorInfo);
        }
    }
}


+ (MiNetError *)getErrorMsgInfo {
    return [self getErrorMsgInfoWithError:nil];
}

+ (MiNetError *)getErrorMsgInfoWithError:(NSError *)aError {
    MiNetError *error = [MiNetError new];
    error.isNotReachable = ![self isNetwork];
    if (error.isNotReachable) {
        error.msg = kZHLocalizedString(@"网络不给力");
    }else{
        error.msg = kZHLocalizedString(@"服务器错误");
    }
    if ([aError.domain isEqualToString:NSURLErrorDomain]) {
        if (NSURLErrorTimedOut == aError.code) {
            error.code = MiNetErrorTimedOut;
        }
    }
    return error;
}

+ (BOOL)getProxyStatus {
    NSDictionary *proxySettings =  (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSDictionary *settings = [proxies objectAtIndex:0];
    
    NSLog(@"host=%@", [settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    NSLog(@"port=%@", [settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    NSLog(@"type=%@", [settings objectForKey:(NSString *)kCFProxyTypeKey]);
    
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
        //没有设置代理
        return NO;
    }else{
        //设置代理了
        return YES;
    }
}

@end
