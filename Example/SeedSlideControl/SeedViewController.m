//
//  SeedViewController.m
//  SeedSlideControl
//
//  Created by GuanQinghao on 04/22/2020.
//  Copyright (c) 2020 GuanQinghao. All rights reserved.
//

#import "SeedViewController.h"
#import "SeedCollectionViewCell.h"
#import <SeedSlideView.h>


@interface SeedViewController () <SeedSlideViewDelegate>

/// 默认轮播图
@property (nonatomic, strong) SeedSlideView *defaultSlideView;
/// 自定义视图轮播图
@property (nonatomic, strong) SeedSlideView *customSlideView;

/// 数据源
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation SeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.defaultSlideView];
    [self.view addSubview:self.customSlideView];
}

#pragma mark -- GQHSlideViewDelegate

/// 轮播图点击回调
/// @param slideView 轮播图
/// @param index 点击的索引值
- (void)s_slideView:(SeedSlideView *)slideView didSelectItemAtIndex:(NSInteger)index {
    
    if (slideView.tag == 0) {
        
        NSLog(@"点击了第%ld个", index);
    } else if (slideView.tag == 1) {
        
        NSLog(@"点击了第%ld个", index);
    }
}

/// 轮播图滚动回调
/// @param slideView 轮播图
/// @param index 滚动结束后的索引值
- (void)s_slideView:(SeedSlideView *)slideView didScrollToIndex:(NSInteger)index {
    
    if (slideView.tag == 0) {
        
        NSLog(@"滚动到第%ld个", index);
    } else if (slideView.tag == 1) {
        
        NSLog(@"滚动到第%ld个", index);
    }
}

/// 自定义轮播图cell类
/// @param slideView 轮播图
- (Class)s_customCollectionViewCellClassForSlideView:(SeedSlideView *)slideView {
    
    if ([slideView isEqual:self.customSlideView]) {
        
        return [SeedCollectionViewCell class];
    }
    
    return nil;
}

/// 自定义轮播图cell填充数据及其他设置
/// @param cell 自定义Cell
/// @param index 索引值
/// @param slideView 轮播图
- (void)s_setupCustomCell:(__kindof UICollectionViewCell *)cell forIndex:(NSInteger)index slideView:(SeedSlideView *)slideView {
    
    if ([slideView isEqual:self.customSlideView]) {
        
        SeedCollectionViewCell *customCell = (SeedCollectionViewCell *)cell;
        NSDictionary *data = self.dataArray[index];
        
        customCell.qh_imageView.image = [UIImage imageNamed:data[@"image"]];
        customCell.qh_title = data[@"text"];
        customCell.qh_titleLabelTextFont = [UIFont systemFontOfSize:20.0f];
        customCell.qh_titleLabelHeight = 100.0f;
        customCell.qh_titleLabelTextColor = UIColor.redColor;
    }
}

#pragma mark -- Getter

- (SeedSlideView *)defaultSlideView {
    
    if (!_defaultSlideView) {
        
        CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
        CGFloat height = CGRectGetHeight(UIScreen.mainScreen.bounds);
        
        _defaultSlideView = [[SeedSlideView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, MIN(width, height), 0.5f * MIN(width, height))];
        _defaultSlideView.tag = 0;
        _defaultSlideView.s_delegate = self;
        _defaultSlideView.s_imageArray = @[@"h1.jpg", @"h2.jpg", @"h3.jpg", @"h4.jpg"];
        
        SeedPageControlAppearance *appearance = [[SeedPageControlAppearance alloc] init];
        appearance.s_text = @"解";
        appearance.s_textFont = [UIFont systemFontOfSize:12.0f];
        appearance.s_textColor = UIColor.redColor;
        appearance.s_currentText = @"封";
        appearance.s_currentTextColor = UIColor.blackColor;
        appearance.s_style = SeedPageControlStyleGraphic;
        
        _defaultSlideView.s_appearance = appearance;
        
    }
    
    return _defaultSlideView;
}

- (SeedSlideView *)customSlideView {
    
    if (!_customSlideView) {
        
        CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
        CGFloat height = CGRectGetHeight(UIScreen.mainScreen.bounds);
        
        _customSlideView = [[SeedSlideView alloc] initWithFrame:CGRectMake(0.0f, 0.6f * MIN(width, height), MIN(width, height), 0.5f * MIN(width, height))];
        _customSlideView.tag = 1;
        _customSlideView.s_scrollDirection = UICollectionViewScrollDirectionVertical;
        _customSlideView.s_delegate = self;
        _customSlideView.s_data = self.dataArray;
        _customSlideView.s_timeInterval = 3.0;
    }
    
    return _customSlideView;
}

- (NSArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = @[@{@"image":@"h1.jpg",@"text":@"这里是占位文本，测试自定义视图轮播图"},
                       @{@"image":@"h2.jpg",@"text":@"这里是占位文本，测试自定义视图轮播图"},
                       @{@"image":@"h3.jpg",@"text":@"这里是占位文本，测试自定义视图轮播图"}];
    }
    
    return _dataArray;
}

@end
