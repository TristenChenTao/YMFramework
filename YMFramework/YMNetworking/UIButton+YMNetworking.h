//
//  UIButton+Networking.h
//  YuMiAssistant
//
//  Created by Tristen-MacBook on 7/25/14.
//
//

#import <UIKit/UIKit.h>

#import "YMImageDownloader.h"

@interface UIButton (YMNetworking)

- (void)ymSetImageWithURL:(NSString *)url
                 forState:(UIControlState)state;

- (void)ymSetImageWithURL:(NSString *)url
                 forState:(UIControlState)state
         placeholderImage:(UIImage *)placeholder;

- (void)ymSetImageWithURL:(NSString *)url
                 forState:(UIControlState)state
                completed:(YMWebImageCompletionBlock)completedBlock;

- (void)ymSetImageWithURL:(NSString *)url
                 forState:(UIControlState)state
         placeholderImage:(UIImage *)placeholder
                completed:(YMWebImageCompletionBlock)completedBlock;

@end
