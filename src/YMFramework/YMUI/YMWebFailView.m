//
//  YMWebFailView.m
//  YMFramework
//
//  Created by TristenChen on 16/5/25.
//  Copyright © 2016年 cornapp. All rights reserved.
//

#import "YMWebFailView.h"

#import "Masonry.h"
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
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@(kYm_ScreenWidth / 2));
        make.top.equalTo(self.mas_top).offset(kYm_ScreenHeight * 0.219);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@(kYm_ScreenWidth / 2));
        make.top.equalTo(self.logoImageView.mas_bottom).offset(kYm_ScreenHeight * 0.036);
    }];
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
