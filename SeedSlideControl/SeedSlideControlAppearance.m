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
        
        //MARK:轮播属性
        // 轮播图类型
        self.s_style = SeedSlideControlStyleGraphic;
        // 轮播图是否可以滚动
        self.s_scrollEnabled = YES;
        // 轮播图是否无限循环
        self.s_endless = YES;
        // 自动轮播时间间隔
        self.s_timeInterval = 5.0f;
        // 轮播滚动方向, 默认 UICollectionViewScrollDirectionHorizontal
        self.s_scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 轮播占位图
        self.s_placeholder = nil;
        // 加载进度视图模式, 默认 SeedSlideControlLoadingProgressModePie
        self.s_progressMode = SeedSlideControlLoadingProgressModePie;
        
        
        //MARK: 图文正常轮播类型有效
        // 轮播图片填充模式
        self.s_contentMode = UIViewContentModeScaleAspectFit;
        // 是否只显示文本内容
        self.s_onlyText = NO;
        // 文本框背景色
        self.s_labelBackgroundColor = [UIColor clearColor];
        // 文本框文字颜色
        self.s_labelTextColor = [UIColor darkTextColor];
        // 文本框文字字体
        self.s_labelTextFont = [UIFont systemFontOfSize:14.0f];
        // 文本框高度
        self.s_labelHeight = 0.0f;
        // 文本框文字对齐方式
        self.s_labelTextAlignment = NSTextAlignmentLeft;
        
        
        //MARK: 图片缩放浏览类型有效
        // 最大缩放比例
        self.s_maximumZoomScale = 5.0f;
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
