//
//  ViewController.m
//  ExampleForYMCodeStandard
//
//  Created by Tristen on 11/23/15.
//
//

#import <YMFramework/YMFramework.h>
#import "ViewController.h"

static NSString * const kProductID = @"10000";
static NSString * const kProductVersion = @"1";
static NSString * const kProductChannel = @"1";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[YMFrameworkConfig sharedInstance] setupProductByID:kProductID
                                                 version:kProductVersion
                                                 channel:kProductChannel];
    
    [self testHttpRequest];
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


@end
