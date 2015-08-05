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

- (void)ym_setImageWithURL:(NSString *)url
                  forState:(UIControlState)state;

- (void)ym_setImageWithURL:(NSString *)url
                  forState:(UIControlState)state
          placeholderImage:(UIImage *)placeholder;

- (void)ym_setImageWithURL:(NSString *)url
                  forState:(UIControlState)state
                 completed:(YMWebImageCompletionBlock)completedBlock;

- (void)ym_setImageWithURL:(NSString *)url
                  forState:(UIControlState)state
          placeholderImage:(UIImage *)placeholder
                 completed:(YMWebImageCompletionBlock)completedBlock;

@end
