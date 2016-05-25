//
//  ViewController.m
//  ExampleForYMFramework
//
//  Created by Tristen on 11/24/15.
//  Copyright © 2015 yumi. All rights reserved.
//

#import <YMFramework/YMFramework.h>
#import "ViewController.h"
#import "BaseWebVC.h"

static NSString * const kProductID = @"10000";
static NSString * const kProductVersion = @"1";
static NSString * const kProductChannel = @"1";

@interface ViewController ()
<
UIWebViewDelegate,
YMWebViewDelegate
>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    [[YMFrameworkConfig sharedInstance] setupProductByID:kProductID
                                                 version:kProductVersion
                                                 channel:kProductChannel];
    
//    [self testHttpRequest];
//    
//    [self testUIImageViewDownloadImage];
//    [self testUIButtonDownloadImage];
//    [self testFetchWebViewTitle];
//    [self testWebp];
//    [self testWebpForWebView];
//    [self testYMProgress];
//    [self testBackgroundTask];
    [self testUploadImage];
//    [self testUploadJSONData];
    
//    [self testYMWebView];
    
//    [self testIsPhoneNumber];

}

- (void)motionEnded:(UIEventSubtype)motion
          withEvent:(UIEvent *)event
{
    [super motionEnded:motion
             withEvent:event];
    [YMDebugging setNetworkDebuggingEnabled:YES];
    [YMDebugging showExplorer];
    
    static BOOL kFirstShow = YES;
    if (kFirstShow) {
        [YMDebugging showCurrentVersionInfo];
        
        kFirstShow = NO;
    }
}

-(void)testHttpRequest
{
    NSURLSessionDataTask *task = [YMHTTPManager requestWithMethodType:YMHttpRequestTypeForGet
                                                          relativeURL:@"/ServerTime/ServerTimes.ashx?m=STime"
                                                              baseURL:@"http://test.fortune.cornapp.com"
                                                               baseIP:@"http://112.74.105.46:8086"
                                                           parameters:nil
                                                              timeout:1
                                                             progress:^(NSProgress *downloadProgress) {
                                                                 NSLog(@"downloadProgress is %@",downloadProgress);
                                                             }
                                                              success:^(NSURLSessionDataTask *task, YMHTTPResponseData *responseData) {
                                                                  NSLog(@"%@",responseData.ResultMessage);
                                                                  NSLog(@"request URL is %@",responseData.data);
                                                              }
                                                              failure:^(NSURLSessionDataTask *task, NSError *error) {
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
    
    NSMutableURLRequest *request = [YMHTTPManager requestWithMethodType:YMHttpRequestTypeForGet
                                                             URLAddress:@"http://www.xinhuanet.com/"
                                                                timeout:10
                                                             parameters:nil];
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
    [YMURLProtocol registerProtocol]; //WebView支持Webp图片格式
    
    NSString *url = @"http://interface.cornapp.com/yumiNew/newsList.aspx?channel=3&device=iPhone5%2C2&deviceId=9F92F58E-F182-4297-A33E-02DDEE710D5D&edition=7&isCrack=1&lang=zh-Hans&network=&osType=1&proID=100&scrH=568&scrW=320&uid=100002&ymtimestamp=eyJnt3GOhIjotNS45NjA0NjQ0Nzc1MzkwNjJlLTA2LCJ6IjoxNDQ4MzUxNzU5LjU1NjEwOH0%3D1ZkFw";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.backgroundColor = [UIColor redColor];
    [self.view addSubview:webView];
    webView.delegate = self;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:20];
    [webView loadRequest:request];
}

- (void)testYMProgress
{
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       //            [YMProgress showFailStatus:@"错误"];
                       //                       [YMProgress showFailStatus:@"无网络"
                       //                                     withFailType:YMProgrssFailTypeForNotReachable];
                       
                       //                       [YMProgress showFailStatus:@"定位错误"
                       //                                     withFailType:YMProgrssFailTypeForLocation];
                       //        [YMProgress showWithStatus:@"加载中"];
                       
                       [YMProgress showInfoWithStatus:@"请输入密码"];
                       
                   });
}

- (void)testBackgroundTask
{
    YM_BgTaskBegin();
    
    while (YES) {
        NSLog(@"+++++++++");
        sleep(5);
    }
    
    YM_BgTaskEnd();
}

- (void)testUploadImage
{
    UIImage *testImage = [UIImage imageNamed:@"测试图片上传"];
    NSArray *images = [[NSArray alloc]initWithObjects:testImage, nil];
    NSArray *names = [[NSArray alloc]initWithObjects:@"image0", nil];
    
    [YMHTTPManager uploadImages:images
                     imageNames:names
                    relativeURL:@"/Account/ChangeUserAvatar.ashx?m=UpdateUserAvatar"
                        baseURL:@"http://test.fortune.cornapp.com"
                         baseIP:@"http://112.74.105.46:8086"
                     parameters:nil
                        timeout:30
                       progress:^(NSProgress *progress) {
                           NSLog(@"progress %@",progress);
                       }
                        success:^(NSURLSessionDataTask *task, YMHTTPResponseData *responseData) {
                            NSLog(@"%@",responseData.ResultMessage);
                        }
                        failure:^(NSURLSessionDataTask *task, NSError *error) {
                            NSLog(@"error %@",error.localizedDescription);
                        }];
}

- (void)testUploadJSONData
{
    NSArray *phoneArray = @[@"123123",@"233242342",@"234234234"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:phoneArray
                                                   options:kNilOptions
                                                     error:nil];
    //用于测试
    NSString *jsonString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
    NSLog(@"jsonString is %@",jsonString);
    
    [YMHTTPManager uploadJSONData:data
                      relativeURL:@"/FriendsRanking/UserFriRank.ashx?m=UploadContracts"
                          baseURL:@"http://test.fortune.cornapp.com"
                           baseIP:@"http://112.74.105.46:8086"
                       parameters:nil
                          timeout:10
                         progress:^(NSProgress *progress) {
                             NSLog(@"progress %@",progress);
                         }
                          success:^(NSURLSessionDataTask *task, YMHTTPResponseData *responseData) {
                              NSLog(@"%@",responseData.ResultMessage);
                          }
                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                              NSLog(@"error %@",error.localizedDescription);
                          }];
}

- (void)testYMWebView
{
    YMWebView *webView = [[YMWebView alloc] initWithContainerVC:self];
    webView.frame = self.view.bounds;
    [self.view addSubview:webView];
    webView.ym_Delegate = self;
    
    self.navigationItem.title = @"首页";
    
    NSMutableURLRequest *request = [YMHTTPManager requestWithMethodType:YMHttpRequestTypeForGet
                                                             URLAddress:@"http://www.xinhuanet.com/"
                                                                timeout:10
                                                             parameters:nil];
    [webView loadRequest:request];
    
    [YMWebView loadGlobalShouldStartHandler:^BOOL(UIWebView *webView, UIViewController *containerVC, NSURLRequest *request, UIWebViewNavigationType navigationType) {
        NSString *url = request.URL.absoluteString;
        NSLog(@"url is %@",url);
        NSLog(@"navigationType is %ld",navigationType);
        
        if (navigationType == UIWebViewNavigationTypeLinkClicked) {
            BaseWebVC *webVC = [[BaseWebVC alloc] initWithRequest:request];
            [containerVC.navigationController pushViewController:webVC animated:YES];
            return NO;
        }
        
        return YES;
    }];
}

- (void)testIsPhoneNumber
{
    NSString *phone = @"15980287196";
    
    if([phone ym_isMobileNumber]){
        [YMProgress showSuccessStatus:@"是手机号"];
    }
}

@end