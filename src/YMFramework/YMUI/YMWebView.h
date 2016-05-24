//
//  YMWebView.h
//  YMFramework
//
//  Created by Tristen-MacBook on 8/11/14.
//
//

#import <UIKit/UIKit.h>

typedef BOOL(^YMWebViewShouldStartHandler)(UIWebView *webView, UIViewController *containerVC, NSURLRequest *request, UIWebViewNavigationType navigationType);

@protocol YMWebViewDelegate <NSObject>

@optional

- (void)webViewDidFinishLoad:(UIWebView *)webView;

- (void)webViewDidStartLoad:(UIWebView *)webView;

- (void)webView:(UIWebView *)webView
didFailLoadWithError:(NSError *)error;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType;

- (void)webViewShouldRefresh:(UIWebView *)webView;

@end

@interface YMWebView : UIWebView

@property (nonatomic, weak) id <YMWebViewDelegate> ym_Delegate;

- (instancetype)initWithContainerVC:(UIViewController *)viewController;

- (void)loadRequest:(NSURLRequest *)request;

- (void)loadRequestByRefresh:(NSURLRequest *)request;

/**
 *  加载全局URL链接处理器
 *
 *  @param handler
 */
+(void)loadGlobalShouldStartHandler:(YMWebViewShouldStartHandler)handler;

@end

