//
//  UIImageView+YMNetworking.h
//  YuMiAssistant
//
//  Created by Tristen-MacBook on 7/25/14.
//
//

#import <UIKit/UIKit.h>

#import "YMImageDownloader.h"

@interface UIImageView (YMNetworking)

- (void)ymSetImageWithURL:(NSString *)url;

- (void)ymSetImageWithURL:(NSString *)url
         placeholderImage:(UIImage *)placeholder;

- (void)ymSetImageWithURL:(NSString *)url
                completed:(YMWebImageCompletionBlock)completedBlock;

- (void)ymSetImageWithURL:(NSString *)url
         placeholderImage:(UIImage *)placeholder
                completed:(YMWebImageCompletionBlock)completedBlock;

- (void)ymSetImageWithURL:(NSString *)url
         placeholderImage:(UIImage *)placeholder
                 progress:(YMWebImageDownloaderProgressBlock)progressBlock
                completed:(YMWebImageCompletionBlock)completedBlock;

@end
