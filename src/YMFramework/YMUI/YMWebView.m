//
//  YMWebView.m
//  YuMiAssistant
//
//  Created by Tristen-MacBook on 8/11/14.
//
//

#import "YMWebView.h"
#import "NSString+YMAdditions.h"
#import "YMHTTPManager.h"
#import "YMUI.h"
#import "UIView+YMFrameAdditions.h"
#import "YMImageDownloader.h"
#import "MJRefresh.h"
#import "UIFont+YMFontSizeAdditions.h"
#import "UIColor+YMAdditions.h"

@interface YMWebView()
<UIWebViewDelegate,
UIActionSheetDelegate,
UIGestureRecognizerDelegate
>

@property (nonatomic, assign) BOOL             savingImage;
@property (nonatomic, copy  ) NSString         *savedImageURL;
@property (nonatomic, weak  ) UIViewController *containerVC;

@end

@implementation YMWebView

static YMWebViewShouldStartHandler kHandler;

#pragma mark - public methods

+(void)loadGlobalShouldStartHandler:(YMWebViewShouldStartHandler)handler
{
    kHandler = handler;
}

- (instancetype)initWithContainerVC:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        
        __unsafe_unretained YMWebView *webView = self;
        webView.delegate = self;
        
        webView.allowsInlineMediaPlayback = YES;
        webView.backgroundColor = [UIColor whiteColor];
        webView.containerVC = viewController;
        
        
        // 添加下拉刷新控件
        [self addHeader];
        
        //添加长按手势获取图片
        [self addLongPressRecognizer];
    }
    return self;
}

- (void)loadRequest:(NSURLRequest *)request
{
    [self.scrollView.mj_header beginRefreshing];
    [super loadRequest:request];
}

- (void)addHeader
{
    __unsafe_unretained YMWebView *webView = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [webView reload];
    }];
    
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置文字
//    [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
//    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
//    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont ym_standFontOfLevel:3];
    // 设置颜色
    header.stateLabel.textColor = [UIColor ym_colorWithHexString:@"8995b0"];

    self.scrollView.mj_header = header;
}

#pragma mark - private methods

- (void)addLongPressRecognizer
{
    UILongPressGestureRecognizer *longTapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                    action:@selector(handleLongPressTap:)];
    [longTapRecognizer setDelegate:self];
    [self addGestureRecognizer:longTapRecognizer];
}

- (BOOL)isSameURLWithRequest:(NSURLRequest *)request
{
    NSString *currentURL = self.request.URL.absoluteString;
    NSString *newURL = request.URL.absoluteString;
    
    if (currentURL && [currentURL rangeOfString:newURL options:NSCaseInsensitiveSearch].location != NSNotFound) {
        return YES;
    }
    
    return NO;
}

#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (_ym_Delegate && [_ym_Delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_ym_Delegate webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView.scrollView.mj_header endRefreshing];
    
    if (_ym_Delegate && [_ym_Delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_ym_Delegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [webView.scrollView.mj_header endRefreshing];
    
    if (_ym_Delegate && [_ym_Delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_ym_Delegate webView:webView
             didFailLoadWithError:error];
    }
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
//    if ([self isSameURLWithRequest:request]) {
//        return NO;
//    }
    
    if (_savingImage) {
        return NO;
    }
    
    if (kHandler(webView, _containerVC, request, navigationType) == NO) {
        return NO;
    }
    
    BOOL bLoadRequest = YES; //等于YES表示还是没有经过处理
    
    if (_ym_Delegate && [_ym_Delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        bLoadRequest = [_ym_Delegate webView:self
                      shouldStartLoadWithRequest:request
                                  navigationType:navigationType];
    }
    
    return bLoadRequest;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [super scrollViewWillBeginDragging:scrollView];
    
    if (_ym_Delegate && [_ym_Delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [_ym_Delegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    
    if (_ym_Delegate && [_ym_Delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_ym_Delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [super scrollViewDidEndDecelerating:scrollView];
    
    if (_ym_Delegate && [_ym_Delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [_ym_Delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
    if (_ym_Delegate && [_ym_Delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [_ym_Delegate scrollViewDidEndDragging:scrollView
                                    willDecelerate:decelerate];
    }
}


#pragma mark - UILongPressGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handleLongPressTap:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint touchPoint = [gestureRecognizer locationInView:self];
        if (touchPoint.y <= (self.ym_Y + self.ym_Height)) {
            touchPoint.y -=kYm_NavgationBarWithStatusHeight;
            NSString *imageURLString = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
            _savedImageURL = [self stringByEvaluatingJavaScriptFromString:imageURLString];
            if ([NSString ym_isContainString:_savedImageURL]) {
                _savingImage = YES;
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                         delegate:self
                                                                cancelButtonTitle:@"取消"
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:nil, nil];
                [actionSheet addButtonWithTitle:@"保存图片"];
                [actionSheet showInView:self];
            }
        }
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            if (buttonIndex == 0) {
                _savingImage = NO;
            }
            break;
        case 1: {
            [YMImageDownloader downloadImageWithURL:_savedImageURL
                                          completed:^(UIImage *image, NSError *error, BOOL finished, NSURL *imageURL) {
                                              UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                                              _savingImage = NO;
                                          }];
        }
            break;
        default:
            break;
    }
}

- (void)image:(UIImage *)image
didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo {
    
    if (!error) {
        [[[UIAlertView alloc] initWithTitle:@"保存成功!"
                                    message:@"已保存到相册"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"保存失败"
                                    message:@"不能保存到相册"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}


@end