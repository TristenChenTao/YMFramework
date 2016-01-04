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
@property (nonatomic, strong) UIButton *shareQQFriendGifButton;
@property (nonatomic, strong) UIButton *shareWXSessionGifButton;

@end

@implementation TestThreePlatformViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor]; //ddfsdfsdf
    
    [YMThirdPlatformTool setupQQByAppId:@"100371282"
                                 appKey:@"aed9b0303e3ed1e27bae87c33761161d"];
    
    [YMThirdPlatformTool setupWeChatByAppId:@"wx99d5fdb34920484b"
                                  appSecret:@"8d478ec3825697d3fe879394266a1d68"];
    
    [YMThirdPlatformTool setupSinaWeiboByAppKey:@"2447222363"
                                      appSecret:@"57cf02f1baba0b9e7a548d464af29af8"
                                    redirectUri:@"http://cornapp.com/"];
    
    [self.view addSubview:self.qqLoginButton];
    [self.view addSubview:self.wxLoginButton];
    [self.view addSubview:self.wbLoginButton];
    [self.view addSubview:self.shareQQFriendButton];
    [self.view addSubview:self.shareQQZoneButton];
    [self.view addSubview:self.shareWXTimelineButton];
    [self.view addSubview:self.shareWXSessionButton];
    [self.view addSubview:self.shareWBButton];
    [self.view addSubview:self.shareQQFriendGifButton];
    [self.view addSubview:self.shareWXSessionGifButton];
    
    [self setupViewLayout];
    [super viewDidLoad];
}

- (void)setupViewLayout
{
    self.qqLoginButton.center = CGPointMake(10, 10);
    self.qqLoginButton.ym_Size = CGSizeMake(150, 50);
    
    self.wxLoginButton.center = CGPointMake(10, 60);
    self.wxLoginButton.ym_Size = CGSizeMake(150, 50);
    
    self.wbLoginButton.center = CGPointMake(10, 110);
    self.wbLoginButton.ym_Size = CGSizeMake(150, 50);
    
    self.shareQQZoneButton.center = CGPointMake(10, 160);
    self.shareQQZoneButton.ym_Size = CGSizeMake(150, 50);
    
    self.shareQQFriendButton.center = CGPointMake(10, 210);
    self.shareQQFriendButton.ym_Size = CGSizeMake(150, 50);
    
    self.shareWXTimelineButton.center = CGPointMake(10, 260);
    self.shareWXTimelineButton.ym_Size = CGSizeMake(150, 50);
    
    self.shareWXSessionButton.center = CGPointMake(10, 310);
    self.shareWXSessionButton.ym_Size = CGSizeMake(150, 50);
    
    self.shareWBButton.center = CGPointMake(10, 360);
    self.shareWBButton.ym_Size = CGSizeMake(150, 50);
    
    self.shareQQFriendGifButton.center = CGPointMake(10, 410);
    self.shareQQFriendGifButton.ym_Size = CGSizeMake(150, 50);
    
    self.shareWXSessionGifButton.center = CGPointMake(10, 460);
    self.shareWXSessionGifButton.ym_Size = CGSizeMake(150, 50);
    
}


#pragma mark - IBAction

- (void)qqLogin:(id)sender
{
    [YMThirdPlatformTool loginForPlatformType:YMThirdPlatformForQQ
                                      success:^(YMThirdPlatformUserInfo *platformUserInfo) {
                                          YM_Log(@"this is qqUserInfo: %@", platformUserInfo);
                                          YM_Log(@"userId= %@", platformUserInfo.userId);
                                          YM_Log(@"nickname = %@", platformUserInfo.nickname);
                                          YM_Log(@"profileImageUrl = %@", platformUserInfo.profileImageUrl);
                                          YM_Log(@"accessToken = %@", platformUserInfo.accessToken);
                                          YM_Log(@"expired = %@", platformUserInfo.expired);
                                      } failure:^(NSError *error) {
                                          YM_Log(@"this is qqLogin error:%@", error);
                                      } cancel:^{
                                          YM_Log(@"qqLogin cancel");
                                      }] ;
}

