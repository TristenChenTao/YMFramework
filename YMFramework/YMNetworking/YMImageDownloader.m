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
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url]
                                                          options:SDWebImageDownloaderLowPriority
                                                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                             if(progressBlock) {
                                                                 progressBlock(receivedSize,expectedSize);
                                                             }
                                                         }
                                                        completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                            if (completedBlock) {
                                                                completedBlock(image,data,error,finished);
                                                            }
                                                        }];
}

+ (BOOL)cachedImageExistsForURL:(NSString *)url
{
    return [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:url]];
}

@end
