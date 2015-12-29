//
//  sdkCall.m
//  TestThreePlatformSDK
//
//  Created by yumi_iOS on 12/9/15.
//  Copyright © 2015 yumi_iOS. All rights reserved.
//

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentOAuth.h>

#import "YMSDKCall.h"
#import "WXApi.h"
#import "AFNetworking.h"
#import "WeiboSDK.h"


@interface YMSDKCall()
<QQApiInterfaceDelegate,
WXApiDelegate,
WeiboSDKDelegate,
WBHttpRequestDelegate,
TencentSessionDelegate,
TencentApiInterfaceDelegate,
TCAPIRequestDelegate>


@property (nonatomic, strong) LoginSuccessBlock qqLoginSuccess;
@property (nonatomic, strong) LoginFailureBlock qqLoginFailure;
@property (nonatomic, strong) LoginCancelBlock qqLoginCancel;

@property (nonatomic, strong) LoginSuccessBlock wxLoginSuccess;
@property (nonatomic, strong) LoginFailureBlock wxLoginFailure;
@property (nonatomic, strong) LoginCancelBlock wxLoginCancel;

@property (nonatomic, strong) LoginSuccessBlock wbLoginSuccess;
@property (nonatomic, strong) LoginFailureBlock wbLoginFailure;
@property (nonatomic, strong) LoginCancelBlock wbLoginCancel;

@property (nonatomic, strong) ShareSuccessBlock shareQQFriendSuccess;
@property (nonatomic, strong) ShareFailureBlock shareQQFriendFailure;
@property (nonatomic, strong) ShareCancelBlock shareQQFriendCancel;

@property (nonatomic, strong) ShareSuccessBlock shareQQZoneSuccess;
@property (nonatomic, strong) ShareFailureBlock shareQQZoneFailure;
@property (nonatomic, strong) ShareCancelBlock shareQQZoneCancel;

@property (nonatomic, strong) ShareSuccessBlock shareWechatSessionSuccess;
@property (nonatomic, strong) ShareFailureBlock shareWechatSessionFailure;
@property (nonatomic, strong) ShareCancelBlock shareWechatSessionCancel;

@property (nonatomic, strong) ShareSuccessBlock shareWechatTimelineSuccess;
@property (nonatomic, strong) ShareFailureBlock shareWechatTimelineFailure;
@property (nonatomic, strong) ShareCancelBlock shareWechatTimelineCancel;

@property (nonatomic, strong) ShareSuccessBlock shareWeiboSuccess;
@property (nonatomic, strong) ShareFailureBlock shareWeiboFailure;
@property (nonatomic, strong) ShareCancelBlock shareWeiboCancel;

@property (nonatomic, copy) NSString *qqAppId;
@property (nonatomic, copy) NSString *wxAppId;
@property (nonatomic, copy) NSString *wxSecret;
@property (nonatomic, copy) NSString *wbAppkey;
@property (nonatomic, copy) NSString *wbAppscret;
@property (nonatomic, copy) NSString *wbRedirectURL;

@property (nonatomic, strong) YMThirdPlatformUserInfo *wxUserInfo;
@property (nonatomic, strong) YMThirdPlatformUserInfo *wbUserInfo;

@property (nonatomic, strong) YMThirdPlatformShareEntity *qqFriendEntity;
@property (nonatomic, strong) YMThirdPlatformShareEntity *qqZoneEntity;
@property (nonatomic, strong) YMThirdPlatformShareEntity *wxSessionEntity;
@property (nonatomic, strong) YMThirdPlatformShareEntity *wxTimelineEntity;
@property (nonatomic, strong) YMThirdPlatformShareEntity *wbEntity;

@property (nonatomic, strong) TencentOAuth *oauth;

@end

@implementation YMSDKCall

#pragma mark - private

- (BOOL)getQQUserInfo
{
    return [self.oauth getUserInfo];
}

