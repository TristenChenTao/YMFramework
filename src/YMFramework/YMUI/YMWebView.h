//
//  YMWebView.h
//  YMFramework
//
//  Created by Tristen-MacBook on 8/11/14.
//
//

#import <UIKit/UIKit.h>

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

@end

@interface YMWebView : UIWebView

@property (nonatomic, weak) id <YMWebViewDelegate>	ym_Delegate;

@end

