//
//  BaseWebVC.m
//  ExampleForYMFramework
//
//  Created by TristenChen on 4/26/16.
//  Copyright © 2016 yumi. All rights reserved.
//

#import "BaseWebVC.h"

@interface BaseWebVC()<YMWebViewDelegate>

@property (strong, nonatomic) YMWebView *webView;

@end

@implementation BaseWebVC

- (instancetype)initWithRequest:(NSURLRequest *)request
{
    self = [super init];
    if (self) {
        [self.view addSubview:self.webView];
        
        [self.webView loadRequest:request];
    }
    return self;
}

#pragma mark - getters and setters

- (YMWebView *)webView
{
    if (_webView == nil) {
        _webView = [[YMWebView alloc] initWithContainerVC:self];
        _webView.ym_Delegate = self;
        _webView.frame = self.view.bounds;
    }
    
    return _webView;
}

#pragma mark - YMWebViewDelegate

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{    
    NSString *url = request.URL.absoluteString;
    NSLog(@"url is %@",url);
    NSLog(@"navigationType is %ld",navigationType);
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        BaseWebVC *webVC = [[BaseWebVC alloc] initWithRequest:request];
        [self.navigationController pushViewController:webVC animated:YES];
        return NO;
    }
    
    return YES;
    
    
}

@end
