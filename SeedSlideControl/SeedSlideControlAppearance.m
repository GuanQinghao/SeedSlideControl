//
//  SeedSlideControlAppearance.m
//  SeedSlideControl
//
//  Created by Hao on 2020/10/29.
//

#import "SeedSlideControlAppearance.h"


@implementation SeedSlideControlAppearance

- (instancetype)init {
    
    if (self = [super init]) {
        
        //MARK:轮播控件属性
        // 轮播图类型
        _s_style = SeedSlideControlStyleGraphic;
        // 轮播图是否可以滚动
        _s_scrollEnabled = YES;
        // 轮播图是否无限循环
        _s_endless = YES;
        // 自动轮播时间间隔
        _s_timeInterval = 5.0f;
        // 轮播滚动方向
        _s_scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 轮播占位图
        _s_placeholder = nil;
        // 加载进度视图模式
        _s_progressMode = SeedSlideControlLoadingProgressModePie;
        
        // 是否显示分页控件
        _s_showPageControl = YES;
        // 单页是否自动隐藏分页控件
        _s_autoHide = YES;
        // 分页控件对齐方式
        _s_alignment = SeedPageControlAlignmentCenter;
        // 分页控件偏移量
        _s_offset = CGPointZero;
        
        //MARK: 图文正常轮播类型有效
        // 轮播图片填充模式
        _s_contentMode = UIViewContentModeScaleAspectFit;
        // 是否只显示文本内容
        _s_onlyText = NO;
        // 文本框背景色
        _s_labelBackgroundColor = [UIColor clearColor];
        // 文本框文字颜色
        _s_labelTextColor = [UIColor darkTextColor];
        // 文本框文字字体
        _s_labelTextFont = [UIFont systemFontOfSize:14.0f];
        // 文本框文字对齐方式
        _s_labelTextAlignment = NSTextAlignmentLeft;
        
        //MARK: 图片缩放浏览类型有效
        // 最大缩放比例
        _s_maximumZoomScale = 2.0f;
    }
    
    return self;
}

- (void)setS_style:(SeedSlideControlStyle)s_style {
    
    _s_style = s_style;
    
    if (SeedSlideControlStyleZoomable == _s_style) {
        
        _s_timeInterval = CGFLOAT_MAX;
    }
}

- (void)setS_timeInterval:(CGFloat)s_timeInterval {
    
    _s_timeInterval = s_timeInterval;
    
    if (SeedSlideControlStyleZoomable == _s_style) {
        
        _s_timeInterval = CGFLOAT_MAX;
    }
}

@end
