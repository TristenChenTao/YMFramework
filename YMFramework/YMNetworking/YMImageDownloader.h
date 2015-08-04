//
//  YMImageDownloader.h
//  YuMiAssistant
//
//  Created by Tristen-MacBook on 14/9/30.
//
//

#import <UIKit/UIKit.h>

typedef void(^YMWebImageCompletionBlock)(UIImage *image, NSError *error, NSURL *imageURL);

typedef void(^YMWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

typedef void(^YMImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

typedef void(^YMImageDownloaderCompletedBlock)(UIImage *image, NSData *data, NSError *error, BOOL finished);

@interface YMImageDownloader : NSObject

+ (void)downloadImageWithURL:(NSString *)url
                   completed:(YMImageDownloaderCompletedBlock)completedBlock;

+ (void)downloadImageWithURL:(NSString *)url
                    progress:(YMImageDownloaderProgressBlock)progressBlock
                   completed:(YMImageDownloaderCompletedBlock)completedBlock;

+ (BOOL)cachedImageExistsForURL:(NSString *)url;

@end