- (void)wxLogin:(id)sender
{
    [YMThirdPlatformTool loginForPlatformType:YMThirdPlatformForWechat
                                      success:^(YMThirdPlatformUserInfo *platformUserInfo) {
                                          YM_Log(@"this is wxUserInfo: %@", platformUserInfo);
                                          YM_Log(@"userId= %@", platformUserInfo.userId);
                                          YM_Log(@"nickname = %@", platformUserInfo.nickname);
                                          YM_Log(@"profileImageUrl = %@", platformUserInfo.profileImageUrl);
                                          YM_Log(@"accessToken = %@", platformUserInfo.accessToken);
                                          YM_Log(@"expired = %@", platformUserInfo.expired);
                                      } failure:^(NSError *error) {
                                          YM_Log(@"this is wxLogin error:%@", error);
                                      } cancel:^{
                                          YM_Log(@"wxLogin cancel");
                                      }] ;
}

- (void)wbLogin:(id)sender
{
    [YMThirdPlatformTool loginForPlatformType:YMThirdPlatformForWeibo
                                      success:^(YMThirdPlatformUserInfo *platformUserInfo) {
                                          YM_Log(@"this is wbUserInfo: %@", platformUserInfo);
                                          YM_Log(@"userId= %@", platformUserInfo.userId);
                                          YM_Log(@"nickname = %@", platformUserInfo.nickname);
                                          YM_Log(@"profileImageUrl = %@", platformUserInfo.profileImageUrl);
                                          YM_Log(@"accessToken = %@", platformUserInfo.accessToken);
                                          YM_Log(@"expired = %@", platformUserInfo.expired);
                                      } failure:^(NSError *error) {
                                          YM_Log(@"this is wbLogin error:%@", error);
                                      } cancel:^{
                                          YM_Log(@"wbLogin cancel");
                                      }] ;
}


- (void)qqFriendShare:(id)sender
{
    NSDictionary *entityDic = @{@"shareType":[NSNumber numberWithUnsignedInteger:YMThirdPlatformShareForQQFriend],
                                @"contentType":@"nil",
                                @"title":@"title",
                                @"imageUrl":@"http://img0w.pconline.com.cn/pconline/1308/30/3449971_06.jpg",
                                @"resourceUrl":@"https://www.baidu.com",
                                @"contentText":@"description"};
    YMThirdPlatformShareEntity *entity = [[YMThirdPlatformShareEntity  alloc] initWithData:entityDic];
    [YMThirdPlatformTool shareWithEntity:entity
                                 success:^(YMThirdPlatformShareEntity *shareEntity) {
                                     YM_Log(@"this is qqFriendShare success");
                                 } failure:^(YMThirdPlatformShareEntity *entity, NSError *error) {
                                     YM_Log(@"this is qqFriendShare failure %@", error);
                                 } cancel:^(YMThirdPlatformShareEntity *entity){
                                     YM_Log(@"this is qqFriendShareCancel");
                                 }];
}

- (void)qqZoneShare:(id)sender
{
    NSDictionary *entityDic = @{@"shareType":[NSNumber numberWithUnsignedInteger:YMThirdPlatformShareForQQFriend],
                                @"contentType":@"nil",
                                @"title":@"title",
                                @"imageUrl":@"http://img0w.pconline.com.cn/pconline/1308/30/3449971_06.jpg",
                                @"resourceUrl":@"https://www.baidu.com",
                                @"contentText":@"description"};
    YMThirdPlatformShareEntity *entity = [[YMThirdPlatformShareEntity  alloc] initWithData:entityDic];
    [YMThirdPlatformTool shareWithEntity:entity
                                 success:^(YMThirdPlatformShareEntity *shareEntity) {
                                     YM_Log(@"this is qqZoneShare success");
                                 } failure:^(YMThirdPlatformShareEntity *entity, NSError *error) {
                                     YM_Log(@"this is qqZoneShare failure %@", error);
                                 } cancel:^(YMThirdPlatformShareEntity *entity){
                                     YM_Log(@"this is qqZoneShareCancel");
                                 }];
}

