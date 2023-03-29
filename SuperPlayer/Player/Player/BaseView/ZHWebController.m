
//  ZHPoetryWebController.m
//  ZHProject
//
//  Created by zh on 2019/6/28.
//  Copyright © 2019 autohome. All rights reserved.
//

#import "ZHWebController.h"
#import <WebKit/WebKit.h>

@interface ZHWebController () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) WKWebViewConfiguration *wkConfig;
@property (nonatomic, strong) UIProgressView *progressView;

@end




@implementation ZHWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = self.naviTitle;
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kNavbarHeight,self.view.width, 2)];
    self.progressView.trackTintColor = [UIColor colorWithHexString:@"e5e5e5" alpha:1];
    self.progressView.progressTintColor = kTextHighlightColor;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self startLoad];
}



- (WKWebViewConfiguration *)wkConfig {
    if (!_wkConfig) {
        _wkConfig = [[WKWebViewConfiguration alloc] init];
        _wkConfig.allowsInlineMediaPlayback = YES;
        if (@available(iOS 9.0 , *)) {
            _wkConfig.allowsPictureInPictureMediaPlayback = YES;
        }
    }
    return _wkConfig;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0,kNavbarHeight, self.view.width, self.view.height-kNavbarHeight-kBottomSafeArea) configuration:self.wkConfig];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        [self.view addSubview:_wkWebView];
    }
    return _wkWebView;
}

- (void)startLoad {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    request.timeoutInterval = 15.0f;
    [self.wkWebView loadRequest:request];
}

#pragma mark - 监听

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.wkWebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            @weakify(self)
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                @strongify(self);
                self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                @strongify(self);
                self.progressView.hidden = YES;
                
            }];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        if (self.naviTitle.length == 0) {
            self.title = self.wkWebView.title;
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKWKNavigationDelegate Methods

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

/*
 *5.在WKWebViewd的代理中展示进度条，加载完成后隐藏进度条
 */

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(kZHLocalizedString(@"开始加载网页"));
    self.progressView.hidden = NO;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view bringSubviewToFront:self.progressView];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(kZHLocalizedString(@"加载完成"));
    self.progressView.hidden = YES;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(kZHLocalizedString(@"加载失败"));
    self.progressView.hidden = YES;
}

//页面跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {


//    NSURL *URL = navigationAction.request.URL;
//      NSString *scheme = [URL scheme];
//      if ([scheme isEqualToString:@"tel"]) {
//          NSString *resourceSpecifier = [URL resourceSpecifier];
//          NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
//          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
//      }
//       //判断是否开启新界面
//      if (navigationAction.targetFrame == nil) {
//          //手动跳转至新界面加载url
////          [self gotoWebPage:URL.absoluteString];
//          decisionHandler(WKNavigationActionPolicyAllow);
//      }else{
//          if ([URL.absoluteString containsString:@"http"]) {
//              //注意，这里要取消action，否则会在原界面加载url
//              decisionHandler(WKNavigationActionPolicyCancel);
//              //手动跳转至新界面加载url
////              [self gotoWebPage:URL.absoluteString];
//          }
//      }
//
//      decisionHandler(WKNavigationActionPolicyAllow);
//
    NSString *requestURL = [[navigationAction.request URL] absoluteString];
    //防止跳转页面
    NSLog(@"********%@",requestURL);
    if (![requestURL hasPrefix:@"http://"]&&![requestURL hasPrefix:@"https://"]){
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{

    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}

// 在发送请求之前，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//
//    NSLog(@"%@",navigationAction.request.URL.absoluteString);
//    //允许跳转
//    decisionHandler(WKNavigationActionPolicyAllow);
//    //不允许跳转
//    //decisionHandler(WKNavigationActionPolicyCancel);
//}


#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
}


- (void)dealloc {
    //    [self.wkConfig.userContentController removeScriptMessageHandlerForName:ShareActionName];
    //    [self.wkConfig.userContentController removeScriptMessageHandlerForName:AlbumDetailName];
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
    self.wkWebView.navigationDelegate = nil;
    self.wkWebView.UIDelegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