- (void)getWBUserInfo:(WBBaseResponse *)response
{
    WBAuthorizeResponse *resp = (WBAuthorizeResponse *)response;
    self.wbUserInfo.accessToken = resp.accessToken;
    self.wbUserInfo.userId = resp.userID;
    self.wbUserInfo.expired = resp.expirationDate;
    self.wbUserInfo.platformType = YMThirdPlatformForWeibo;
    
    __weak YMSDKCall *selfWeak= self;
    
    NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@", self.wbUserInfo.accessToken, self.wbUserInfo.userId];
    [[AFHTTPSessionManager manager] GET:url
                             parameters:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    NSDictionary *dic = (NSDictionary *)responseObject;
                                    selfWeak.wbUserInfo.nickname = dic[@"screen_name"];
                                    selfWeak.wbUserInfo.profileImageUrl = dic[@"profile_image_url"];
                                    selfWeak.wbUserInfo.homepage = nil;
                                    selfWeak.wbLoginSuccess(selfWeak.wbUserInfo);
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    selfWeak.wbLoginFailure(&error);
                                }];
}

- (void)WXUserInfoWithResp:(SendAuthResp *)resp
{
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", [YMSDKCall singleton].wxAppId, [YMSDKCall singleton].wxSecret, resp.code];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    __weak YMSDKCall *selfWeak = self;
    [manager GET:url
      parameters:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:nil];
             selfWeak.wxUserInfo.platformType = YMThirdPlatformForWechat;
             selfWeak.wxUserInfo.accessToken = content[@"access_token"];
             selfWeak.wxUserInfo.expired = content[@"expires_in"];
             NSString *userInfoURL = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", content[@"access_token"], content[@"openid"]];
             AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
             manager.responseSerializer = [AFHTTPResponseSerializer serializer];
             [manager GET:userInfoURL
               parameters:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      NSDictionary *UserInfocontent = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                              options:NSJSONReadingMutableContainers
                                                                                error:nil];
                      selfWeak.wxUserInfo.userId = UserInfocontent[@"openid"];
                      selfWeak.wxUserInfo.nickname = UserInfocontent[@"nickname"];
                      selfWeak.wxUserInfo.profileImageUrl = UserInfocontent[@"headimgurl"];
                      selfWeak.wxUserInfo.homepage = nil;
                      selfWeak.wxLoginSuccess(selfWeak.wxUserInfo);
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      selfWeak.wxLoginFailure(&error);
                  }];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             selfWeak.wxLoginFailure(&error);
         }];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            NSError *error = [NSError errorWithDomain:@"domain"
                                                 code:ErrorStateShareAppNotRegister
                                             userInfo:nil];
            if (self.shareQQZoneFailure) {
                self.shareQQZoneFailure(self.qqZoneEntity,&error);
                self.shareQQZoneFailure = nil;
            } else if (self.shareQQFriendFailure) {
                self.shareQQFriendFailure(self.qqFriendEntity,&error);
                self.shareQQFriendFailure = nil;
            }
        }
            break;
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            NSError *error = [NSError errorWithDomain:@"domain"
                                                 code:ErrorStateSharePrameError
                                             userInfo:nil];
            if (self.shareQQZoneFailure) {
                self.shareQQZoneFailure(self.qqZoneEntity,&error);
                self.shareQQZoneFailure = nil;
            } else if (self.shareQQFriendFailure) {
                self.shareQQFriendFailure(self.qqFriendEntity,&error);
                self.shareQQFriendFailure = nil;
            }
           
        }
            break;
        case EQQAPIQQNOTINSTALLED:
        {
            NSError *error = [NSError errorWithDomain:@"domain"
                                                 code:ErrorStateShareAppNotInstall
                                             userInfo:nil];
            if (self.shareQQZoneFailure) {
                self.shareQQZoneFailure(self.qqZoneEntity,&error);
                self.shareQQZoneFailure = nil;
            } else if (self.shareQQFriendFailure) {
                self.shareQQFriendFailure(self.qqFriendEntity,&error);
                self.shareQQFriendFailure = nil;
            }
            
        }
            break;
        case EQQAPIQQNOTSUPPORTAPI:
        {
            NSError *error = [NSError errorWithDomain:@"domain"
                                                 code:ErrorStateShareInterfaceNotSupport
                                             userInfo:nil];
            if (self.shareQQZoneFailure) {
                self.shareQQZoneFailure(self.qqZoneEntity,&error);
                self.shareQQZoneFailure = nil;
            } else if (self.shareQQFriendFailure) {
                self.shareQQFriendFailure(self.qqFriendEntity,&error);
                self.shareQQFriendFailure = nil;
            }
        }
            break;
        case EQQAPISENDFAILD:
        {
            NSError *error = [NSError errorWithDomain:@"domain"
                                                 code:ErrorStateShareSentFailure
                                             userInfo:nil];
            if (self.shareQQZoneFailure) {
                self.shareQQZoneFailure(self.qqZoneEntity,&error);
                self.shareQQZoneFailure = nil;
            } else if (self.shareQQFriendFailure) {
                self.shareQQFriendFailure(self.qqFriendEntity,&error);
                self.shareQQFriendFailure = nil;
            }
        }
            break;
        default:
        {
            NSError *error = [NSError errorWithDomain:@"domain"
                                                 code:-2002
                                             userInfo:nil];
            if (self.shareQQZoneFailure) {
                self.shareQQZoneFailure(self.qqZoneEntity,&error);
                self.shareQQZoneFailure = nil;
            } else if (self.shareQQFriendFailure) {
                self.shareQQFriendFailure(self.qqFriendEntity,&error);
                self.shareQQFriendFailure = nil;
            }
        }
            break;
    }
}

