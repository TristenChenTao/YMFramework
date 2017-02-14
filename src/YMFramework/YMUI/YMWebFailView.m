//
//  YMWebFailView.m
//  YMFramework
//
//  Created by TristenChen on 16/5/25.
//  Copyright © 2016年 cornapp. All rights reserved.
//

#import "YMWebFailView.h"

#import "YMUI.h"
#import "UIColor+YMAdditions.h"
#import "UIFont+YMFontSizeAdditions.h"
#import "NSBundle+YMAdditions.h"
#import "YMDeviceInfo.h"

@interface YMWebFailView()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation YMWebFailView

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.logoImageView];
    [self addSubview:self.tipLabel];
    
    [self setupViewLayout];
    
    return self;
}

- (void)setupViewLayout
{
    CGPoint center = CGPointMake(kYm_ScreenWidth / 2, 0);
    self.logoImageView.center = center;
    self.logoImageView.frame = CGRectMake(self.logoImageView.frame.origin.x, kYm_ScreenHeight * 0.219, self.logoImageView.frame.size.width, self.logoImageView.frame.size.height);
    
    self.tipLabel.center = center;
    float y = self.logoImageView.frame.origin.y + self.logoImageView.frame.size.height;
    self.tipLabel.frame = CGRectMake(self.tipLabel.frame.origin.x, y, self.tipLabel.frame.size.width, self.tipLabel.frame.size.height);
    
}

#pragma mark - setter and getter

- (UIImageView *)logoImageView
{
    if (_logoImageView == nil) {
        
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        
        NSString *imageName = kYm_iPhone6Plus ? @"WebFail@3x" : @"WebFail@2x";
    
        UIImage *image = [UIImage imageWithContentsOfFile:[bundle ym_pathForResource:imageName
                                                                              ofType:@"png"
                                                                         inDirectory:@"/WebView"]];
        

        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = image;
    }
    
    return _logoImageView;
}

- (UILabel *)tipLabel
{
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"网络连接失败";
        _tipLabel.textColor = [UIColor ym_colorWithHexString:@"828EA8"];
        _tipLabel.font = [UIFont ym_standFontOfLevel:3];
    }
    
    return _tipLabel;
}

@end
