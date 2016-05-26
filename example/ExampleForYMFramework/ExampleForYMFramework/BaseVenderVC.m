//
//  BaseVenderVC.m
//  ExampleForYMFramework
//
//  Created by TristenChen on 16/5/25.
//  Copyright © 2016年 yumi. All rights reserved.
//

#import "BaseVenderVC.h"
#import "Masonry.h"
#import "Aspects.h"

@interface BaseVenderVC()

@end


@implementation BaseVenderVC

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self testMasonry];
    
    [self testAspects];

    [super viewDidLoad];
    
}

- (void)testMasonry
{
    UILabel *viewForMasonry = [[UILabel alloc] init];
    viewForMasonry.text = @"测试Masonry";

    
    [self.view addSubview:viewForMasonry];
    
    [viewForMasonry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 50));
        make.top.equalTo(@20);
        make.centerX.equalTo(self.view);
    }];
}

- (void)testAspects
{
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> info, BOOL animated) {
                                   UIViewController *controller = [info instance];
                                   controller.view.backgroundColor = [UIColor grayColor];
                               } error:NULL];}

@end
