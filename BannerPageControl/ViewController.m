//
//  ViewController.m
//  BannerPageControl
//
//  Created by 不明下落 on 2019/7/12.
//  Copyright © 2019 不明下落. All rights reserved.
//

#import "ViewController.h"
#import "Banner/AutoBannerScrollView.h"
#import <Masonry.h>
#import "Configuration.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSubview];
}

- (void)createSubview {
    AutoBannerScrollView *banner = [[AutoBannerScrollView alloc] initWithImageNames:@[@"banner_Default",@"banner_Default",@"banner_Default",@"banner_Default"] clickBlock:^(NSInteger index) {
        
    }];
    [self.view addSubview:banner];
    [banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(40);
        make.right.left.mas_offset(0);
        make.height.equalTo(@(150*WIDTHRADIUS+25));
    }];
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = 4;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self.view addSubview:pageControl];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(banner.mas_bottom).offset(80);
        make.right.left.mas_offset(0);
        make.height.equalTo(@(50));
    }];
    [pageControl setValue:[UIImage imageNamed:@"banner_select"] forKeyPath:@"_currentPageImage"];
    [pageControl setValue:[UIImage imageNamed:@"normal"] forKeyPath:@"_pageImage"];
}


@end