#pragma mark - public

+ (instancetype)singleton
{
    static YMSDKCall *sdkCall = nil;
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        sdkCall = [[YMSDKCall alloc] init];
    });
    
    return sdkCall;
}

- (void)qqLogout
{
    [self.oauth logout:self];
    [self registerQQAppId:self.qqAppId];
}

- (void)wbLogout
{
    [WeiboSDK logOutWithToken:self.wbUserInfo.accessToken
                     delegate:[YMSDKCall singleton]
                      withTag:nil];
}

- (void)qqLoginWithSuccess:(LoginSuccessBlock)success
                   failure:(LoginFailureBlock)failure
                    cancel:(LoginCancelBlock)cancel
{
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_IDOL,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_PIC_T,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            nil];

    [[[YMSDKCall singleton] oauth] authorize:permissions];
    
    self.qqLoginSuccess = success;
    self.qqLoginFailure = failure;
    self.qqLoginCancel = cancel;
}

- (void)wxLoginWithSuccess:(LoginSuccessBlock)success
                   failure:(LoginFailureBlock)failure
                    cancel:(LoginCancelBlock)cancel
{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"xx";
    [WXApi sendAuthReq:req
        viewController:nil
              delegate:self];
    
    self.wxLoginSuccess = success;
    self.wxLoginFailure = failure;
    self.wxLoginCancel = cancel;
}

- (void)wbLoginWithSuccess:(LoginSuccessBlock)success
                   failure:(LoginFailureBlock)failure
                    cancel:(LoginCancelBlock)cancel
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = self.wbRedirectURL;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
    
    self.wbLoginSuccess = success;
    self.wbLoginFailure = failure;
    self.wbLoginCancel = cancel;
}

- (void)registerQQAppId:(NSString *)appId
{
    _qqAppId = appId;
    self.oauth = [[TencentOAuth alloc] initWithAppId:appId
                                         andDelegate:self];
}

- (void)registerWXAppId:(NSString *)appId
            WXAppSecret:(NSString *)secret
{
    _wxAppId = appId;
    _wxSecret = secret;
    self.wxUserInfo = [[YMThirdPlatformUserInfo alloc] init];
    [WXApi registerApp:appId];
}

- (void)registerWBAppKey:(NSString *)appKey
                appScret:(NSString *)secret
             redirectURL:(NSString *)redirectURL
{
    _wbAppkey = appKey;
    _wbAppscret = secret;
    _wbRedirectURL = redirectURL;
    self.wbUserInfo = [[YMThirdPlatformUserInfo alloc] init];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:appKey];
}

