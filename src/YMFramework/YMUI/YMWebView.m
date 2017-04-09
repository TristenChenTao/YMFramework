//
//  YMWebView.m
//  YuMiAssistant
//
//  Created by Tristen-MacBook on 8/11/14.
//
//

#import "YMWebView.h"
#import "NSString+YMAdditions.h"
#import "YMHTTPManager.h"
#import "YMUI.h"


#import "MJRefresh.h"

#import "UIColor+YMAdditions.h"
#import "YMProgress.h"

@interface YMWebView() <WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, assign) BOOL hasRequestSuccess;

@end

@implementation YMWebView

#pragma mark - public methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        WKWebViewConfiguration * Configuration = [[WKWebViewConfiguration alloc]init];
        //允许视频播放
        Configuration.allowsAirPlayForMediaPlayback = YES;
        // 允许在线播放
        Configuration.allowsInlineMediaPlayback = YES;
        // 允许可以与网页交互，选择视图
        Configuration.selectionGranularity = YES;
        // 是否支持记忆读取
        Configuration.suppressesIncrementalRendering = YES;
        
        Configuration.dataDetectorTypes = WKDataDetectorTypeNone;

        
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;

        __unsafe_unretained YMWebView *webView = self;
        webView.navigationDelegate = self;
        
        // 添加下拉刷新控件
        [self addHeader];
        
    }
    return self;
}


- (void)loadRequest:(NSURLRequest *_Nullable)request needRefreshAnimation:(BOOL)animation
{
    self.orignalRequest = request;
    if (animation) {
        [self.scrollView.mj_header beginRefreshing];
    }
    else {
        [self loadRequest:request];
    }
}

- (void)reloadNeedRefreshAnimation:(BOOL)animation
{
    if (animation) {
        [self.scrollView.mj_header beginRefreshing];
    }
    else {
        [self loadRequest:self.orignalRequest];
    }
}

- (void)addHeader
{
    __unsafe_unretained YMWebView *webView = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (webView.ym_Delegate && [webView.ym_Delegate respondsToSelector:@selector(webViewShouldRefresh:)]) {
            [webView.ym_Delegate webViewShouldRefresh:webView];
        }
        [webView loadRequest:self.orignalRequest];
    }];
    header.backgroundColor = [UIColor clearColor];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置文字
    [header setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15.3];
    // 设置颜色
    header.stateLabel.textColor = [UIColor ym_colorWithHexString:@"8995b0"];
    
    self.scrollView.mj_header = header;
}

- (void)removeHeader
{
    self.scrollView.mj_header = nil;
}

#pragma mark - WKNavigationDelegate


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    if (_ym_Delegate && [_ym_Delegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
        [_ym_Delegate webView:webView didStartProvisionalNavigation:navigation];
    }
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [webView.scrollView.mj_header endRefreshing];
    
    self.hasRequestSuccess = YES;
    
    if (_ym_Delegate && [_ym_Delegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [_ym_Delegate webView:webView didFinishNavigation:navigation];
    }
}

/**
 *  加载失败时调用
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    [webView.scrollView.mj_header endRefreshing];
    
    
    if(error.code != -999){
        [YMProgress showFailStatus:@"数据加载失败"];
    }
    
    if (_ym_Delegate && [_ym_Delegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
        [_ym_Delegate webView:webView didFailProvisionalNavigation:navigation withError:error];
    }
}

/**
 *  在发送请求之前，决定是否跳转
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (_ym_Delegate && [_ym_Delegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:)]) {
        if ([_ym_Delegate webView:webView decidePolicyForNavigationAction:navigationAction] == false) {
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    return;
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(message.name);
}


@end
