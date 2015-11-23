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

- (void)ym_setImageWithURL:(NSString *)url;

- (void)ym_setImageWithURL:(NSString *)url
          placeholderImage:(UIImage *)placeholder;

- (void)ym_setImageWithURL:(NSString *)url
                 completed:(YMWebImageCompletionBlock)completedBlock;

- (void)ym_setImageWithURL:(NSString *)url
          placeholderImage:(UIImage *)placeholder
                 completed:(YMWebImageCompletionBlock)completedBlock;

- (void)ym_setImageWithURL:(NSString *)url
          placeholderImage:(UIImage *)placeholder
                  progress:(YMWebImageDownloaderProgressBlock)progressBlock
                 completed:(YMWebImageCompletionBlock)completedBlock;

@end
