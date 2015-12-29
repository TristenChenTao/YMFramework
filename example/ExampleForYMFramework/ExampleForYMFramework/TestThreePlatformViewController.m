//
//  ViewController.m
//  ThreePlatfrom
//
//  Created by yumi_iOS on 12/17/15.
//  Copyright © 2015 yumi_iOS. All rights reserved.
//

#import "TestThreePlatformViewController.h"
#import <YMFramework/YMFramework.h>

@interface TestThreePlatformViewController ()

@property (nonatomic, strong) UIButton *qqLoginButton;
@property (nonatomic, strong) UIButton *wxLoginButton;
@property (nonatomic, strong) UIButton *wbLoginButton;
@property (nonatomic, strong) UIButton *shareQQFriendButton;
@property (nonatomic, strong) UIButton *shareQQZoneButton;
@property (nonatomic, strong) UIButton *shareWXTimelineButton;
@property (nonatomic, strong) UIButton *shareWXSessionButton;
@property (nonatomic, strong) UIButton *shareWBButton;

@end

@implementation TestThreePlatformViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [YMThirdPlatformTool setupQQByAppId:@"100371282"
                                 appKey:@"aed9b0303e3ed1e27bae87c33761161d"];
    
    [YMThirdPlatformTool setupWeChatByAppId:@"wx4868b35061f87885"
                                  appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
    
    [YMThirdPlatformTool setupSinaWeiboByAppKey:@"568898243"
                                      appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                    redirectUri:@"http://www.sharesdk.cn"];
    
    [self.view addSubview:self.qqLoginButton];
    [self.view addSubview:self.wxLoginButton];
    [self.view addSubview:self.wbLoginButton];
    [self.view addSubview:self.shareQQFriendButton];
    [self.view addSubview:self.shareQQZoneButton];
    [self.view addSubview:self.shareWXTimelineButton];
    [self.view addSubview:self.shareWXSessionButton];
    [self.view addSubview:self.shareWBButton];
    
    [super viewDidLoad];
}


#pragma mark - IBAction

- (void)qqLogin:(id)sender
{
    [YMThirdPlatformTool loginForPlatformType:YMThirdPlatformForQQ
                                      success:^(YMThirdPlatformUserInfo *platformUserInfo) {
                                          NSLog(@"this is qqUserInfo: %@", platformUserInfo);
                                      } failure:^(NSError **error) {
                                          NSLog(@"this is qqLogin error:%@", *error);
                                      } cancel:^{
                                          NSLog(@"qqLogin cancel");
                                      }] ;
}

- (void)wxLogin:(id)sender
{
    [YMThirdPlatformTool loginForPlatformType:YMThirdPlatformForWechat
                                      success:^(YMThirdPlatformUserInfo *platformUserInfo) {
                                          NSLog(@"this is wxUserInfo: %@", platformUserInfo);
                                      } failure:^(NSError **error) {
                                          NSLog(@"this is wxLogin error:%@", *error);
                                      } cancel:^{
                                          NSLog(@"wxLogin cancel");
                                      }] ;
}

- (void)wbLogin:(id)sender
{
    [YMThirdPlatformTool loginForPlatformType:YMThirdPlatformForWeibo
                                      success:^(YMThirdPlatformUserInfo *platformUserInfo) {
                                          NSLog(@"this is wbUserInfo: %@", platformUserInfo);
                                      } failure:^(NSError **error) {
                                          NSLog(@"this is wbLogin error:%@", *error);
                                      } cancel:^{
                                          NSLog(@"wbLogin cancel");
                                      }] ;
}


- (void)qqFriendShare:(id)sender
{
    NSDictionary *entityDic = @{@"shareType":[NSNumber numberWithUnsignedInteger:YMThirdPlatformShareTypeForQQFriend],
                                @"contentType":@"nil",
                                @"title":@"title",
                                @"imageUrl":@"http://img0w.pconline.com.cn/pconline/1308/30/3449971_06.jpg",
                                @"resourceUrl":@"https://www.baidu.com",
                                @"contentText":@"description"};
    YMThirdPlatformShareEntity *entity = [[YMThirdPlatformShareEntity  alloc] initWithData:entityDic];
    [YMThirdPlatformTool shareWithEntity:entity
                                 success:^(YMThirdPlatformShareEntity *shareEntity) {
                                     NSLog(@"this is qqFriendShare success");
                                 } failure:^(YMThirdPlatformShareEntity *entity, NSError **error) {
                                     NSLog(@"this is qqFriendShare failure %@", *error);
                                 } cancel:^(YMThirdPlatformShareEntity *entity){
                                     NSLog(@"this is qqFriendCancel");
                                 }];
}

