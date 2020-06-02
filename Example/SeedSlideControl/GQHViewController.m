//
//  GQHViewController.m
//  SeedSlideControl
//
//  Created by GuanQinghao on 04/22/2020.
//  Copyright (c) 2020 GuanQinghao. All rights reserved.
//

#import "GQHViewController.h"
#import "GQHSlideView.h"
#import "GQHCollectionViewCell.h"

@interface GQHViewController () <GQHSlideViewDelegate>

/// 默认轮播图
@property (nonatomic, strong) GQHSlideView *defaultSlideView;
/// 自定义视图轮播图
@property (nonatomic, strong) GQHSlideView *customSlideView;

/// 数据源
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation GQHViewController

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
- (void)qh_slideView:(GQHSlideView *)slideView didSelectItemAtIndex:(NSInteger)index {
    
    if (slideView.tag == 0) {
        
        NSLog(@"点击了第%ld个", index);
    } else if (slideView.tag == 1) {
        
        NSLog(@"点击了第%ld个", index);
    }
}

/// 轮播图滚动回调
/// @param slideView 轮播图
/// @param index 滚动结束后的索引值
- (void)qh_slideView:(GQHSlideView *)slideView didScrollToIndex:(NSInteger)index {
    
    if (slideView.tag == 0) {
        
        NSLog(@"滚动到第%ld个", index);
    } else if (slideView.tag == 1) {
        
        NSLog(@"滚动到第%ld个", index);
    }
}

/// 自定义轮播图cell类
- (Class)qh_customCollectionViewCellClassForSlideView:(GQHSlideView *)slideView {
    
    if ([slideView isEqual:self.customSlideView]) {
        
        return [GQHCollectionViewCell class];
    }
    
    return nil;
}

/// 自定义轮播图cell填充数据及其他设置
- (void)qh_setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index slideView:(GQHSlideView *)slideView {
    
    if ([slideView isEqual:self.customSlideView]) {
        
        GQHCollectionViewCell *customCell = (GQHCollectionViewCell *)cell;
        NSDictionary *data = self.dataArray[index];

        customCell.qh_imageView.image = [UIImage imageNamed:data[@"image"]];
        customCell.qh_title = data[@"text"];
        customCell.qh_titleLabelTextFont = [UIFont systemFontOfSize:20.0f];
        customCell.qh_titleLabelHeight = 100.0f;
        customCell.qh_titleLabelTextColor = UIColor.redColor;
    }
}

#pragma mark -- Getter

- (GQHSlideView *)defaultSlideView {
    
    if (!_defaultSlideView) {
        
        CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
        CGFloat height = CGRectGetHeight(UIScreen.mainScreen.bounds);
        
        _defaultSlideView = [[GQHSlideView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, MIN(width, height), 0.5f * MIN(width, height))];
        _defaultSlideView.qh_itemSize = CGSizeMake(200.0f, 0.5f * MIN(width, height));
        _defaultSlideView.qh_scale = 0.2f;
        _defaultSlideView.tag = 0;
        _defaultSlideView.qh_delegate = self;
        _defaultSlideView.qh_imageArray = @[@"h1.jpg", @"h2.jpg", @"h3.jpg", @"h4.jpg"];
        
        GQHPageControlAppearance *appearance = [[GQHPageControlAppearance alloc] init];
        appearance.qh_text = @"解";
        appearance.qh_textFont = [UIFont systemFontOfSize:12.0f];
        appearance.qh_textColor = UIColor.redColor;
        appearance.qh_currentText = @"封";
        appearance.qh_currentTextColor = UIColor.blackColor;
        appearance.qh_style = GQHPageControlStyleGraphic;
        
        _defaultSlideView.qh_appearance = appearance;
        
    }
    
    return _defaultSlideView;
}

- (GQHSlideView *)customSlideView {
    
    if (!_customSlideView) {
        
        CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
        CGFloat height = CGRectGetHeight(UIScreen.mainScreen.bounds);
        
        _customSlideView = [[GQHSlideView alloc] initWithFrame:CGRectMake(0.0f, 0.6f * MIN(width, height), MIN(width, height), 0.5f * MIN(width, height))];
        _customSlideView.tag = 1;
        _customSlideView.qh_scrollDirection = UICollectionViewScrollDirectionVertical;
        _customSlideView.qh_delegate = self;
        _customSlideView.qh_data = self.dataArray;
        _customSlideView.qh_timeInterval = 3.0;
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