- (void)shareWithEntity:(YMThirdPlatformShareEntity *)shareEntity
                success:(ShareSuccessBlock)success
                failure:(ShareFailureBlock)failure
                 cancel:(ShareCancelBlock)cancel
{
    switch (shareEntity.shareType)  {
        case YMThirdPlatformShareTypeForQQFriend:
        case YMThirdPlatformShareTypeForQQZone:
        {
            NSURL *previewURL = [NSURL URLWithString:shareEntity.imageURL];
            // 设置分享链接
            NSURL* url = [NSURL URLWithString:shareEntity.resourceURL];
            QQApiNewsObject* imgObj = [QQApiNewsObject objectWithURL:url
                                                               title:shareEntity.title
                                                         description:shareEntity.contentText
                                                     previewImageURL:previewURL];
            // 设置分享到QZone的标志位
            if (shareEntity.shareType == YMThirdPlatformShareTypeForQQZone) {
                self.qqZoneEntity = shareEntity;
                
                [imgObj setCflag: kQQAPICtrlFlagQZoneShareOnStart];
                
                self.shareQQZoneSuccess = success;
                self.shareQQZoneFailure = failure;
                self.shareQQZoneCancel = cancel;
                
                SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:imgObj];
                QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
                [self handleSendResult:sent];
            } else {
                self.qqFriendEntity = shareEntity;
                
                [imgObj setCflag:kQQAPICtrlFlagQQShare];
                
                self.shareQQFriendSuccess = success;
                self.shareQQFriendFailure = failure;
                self.shareQQFriendCancel = cancel;
                
                SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:imgObj];
                QQApiSendResultCode sent = [QQApiInterface sendReq:req];
                [self handleSendResult:sent];
            }
        }
            break;
        case YMThirdPlatformShareTypeForWechatSession:
        case YMThirdPlatformShareTypeForWechatTimeline:
        {
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            NSURL *url = [NSURL URLWithString:shareEntity.imageURL];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            
            webPageObject.webpageUrl = shareEntity.resourceURL;
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = shareEntity.title;
            message.description = shareEntity.contentText;
            message.mediaObject = webPageObject;
            [message setThumbImage:image];
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.message = message;
            if (shareEntity.shareType == YMThirdPlatformShareTypeForWechatSession) {
                self.wxSessionEntity = shareEntity;
                
                req.scene = WXSceneSession;
                self.shareWechatSessionSuccess = success;
                self.shareWechatSessionFailure = failure;
                self.shareWechatSessionCancel = cancel;
            } else {
                self.wxTimelineEntity = shareEntity;
                
                req.scene = WXSceneTimeline;
                self.shareWechatTimelineSuccess = success;
                self.shareWechatTimelineFailure = failure;
                self.shareWechatTimelineCancel = cancel;
            }
            
            [WXApi sendReq:req];
    
        }
            break;
        case YMThirdPlatformShareTypeForWeibo:
        {
            self.wbEntity = shareEntity;
            
            WBMessageObject *messageObject = [WBMessageObject message];
            WBImageObject *image = [WBImageObject object];
            image.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareEntity.imageURL]];
            messageObject.imageObject = image;
            messageObject.text = shareEntity.title;

            WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
            authRequest.redirectURI = self.wbRedirectURL;
            authRequest.scope = @"all";
            
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:messageObject
                                                                                          authInfo:authRequest
                                                                                      access_token:nil];
            self.shareWeiboSuccess = success;
            self.shareWeiboFailure = failure;
            self.shareWeiboCancel = cancel;
            [WeiboSDK sendRequest:request];
        }
            break;
        default:
            break;
    }
}

+ (BOOL)isQQInstall
{
    return [TencentOAuth iphoneQQInstalled];
}

+ (BOOL)isWechatInstall
{
    return [WXApi isWXAppInstalled];
}

+ (BOOL)isWbInstall
{
    return [WeiboSDK isWeiboAppInstalled];
}

+ (BOOL)handleURL:(NSURL *)url
{
    NSString *urlString = [url absoluteString];
    if ([urlString hasPrefix:@"tencent"]) {
        return [TencentOAuth HandleOpenURL:url] || [QQApiInterface handleOpenURL:url
                                                                        delegate:[YMSDKCall singleton]];
    } else if ([urlString hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url
                           delegate:[YMSDKCall singleton]];
    }

    else if ([urlString hasPrefix:@"wb"]) {
        return [WeiboSDK handleOpenURL:url
                              delegate:[YMSDKCall singleton]];
    } else
        return YES;
}

#pragma mark - TencentSessionDelegate

- (void)tencentDidLogin
{
    self.isLogin = YES;
    [self getQQUserInfo];
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    self.isLogin = NO;
    if (cancelled) {
        NSError *error = [NSError errorWithDomain:@"domain"
                                             code:-2001
                                         userInfo:nil];
        self.qqLoginCancel(&error);
    } else {
        NSError *error = [NSError errorWithDomain:@"domain"
                                             code:ErrorStateLoginNormalFailure
                                         userInfo:nil];
        self.qqLoginFailure(&error);
    }
}

- (void)tencentDidLogout
{
    self.isLogin = NO;
}

- (void)tencentDidNotNetWork
{
    self.isLogin = NO;
    NSError *error = [NSError errorWithDomain:@"domain"
                                         code:ErrorStateLoginNotNetWork
                                     userInfo:nil];
    self.qqLoginFailure(&error);
}

