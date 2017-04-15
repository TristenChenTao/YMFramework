//
//  YMWebView.m
//  YuMiAssistant
//
//  Created by Tristen-MacBook on 8/11/14.
//
//

#import "YMWebView.h"
#import "NSString+YMAdditions.h"
#import "YMUI.h"


#import "MJRefresh.h"

#import "YMProgress.h"

@interface YMWebView() <UIWebViewDelegate>

@property (nonatomic, assign) BOOL hasRequestSuccess;

@end

@implementation YMWebView

#pragma mark - public methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.allowsInlineMediaPlayback = YES;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.dataDetectorTypes = UIDataDetectorTypeNone;
        
        __unsafe_unretained YMWebView *webView = self;
        webView.delegate = self;
        
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
    header.stateLabel.textColor = [UIColor colorWithRed:0.54 green:0.58 blue:0.69 alpha:1.00];
    
    self.scrollView.mj_header = header;
}

- (void)removeHeader
{
    self.scrollView.mj_header = nil;
}

#pragma mark - WKNavigationDelegate


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (_ym_Delegate && [_ym_Delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_ym_Delegate webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView.scrollView.mj_header endRefreshing];
    
    self.hasRequestSuccess = YES;
    
    if (_ym_Delegate && [_ym_Delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_ym_Delegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [webView.scrollView.mj_header endRefreshing];
    
    
    if(error.code != -999){
        [YMProgress showFailStatus:@"数据加载失败"];
    }
    
    if (_ym_Delegate && [_ym_Delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_ym_Delegate webView:webView
         didFailLoadWithError:error];
    }
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    
    BOOL bLoadRequest = YES; //等于YES表示还是没有经过处理
    
    if (_ym_Delegate && [_ym_Delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return bLoadRequest = [_ym_Delegate webView:self
                  shouldStartLoadWithRequest:request
                              navigationType:navigationType];
    }
    
    return YES;
}

@end
