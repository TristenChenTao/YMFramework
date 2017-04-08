//
//  YMWebView.h
//  YMFramework
//
//  Created by Tristen-MacBook on 8/11/14.
//
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol YMWebViewDelegate <NSObject>

@optional


- (void)webView:(WKWebView *_Nullable)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;

- (void)webView:(WKWebView *_Nullable)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation;

- (void)webView:(WKWebView *_Nullable)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *_Nullable)error;

- (BOOL)webView:(WKWebView *_Nullable)webView decidePolicyForNavigationAction:(WKNavigationAction *_Nullable)navigationAction;

- (void)webViewShouldRefresh:(WKWebView *_Nullable)webView;

@end

@interface YMWebView : WKWebView

@property (nonatomic, weak) id <YMWebViewDelegate> ym_Delegate;

@property (nonatomic, strong) NSURLRequest *orignalRequest;

- (void)loadRequest:(NSURLRequest *_Nullable)request needRefreshAnimation:(BOOL)animation;

- (void)reloadNeedRefreshAnimation:(BOOL)animation;

- (void)removeHeader;

@end