- (void)getUserInfoResponse:(APIResponse*) response
{
    if (response.retCode == 1) {
        NSError *error = [NSError errorWithDomain:@"domain"
                                             code:ErrorStateGetUserInfoFailure
                                         userInfo:nil];
        self.qqLoginFailure(&error);
        return;
    }
    
    NSDictionary *dic = response.jsonResponse;
    YMThirdPlatformUserInfo *userInfo = [[YMThirdPlatformUserInfo alloc] init];
    userInfo.platformType = YMThirdPlatformForQQ;
    userInfo.userId = [self oauth].openId;
    userInfo.nickname = dic[@"nickname"];
    userInfo.profileImageUrl = dic[@"figureurl_qq_1"];
    userInfo.accessToken = [self oauth].accessToken;
    userInfo.expired = [self oauth].expirationDate;
    userInfo.homepage = nil; //待定
    self.qqLoginSuccess(userInfo);
}

#pragma mark - WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    ////
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
        [self wbLoginAboutResp:response];
    } else if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        [self wbShareAboutResp:response];
    }
}

#pragma mark - QQApiInterfaceDelegate and WXApiDelegate

/**
 *  微信和QQ公用的回调
 */
- (void)onResp:(id)resp
{
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        QQBaseResp *qqResp = (QQBaseResp *)resp;
        if (qqResp.errorDescription) {
            if (self.shareQQZoneCancel) {
                self.shareQQZoneCancel(self.qqZoneEntity);
                self.shareQQZoneCancel = nil;
            } else if (self.shareQQFriendCancel) {
                self.shareQQFriendCancel(self.qqFriendEntity);
                self.shareQQFriendCancel = nil;
            }
        } else {
            if (self.shareQQZoneSuccess) {
                self.shareQQZoneSuccess(self.qqZoneEntity);
                self.shareQQZoneSuccess = nil;
            } else if (self.shareQQFriendSuccess) {
                self.shareQQFriendSuccess(self.qqFriendEntity);
                self.shareQQFriendSuccess = nil;
            }
        }
    } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
        [self wxShareAboutResp:messageResp];
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        [self wxLoginAboutResp:(SendAuthResp *)authResp];
    }
    
}

- (void)onReq:(QQBaseReq *)req
{
    //未用到，但是不写会警告
}

- (void)isOnlineResponse:(NSDictionary *)response
{
    //未用到，但是不写会警告
}

#pragma mark - WXCallBack

- (void)wxLoginAboutResp:(SendAuthResp *)resp
{
    if (resp.errCode == WXSuccess) {
        [self WXUserInfoWithResp:resp];
    } else if (resp.errCode == WXErrCodeCommon){
        //self.wxLoginFailure(@"普通错误类型");
    } else if (resp.errCode == WXErrCodeUserCancel){
        NSError *error = [NSError errorWithDomain:@"domain"
                                             code:-2001
                                         userInfo:nil];
        self.wxLoginCancel(&error);
    } else if (resp.errCode == WXErrCodeSentFail){
        NSError *error = [NSError errorWithDomain:@"domain"
                                             code:ErrorStateLoginNotNetWork
                                         userInfo:nil];
        self.wxLoginCancel(&error);
    } else if (resp.errCode == WXErrCodeAuthDeny){
        NSError *error = [NSError errorWithDomain:@"domain"
                                             code:ErrorStateLoginNormalFailure
                                         userInfo:nil];
        self.wxLoginCancel(&error);
    }
    
    self.wxLoginCancel = nil;
    self.wxLoginFailure = nil;
}

