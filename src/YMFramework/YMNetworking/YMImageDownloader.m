//
//  YMImageDownloader.m
//  YuMiAssistant
//
//  Created by Tristen-MacBook on 14/9/30.
//
//

#import "YMImageDownloader.h"

#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"

@implementation YMImageDownloader

+ (void)downloadImageWithURL:(NSString *)url
                   completed:(YMImageDownloaderCompletedBlock)completedBlock
{
    [self downloadImageWithURL:url
                      progress:nil
                     completed:completedBlock];
}

+ (void)downloadImageWithURL:(NSString *)url
                    progress:(YMImageDownloaderProgressBlock)progressBlock
                   completed:(YMImageDownloaderCompletedBlock)completedBlock
{
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:url] options:0
                                               progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                                   if(progressBlock) {
                                                       progressBlock(receivedSize,expectedSize);
                                                   }
                                               } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                                   if (completedBlock) {
                                                       completedBlock(image,error,finished,imageURL);
                                                   }
                                               }];
}

+ (void)cachedImageExistsForURL:(NSString *)url
 completion:(void (^)(BOOL isInCache))completion
{
    [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:url]
                                                    completion:completion];
}

@end