- (void)qqZoneShare:(id)sender
{
    NSDictionary *entityDic = @{@"shareType":[NSNumber numberWithUnsignedInteger:YMThirdPlatformShareTypeForQQZone],
                                @"contentType":@"nil",
                                @"title":@"title",
                                @"imageUrl":@"http://img0w.pconline.com.cn/pconline/1308/30/3449971_06.jpg",
                                @"resourceUrl":@"https://www.baidu.com",
                                @"contentText":@"description"};
    YMThirdPlatformShareEntity *entity = [[YMThirdPlatformShareEntity  alloc] initWithData:entityDic];
    [YMThirdPlatformTool shareWithEntity:entity
                                 success:^(YMThirdPlatformShareEntity *shareEntity) {
                                     NSLog(@"this is qqZoneShare success");
                                 } failure:^(YMThirdPlatformShareEntity *entity, NSError **error) {
                                     NSLog(@"this is qqZoneShare failure %@", *error);
                                 } cancel:^(YMThirdPlatformShareEntity *entity){
                                     NSLog(@"this is qqZoneCancel");
                                 }];
}

- (void)wxSessionShare:(id)sender
{
    NSDictionary *entityDic = @{@"shareType":[NSNumber numberWithUnsignedInteger:YMThirdPlatformShareTypeForWechatSession],
                                @"contentType":@"nil",
                                @"title":@"title",
                                @"imageUrl":@"http://img0w.pconline.com.cn/pconline/1308/30/3449971_06.jpg",
                                @"resourceUrl":@"https://www.baidu.com",
                                @"contentText":@"description"};
    YMThirdPlatformShareEntity *entity = [[YMThirdPlatformShareEntity  alloc] initWithData:entityDic];
    [YMThirdPlatformTool shareWithEntity:entity
                                 success:^(YMThirdPlatformShareEntity *shareEntity) {
                                     NSLog(@"this is wxSessionShare success");
                                 } failure:^(YMThirdPlatformShareEntity *entity ,NSError **error) {
                                     NSLog(@"this is wxSessionShare failure %@", *error);
                                 } cancel:^(YMThirdPlatformShareEntity *entity){
                                     NSLog(@"this is wxSessionCancel");
                                 }];
}

- (void)wxTimelineShare:(id)sender
{
    NSDictionary *entityDic = @{@"shareType":[NSNumber numberWithUnsignedInteger:YMThirdPlatformShareTypeForWechatTimeline],
                                @"contentType":@"nil",
                                @"title":@"title",
                                @"imageUrl":@"http://img0w.pconline.com.cn/pconline/1308/30/3449971_06.jpg",
                                @"resourceUrl":@"https://www.baidu.com",
                                @"contentText":@"description"};
    YMThirdPlatformShareEntity *entity = [[YMThirdPlatformShareEntity  alloc] initWithData:entityDic];
    [YMThirdPlatformTool shareWithEntity:entity
                                 success:^(YMThirdPlatformShareEntity *shareEntity) {
                                     NSLog(@"this is wxTimelineShare success");
                                 } failure:^(YMThirdPlatformShareEntity *entity ,NSError **error) {
                                     NSLog(@"this is wxTimelineShare failure %@", *error);
                                 } cancel:^(YMThirdPlatformShareEntity *entity){
                                     NSLog(@"this is wxTimelineCancel");
                                 }];
}
- (void)wbShare:(id)sender
{
    NSDictionary *entityDic = @{@"shareType":[NSNumber numberWithUnsignedInteger:YMThirdPlatformShareTypeForWeibo],
                                @"contentType":@"nil",
                                @"title":@"title",
                                @"imageUrl":@"http://img0w.pconline.com.cn/pconline/1308/30/3449971_06.jpg",
                                @"resourceUrl":@"https://www.baidu.com",
                                @"contentText":@"description"};
    YMThirdPlatformShareEntity *entity = [[YMThirdPlatformShareEntity  alloc] initWithData:entityDic];
    [YMThirdPlatformTool shareWithEntity:entity
                                 success:^(YMThirdPlatformShareEntity *shareEntity) {
                                     NSLog(@"this is weiboShare success");
                                 } failure:^(YMThirdPlatformShareEntity *entity ,NSError **error) {
                                     NSLog(@"this is weiboShare failure %@", *error);
                                 } cancel:^(YMThirdPlatformShareEntity *entity){
                                     NSLog(@"this is weiboCancel");
                                 }];
}

