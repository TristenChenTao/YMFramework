//
//  UIButton+Networking.m
//  YuMiAssistant
//
//  Created by Tristen-MacBook on 7/25/14.
//
//

#import "UIButton+YMNetworking.h"

#import "UIButton+WebCache.h"

@implementation UIButton (YMNetworking)

- (void)ym_setImageWithURL:(NSString *)url
                  forState:(UIControlState)state
{
    [self ym_setImageWithURL:url
                    forState:state
            placeholderImage:nil
                   completed:nil];
}

- (void)ym_setImageWithURL:(NSString *)url
                  forState:(UIControlState)state
          placeholderImage:(UIImage *)placeholder
{
    
    [self ym_setImageWithURL:url
                    forState:state
            placeholderImage:placeholder
                   completed:nil];
}

- (void)ym_setImageWithURL:(NSString *)url
                  forState:(UIControlState)state
                 completed:(YMWebImageCompletionBlock)completedBlock
{
    [self ym_setImageWithURL:url
                    forState:state
            placeholderImage:nil
                   completed:completedBlock];
}

- (void)ym_setImageWithURL:(NSString *)url
                  forState:(UIControlState)state
          placeholderImage:(UIImage *)placeholder
                 completed:(YMWebImageCompletionBlock)completedBlock
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[SDWebImageDownloader sharedDownloader] setMaxConcurrentDownloads:5];
    });
    
    if (![self.sd_currentImageURL.absoluteString isEqualToString:url]) {
        [self sd_cancelImageLoadForState:state];
    }
    
    [self sd_setImageWithURL:[NSURL URLWithString:url]
                    forState:state
            placeholderImage:placeholder
                     options:SDWebImageRetryFailed |SDWebImageContinueInBackground | SDWebImageHighPriority
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if (error) {
                           //如果请求失败则清空缓存
                           [[NSURLCache sharedURLCache] removeAllCachedResponses];
                       }
                       
                       if (completedBlock) {
                           completedBlock(image, error, imageURL);
                       }
                   }];
}

@end
