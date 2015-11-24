//
//  ViewController.m
//  ExampleForYMFramework
//
//  Created by Tristen on 11/24/15.
//  Copyright © 2015 yumi. All rights reserved.
//

#import <YMFramework/YMFramework.h>
#import "ViewController.h"

static NSString * const kProductID = @"10000";
static NSString * const kProductVersion = @"1";
static NSString * const kProductChannel = @"1";

@interface ViewController ()<UIWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[YMFrameworkConfig sharedInstance] setupProductByID:kProductID
                                                 version:kProductVersion
                                                 channel:kProductChannel];
    
//    [self testHttpRequest];
//
//    [self testUIImageViewDownloadImage];
    
//    [self testUIButtonDownloadImage];
    
//    [self testFetchWebViewTitle];
    
//    [self testWebp];
    
    [self testWebpForWebView];
}

-(void)testHttpRequest
{
    [YMHTTPRequestManager requestWithMethodType:YMHttpMethodTypeForGet
                                    relativeURL:@"/ServerTime/ServerTimes.ashx?m=STime"
                                        baseURL:@"http://test.fortune.cornapp.com"
                                         baseIP:@"http://112.74.105.46:8086"
                                    headerField:nil
                                     parameters:nil
                                        timeout:15
                                        success:^(NSURLRequest *request, NSInteger ResultCode, NSString *ResultMessage, id data)
     {
         NSLog(@"data %@",data);
         
     }
                                        failure:^(NSURLRequest *request, NSError *error)
     {
         NSLog(@"error %@",error.localizedDescription);
     }];
}

-(void)testUIImageViewDownloadImage
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [imgView ym_setImageWithURL:@"http://dhcrestaurantlogo.dhero.cn/7565?v=1406259590"];
    [self.view addSubview:imgView];
}

-(void)testUIButtonDownloadImage
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [button ym_setImageWithURL:@"http://dhcrestaurantlogo.dhero.cn/7565?v=1406259590"
                      forState:UIControlStateNormal];
    [self.view addSubview:button];
}

- (void)testFetchWebViewTitle
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kYm_NavgationBarHeight, kYm_ScreenWidth, kYm_ScreenHeight - kYm_NavgationBarHeight)];
    [self.view addSubview:webView];
    webView.delegate = self;
    
    NSMutableURLRequest *request = [YMHTTPRequestManager requestWithMethodType:YMHttpMethodTypeForGet
                                                                    URLAddress:@"http://www.xinhuanet.com/"
                                                                       timeout:10
                                                                    parameters:nil
                                                                   headerField:nil];
    [webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *title = [webView ym_fetchHtmlNormalTitle];
    NSLog(@"fetch Html Normal Title is %@",title);
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    NSLog(@"error is %@",error.localizedDescription);
}

- (void)testWebp
{
    //标准webpURL
//    NSString *url = @"http://img01.taobaocdn.com/imgextra/i1/1123492339/T2XX3ZXhXXXXXXXXXX_!!1123492339.jpg_.webp";
    //玉米webpURL
    NSString *url = @"http://yumi2014.b0.upaiyun.com/banner/14483353790a62cd5be70e4e2f877e410df031febc.jpg!webp.orginal";
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imgView.backgroundColor = [UIColor redColor];
    [imgView ym_setImageWithURL:url];
    [self.view addSubview:imgView];
    
    if ([YMImageDownloader cachedImageExistsForURL:url]) {
        NSLog(@"has cached");
    }
}

- (void)testWebpForWebView
{
    NSString *url = @"http://interface.cornapp.com/yumiNew/newsList.aspx";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.backgroundColor = [UIColor redColor];
    [self.view addSubview:webView];
    webView.delegate = self;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:20];
    [webView loadRequest:request];
}

@end