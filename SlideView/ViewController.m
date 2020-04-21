//
//  ViewController.m
//  SlideView
//
//  Created by Mac on 2019/12/19.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#import "ViewController.h"
#import "GQHSlideView.h"
#import "GQHCollectionViewCell.h"

@interface ViewController () <GQHSlideViewDelegate>

/// 默认轮播图
@property (nonatomic, strong) GQHSlideView *defaultSlideView;

/// 自定义视图轮播图
@property (nonatomic, strong) GQHSlideView *customSlideView;

/// 数据源
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.defaultSlideView];
    
    [self.view addSubview:self.customSlideView];
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

- (GQHSlideView *)defaultSlideView {
    
    if (!_defaultSlideView) {
        
        CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
        CGFloat height = CGRectGetHeight(UIScreen.mainScreen.bounds);
        
        _defaultSlideView = [[GQHSlideView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, MIN(width, height), 0.5f * MIN(width, height))];
        _defaultSlideView.qh_imageArray = @[@"h1.jpg", @"h2.jpg", @"h3.jpg", @"h4.jpg"];
        _defaultSlideView.qh_delegate = self;
//        _defaultSlideView.qh_timeInterval = 5.0;
        
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
        
        _customSlideView = [[GQHSlideView alloc] init];
        _customSlideView.qh_scrollDirection = UICollectionViewScrollDirectionVertical;
        _customSlideView.frame = CGRectMake(0.0f, 0.6f * MIN(width, height), MIN(width, height), 0.5f * MIN(width, height));
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
