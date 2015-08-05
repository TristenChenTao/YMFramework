//
//  UIImageView+YMNetworking.m
//  YuMiAssistant
//
//  Created by Tristen-MacBook on 7/25/14.
//
//

#import "UIImageView+YMNetworking.h"

#import "UIImageView+WebCache.h"

@implementation UIImageView (YMNetworking)

- (void)ym_setImageWithURL:(NSString *)url
{
    [self ym_setImageWithURL:url
            placeholderImage:nil
                    progress:nil
                   completed:nil];
}

- (void)ym_setImageWithURL:(NSString *)url
          placeholderImage:(UIImage *)placeholder
{
    [self ym_setImageWithURL:url
            placeholderImage:placeholder
                    progress:nil
                   completed:nil];
}

- (void)ym_setImageWithURL:(NSString *)url
                 completed:(YMWebImageCompletionBlock)completedBlock
{
    [self ym_setImageWithURL:url
            placeholderImage:nil
                    progress:nil
                   completed:completedBlock];
}

- (void)ym_setImageWithURL:(NSString *)url
          placeholderImage:(UIImage *)placeholder
                 completed:(YMWebImageCompletionBlock)completedBlock
{
    [self ym_setImageWithURL:url
            placeholderImage:placeholder
                    progress:nil
                   completed:completedBlock];
}

- (void)ym_setImageWithURL:(NSString *)url
          placeholderImage:(UIImage *)placeholder
                  progress:(YMWebImageDownloaderProgressBlock)progressBlock
                 completed:(YMWebImageCompletionBlock)completedBlock
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[SDWebImageDownloader sharedDownloader] setMaxConcurrentDownloads:5];
    });
    
    
    if (![self.sd_imageURL.absoluteString isEqualToString:url]) {
        [self sd_cancelCurrentImageLoad];
    }
    
    [self sd_setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:placeholder
                     options:SDWebImageRetryFailed |SDWebImageContinueInBackground | SDWebImageHighPriority
                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        if (progressBlock) {
                            progressBlock(receivedSize, expectedSize);
                        }
                    }
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