- (void)wxSessionShare:(id)sender
{
    NSDictionary *entityDic = @{@"shareType":[NSNumber numberWithUnsignedInteger:YMThirdPlatformShareForWechatSession],
                                @"contentType":@"nil",
                                @"title":@"title",
                                @"imageUrl":@"http://ww1.sinaimg.cn/bmiddle/754e3dc7gw1e75xkgm3kqg206t03rtgh.gif",
                                @"resourceUrl":@"https://www.baidu.com",
                                @"contentText":@"description"};
    YMThirdPlatformShareEntity *entity = [[YMThirdPlatformShareEntity  alloc] initWithData:entityDic];
    [YMThirdPlatformTool shareWithEntity:entity
                                 success:^(YMThirdPlatformShareEntity *shareEntity) {
                                     YM_Log(@"this is wxSessionShare success");
                                 } failure:^(YMThirdPlatformShareEntity *entity ,NSError *error) {
                                     YM_Log(@"this is wxSessionShare failure %@", error);
                                 } cancel:^(YMThirdPlatformShareEntity *entity){
                                     YM_Log(@"this is wxSessionShareCancel");
                                 }];
}

- (void)wxTimelineShare:(id)sender
{
    NSDictionary *entityDic = @{@"shareType":[NSNumber numberWithUnsignedInteger:YMThirdPlatformShareForWechatTimeline],
                                @"contentType":@"nil",
                                @"title":@"title",
                                @"imageUrl":@"http://img0w.pconline.com.cn/pconline/1308/30/3449971_06.jpg",
                                @"resourceUrl":@"https://www.baidu.com",
                                @"contentText":@"description"};
    YMThirdPlatformShareEntity *entity = [[YMThirdPlatformShareEntity  alloc] initWithData:entityDic];
    [YMThirdPlatformTool shareWithEntity:entity
                                 success:^(YMThirdPlatformShareEntity *shareEntity) {
                                     YM_Log(@"this is wxTimelineShare success");
                                 } failure:^(YMThirdPlatformShareEntity *entity ,NSError *error) {
                                     YM_Log(@"this is wxTimelineShare failure %@", error);
                                 } cancel:^(YMThirdPlatformShareEntity *entity){
                                     YM_Log(@"this is wxTimelineShareCancel");
                                 }];
}
- (void)wbShare:(id)sender
{
    NSDictionary *entityDic = @{@"shareType":[NSNumber numberWithUnsignedInteger:YMThirdPlatformForWeibo],
                                @"contentType":@"nil",
                                @"title":@"title",
                                @"imageUrl":@"http://img0w.pconline.com.cn/pconline/1308/30/3449971_06.jpg",
                                @"resourceUrl":@"https://www.baidu.com",
                                @"contentText":@"description"};
    YMThirdPlatformShareEntity *entity = [[YMThirdPlatformShareEntity  alloc] initWithData:entityDic];
    [YMThirdPlatformTool shareWithEntity:entity
                                 success:^(YMThirdPlatformShareEntity *shareEntity) {
                                     YM_Log(@"this is weiboShare success");
                                 } failure:^(YMThirdPlatformShareEntity *entity ,NSError *error) {
                                     YM_Log(@"this is weiboShare failure %@", error);
                                 } cancel:^(YMThirdPlatformShareEntity *entity){
                                     YM_Log(@"this is weiboShareCancel");
                                 }];
}