- (void)wxShareAboutResp:(SendMessageToWXResp *)resp
{
    if (resp.errCode == WXSuccess) {
        if (self.shareWechatSessionSuccess) {
            self.shareWechatSessionSuccess(self.wxSessionEntity);
        } else if (self.shareWechatTimelineSuccess) {
            self.shareWechatTimelineSuccess(self.wxTimelineEntity);
        }
    } else if (resp.errCode == WXErrCodeCommon){
        if (self.shareWechatSessionFailure) {
           // self.shareWechatSessionFailure(@"普通错误类型");
        } else if (self.shareWechatTimelineFailure) {
           // self.shareWechatTimelineFailure(@"普通错误类型");
        }
    } else if (resp.errCode == WXErrCodeUserCancel){
        if (self.shareWechatSessionCancel) {
            self.shareWechatSessionCancel(self.wxSessionEntity);
        } else if (self.shareWechatTimelineCancel) {
            self.shareWechatTimelineCancel(self.wxTimelineEntity);
        }
    } else if (resp.errCode == WXErrCodeSentFail){
        NSError *error = [NSError errorWithDomain:@"domain"
                                             code:ErrorStateShareSentFailure
                                         userInfo:nil];
        if (self.shareWechatSessionFailure) {
            self.shareWechatSessionFailure(self.wxSessionEntity, &error);
        } else if (self.shareWechatTimelineFailure) {
            self.shareWechatTimelineFailure(self.wxTimelineEntity, &error);
        }
    } else if (resp.errCode == WXErrCodeUnsupport){
        NSError *error = [NSError errorWithDomain:@"domain"
                                             code:ErrorStateShareInterfaceNotSupport
                                         userInfo:nil];
        if (self.shareWechatSessionFailure) {
            self.shareWechatSessionFailure(self.wxSessionEntity, &error);
        } else if (self.shareWechatTimelineFailure) {
            self.shareWechatTimelineFailure(self.wxTimelineEntity, &error);
        }
    }
    
    self.shareWechatSessionSuccess = nil;
    self.shareWechatTimelineSuccess = nil;
    self.shareWechatTimelineFailure = nil;
    self.shareWechatSessionFailure = nil;
    self.shareWechatTimelineCancel = nil;
    self.shareWechatSessionCancel = nil;
}

#pragma mark - WBCallBack

- (void)wbLoginAboutResp:(WBBaseResponse *)resp
{
    if (resp.statusCode == WeiboSDKResponseStatusCodeSuccess) {
        [self getWBUserInfo:resp];
    } else if (resp.statusCode == WeiboSDKResponseStatusCodeUserCancel) {
        NSError *error = [NSError errorWithDomain:@"domain"
                                             code:-2001
                                         userInfo:nil];
        self.wbLoginCancel(&error);
    } else if (resp.statusCode == WeiboSDKResponseStatusCodeAuthDeny) {
        NSError *error = [NSError errorWithDomain:@"domain"
                                             code:ErrorStateLoginNormalFailure
                                         userInfo:nil];
        self.wbLoginFailure(&error);
    } else if (resp.statusCode == WeiboSDKResponseStatusCodeSentFail) {
        NSError *error = [NSError errorWithDomain:@"domain"
                                             code:ErrorStateLoginNotNetWork
                                         userInfo:nil];
        self.wbLoginFailure(&error);
    } else if (resp.statusCode == WeiboSDKResponseStatusCodeAuthDeny) {
        NSError *error = [NSError errorWithDomain:@"domain"
                                             code:ErrorStateLoginNormalFailure
                                         userInfo:nil];
        self.wxLoginFailure(&error);
    }
    
    self.wbLoginCancel = nil;
    self.wbLoginFailure = nil;
}

- (void)wbShareAboutResp:(WBBaseResponse *)resp
{
    if (resp.statusCode == WeiboSDKResponseStatusCodeSuccess) {
        self.shareWeiboSuccess(self.wbEntity);
    } else if (resp.statusCode == WeiboSDKResponseStatusCodeUserCancel) {
        self.shareWeiboCancel(self.wbEntity);
    } else if (resp.statusCode == WeiboSDKResponseStatusCodeSentFail) {
        NSError *error = [NSError errorWithDomain:@"domain"
                                             code:ErrorStateShareSentFailure
                                         userInfo:nil];
        self.shareWeiboFailure(self.wbEntity,&error);
    } else if (resp.statusCode == WeiboSDKResponseStatusCodeShareInSDKFailed) {
        NSError *error = [NSError errorWithDomain:@"domain"
                                             code:ErrorStateShareNormalFailure
                                         userInfo:nil];
        self.shareWeiboFailure(self.wbEntity,&error);
    } else if (resp.statusCode == WeiboSDKResponseStatusCodeUnsupport) {
        NSError *error = [NSError errorWithDomain:@"domain"
                                             code:ErrorStateShareInterfaceNotSupport
                                         userInfo:nil];
       self.shareWeiboFailure(self.wbEntity,&error);
    }
    
    self.shareWeiboSuccess = nil;
    self.shareWeiboCancel = nil;
    self.wbLoginFailure = nil;
}
                
@end
