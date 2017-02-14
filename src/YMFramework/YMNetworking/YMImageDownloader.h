//
//  YMImageDownloader.h
//  YuMiAssistant
//
//  Created by Tristen-MacBook on 14/9/30.
//
//

#import <UIKit/UIKit.h>

typedef void(^YMWebImageCompletionBlock)(UIImage *image, NSError *error, NSURL *imageURL);

typedef void(^YMWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL);

typedef void(^YMImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

typedef void(^YMImageDownloaderCompletedBlock)(UIImage *image, NSError *error, BOOL finished, NSURL *imageURL);

@interface YMImageDownloader : NSObject

+ (void)downloadImageWithURL:(NSString *)url
                   completed:(YMImageDownloaderCompletedBlock)completedBlock;

+ (void)downloadImageWithURL:(NSString *)url
                    progress:(YMImageDownloaderProgressBlock)progressBlock
                   completed:(YMImageDownloaderCompletedBlock)completedBlock;

+ (void)cachedImageExistsForURL:(NSString *)url
                     completion:(void (^)(BOOL isInCache))completion;

@end
