//
//  SeedViewController.m
//  SeedSlideControl
//
//  Created by GuanQinghao on 04/22/2020.
//  Copyright (c) 2020 GuanQinghao. All rights reserved.
//

#import "SeedViewController.h"
#import "SeedCollectionViewCell.h"
#import <SeedSlideControl.h>


@interface SeedViewController () <SeedSlideControlDelegate>

/// 默认轮播图
@property (nonatomic, strong) SeedSlideControl *defaultSlideView;

@end

@implementation SeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.defaultSlideView];
}

#pragma mark -- SeedSlideControlDelegate

#pragma mark -- Getter

- (SeedSlideControl *)defaultSlideView {
    
    if (!_defaultSlideView) {
        
        CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
        CGFloat height = CGRectGetHeight(UIScreen.mainScreen.bounds);
        
        _defaultSlideView = [[SeedSlideControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
        _defaultSlideView.s_delegate = self;
        _defaultSlideView.s_dataSource = @[
            @"h1.jpg",
            @"http://172.16.5.37:8930/group1/M01/01/9B/rBAFJWAPigGAJAE-AA4v1UFARsU285.png",
            @"h3.jpg",
            @"h4.jpg"];
        
        SeedSlideControlAppearance *appearance = [[SeedSlideControlAppearance alloc] init];
        appearance.s_style = SeedSlideControlStyleZoomable;
//        appearance.s_style = SeedPageControlStyleGraphic;
        appearance.s_endless = YES;
        _defaultSlideView.s_slideControlAppearance = appearance;
        
        SeedPageControlAppearance *pageControlAppearance = [[SeedPageControlAppearance alloc] init];
        pageControlAppearance.s_style = SeedPageControlStyleTextual;
        pageControlAppearance.s_size = CGSizeMake(60.0f, 40.0f);
        pageControlAppearance.s_backgroundColor = UIColor.grayColor;
        _defaultSlideView.s_pageControlAppearance = pageControlAppearance;
    }
    
    return _defaultSlideView;
}

@end
