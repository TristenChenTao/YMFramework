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


- (void)webViewDidFinishLoad:(UIWebView *)webView;

- (void)webViewDidStartLoad:(UIWebView *)webView;

- (void)webView:(UIWebView *)webView
didFailLoadWithError:(NSError *)error;

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType;

- (void)webViewShouldRefresh:(UIWebView *)webView;


@end

@interface YMWebView : UIWebView

@property (nonatomic, weak) id <YMWebViewDelegate> ym_Delegate;

@property (nonatomic, strong) NSURLRequest *orignalRequest;

- (void)loadRequest:(NSURLRequest *_Nullable)request needRefreshAnimation:(BOOL)animation;

- (void)reloadNeedRefreshAnimation:(BOOL)animation;

- (void)removeHeader;

@end