- (void)qqShareGif
{
    NSDictionary *entityDic = @{@"shareType":[NSNumber numberWithUnsignedInteger:YMThirdPlatformShareForQQFriend],
                                @"contentType":@"nil",
                                @"title":@"title",
                                @"imageUrl":@"http://ww1.sinaimg.cn/bmiddle/754e3dc7gw1e75xkgm3kqg206t03rtgh.gif",
                                @"resourceUrl":@"https://www.baidu.com",
                                @"contentText":@"description"};
    YMThirdPlatformShareEntity *entity = [[YMThirdPlatformShareEntity  alloc] initWithData:entityDic];
    [YMThirdPlatformTool shareWithEntity:entity
                                 success:^(YMThirdPlatformShareEntity *shareEntity) {
                                     YM_Log(@"this is qqFriendShare success");
                                 } failure:^(YMThirdPlatformShareEntity *entity, NSError *error) {
                                     YM_Log(@"this is qqFriendShare failure %@", error);
                                 } cancel:^(YMThirdPlatformShareEntity *entity){
                                     YM_Log(@"this is qqFriendShareCancel");
                                 }];
}

- (void)wxShareGif
{
    NSDictionary *entityDic = @{@"shareType":[NSNumber numberWithUnsignedInteger:YMThirdPlatformShareForWechatSession],
                                @"contentType":@"nil",
                                @"title":@"title",
                                @"imageUrl":@"http://ww1.sinaimg.cn/bmiddle/754e3dc7gw1e75xkgm3kqg206t03rtgh.gif",
                                @"resourceUrl":@"https://www.baidu.com",
                                @"contentText":@"description"};
    YMThirdPlatformShareEntity *entity = [[YMThirdPlatformShareEntity  alloc] initWithData:entityDic];
    [YMThirdPlatformTool shareWithEntity:entity
                                 success:^(YMThirdPlatformShareEntity *shareEntity) {
                                     YM_Log(@"this is wxTimelineShare success");
                                 } failure:^(YMThirdPlatformShareEntity *entity ,NSError *error) {
                                     YM_Log(@"this is wxTimelineShare failure %@", error);
                                 } cancel:^(YMThirdPlatformShareEntity *entity){
                                     YM_Log(@"this is wxTimelineShareCancel");
                                 }];
}

#pragma mark - getters

- (UIButton *)qqLoginButton
{
    if (_qqLoginButton == nil) {
        _qqLoginButton = [[UIButton alloc] init];
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
        _wxLoginButton = [[UIButton alloc] init];
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
        _wbLoginButton = [[UIButton alloc] init];
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
        _shareQQFriendButton = [[UIButton alloc] init];
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
        _shareQQZoneButton = [[UIButton alloc] init];
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
        _shareWXTimelineButton = [[UIButton alloc] init];
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
        _shareWXSessionButton = [[UIButton alloc] init];
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
        _shareWBButton = [[UIButton alloc] init];
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

- (UIButton *)shareQQFriendGifButton
{
    if (_shareQQFriendGifButton == nil) {
        _shareQQFriendGifButton = [[UIButton alloc] init];
        [_shareQQFriendGifButton setTitleColor:[UIColor blueColor]
                                      forState:UIControlStateNormal];
        [_shareQQFriendGifButton setTitle:@"分享Gif表情到QQ"
                                 forState:UIControlStateNormal];
        [_shareQQFriendGifButton addTarget:self
                                    action:@selector(qqShareGif)
                          forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _shareQQFriendGifButton;
}

- (UIButton *)shareWXSessionGifButton
{
    if (_shareWXSessionGifButton == nil) {
        _shareWXSessionGifButton = [[UIButton alloc] init];
        [_shareWXSessionGifButton setTitleColor:[UIColor blueColor]
                                      forState:UIControlStateNormal];
        [_shareWXSessionGifButton setTitle:@"分享Gif表情到微信"
                                  forState:UIControlStateNormal];
        [_shareWXSessionGifButton addTarget:self
                                     action:@selector(wxShareGif)
                           forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _shareWXSessionGifButton;
}

@end