#pragma mark - getters

- (UIButton *)qqLoginButton
{
    if (_qqLoginButton == nil) {
        _qqLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 150, 50)];
        [_qqLoginButton setTitle:@"QQ登陆"
                        forState:UIControlStateNormal];
        [_qqLoginButton setTitleColor:[UIColor blueColor]
                             forState:UIControlStateNormal];
        [_qqLoginButton addTarget:self
                           action:@selector(qqLogin:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _qqLoginButton;
}

- (UIButton *)wxLoginButton
{
    if (_wxLoginButton == nil) {
        _wxLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 60, 150, 50)];
        [_wxLoginButton setTitleColor:[UIColor blueColor]
                             forState:UIControlStateNormal];
        [_wxLoginButton setTitle:@"微信登陆"
                        forState:UIControlStateNormal];
        [_wxLoginButton addTarget:self
                           action:@selector(wxLogin:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _wxLoginButton;
}

- (UIButton *)wbLoginButton
{
    if (_wbLoginButton == nil) {
        _wbLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 110, 150, 50)];
        [_wbLoginButton setTitleColor:[UIColor blueColor]
                             forState:UIControlStateNormal];
        [_wbLoginButton setTitle:@"微博登陆"
                        forState:UIControlStateNormal];
        [_wbLoginButton addTarget:self
                           action:@selector(wbLogin:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _wbLoginButton;
}

- (UIButton *)shareQQFriendButton
{
    if (_shareQQFriendButton == nil) {
        _shareQQFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 160, 150, 50)];
        [_shareQQFriendButton setTitleColor:[UIColor blueColor]
                                   forState:UIControlStateNormal];
        [_shareQQFriendButton   setTitle:@"分享给QQ好友"
                                forState:UIControlStateNormal];
        [_shareQQFriendButton addTarget:self
                                 action:@selector(qqFriendShare:)
                       forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _shareQQFriendButton;
}

- (UIButton *)shareQQZoneButton
{
    if (_shareQQZoneButton == nil) {
        _shareQQZoneButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 210, 150, 50)];
        [_shareQQZoneButton setTitleColor:[UIColor blueColor]
                                 forState:UIControlStateNormal];
        [_shareQQZoneButton setTitle:@"分享到QQ空间"
                            forState:UIControlStateNormal];
        [_shareQQZoneButton addTarget:self
                               action:@selector(qqZoneShare:)
                     forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _shareQQZoneButton;
}

- (UIButton *)shareWXTimelineButton
{
    if (_shareWXTimelineButton == nil) {
        _shareWXTimelineButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 260, 150, 50)];
        [_shareWXTimelineButton setTitleColor:[UIColor blueColor]
                                     forState:UIControlStateNormal];
        [_shareWXTimelineButton setTitle:@"分享到微信朋友圈"
                                forState:UIControlStateNormal];
        [_shareWXTimelineButton addTarget:self
                                   action:@selector(wxTimelineShare:)
                         forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _shareWXTimelineButton;
}

- (UIButton *)shareWXSessionButton
{
    if (_shareWXSessionButton == nil) {
        _shareWXSessionButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 310, 150, 50)];
        [_shareWXSessionButton setTitleColor:[UIColor blueColor]
                                    forState:UIControlStateNormal];
        
        [_shareWXSessionButton setTitle:@"分享给微信好友"
                               forState:UIControlStateNormal];
        [_shareWXSessionButton addTarget:self
                                  action:@selector(wxSessionShare:)
                        forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _shareWXSessionButton;
}
- (UIButton *)shareWBButton
{
    if (_shareWBButton == nil) {
        _shareWBButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 360, 150, 50)];
        [_shareWBButton setTitleColor:[UIColor blueColor]
                             forState:UIControlStateNormal];
        [_shareWBButton setTitle:@"分享到微博"
                        forState:UIControlStateNormal];
        [_shareWBButton addTarget:self
                           action:@selector(wbShare:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _shareWBButton;
}

@end
