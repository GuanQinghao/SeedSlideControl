//
//  SeedSlideControlAppearance.h
//  SeedSlideControl
//
//  Created by Hao on 2020/10/29.
//

#import <UIKit/UIKit.h>
#import "SeedSlideControlLoadingIndicator.h"


NS_ASSUME_NONNULL_BEGIN

/// 轮播控件类型
typedef NS_ENUM(NSUInteger, SeedSlideControlStyle) {
    
    /// 轮播控件类型-图文正常轮播
    SeedSlideControlStyleGraphic,
    /// 轮播控件类型-图片缩放浏览
    SeedSlideControlStyleZoomable,
};

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

/// 分页控件对齐方式
typedef NS_ENUM(NSUInteger, SeedPageControlAlignment) {
    
    /// 分页控件对齐方式-居左
    SeedPageControlAlignmentLeft,
    /// 分页控件对齐方式-居中
    SeedPageControlAlignmentCenter,
    /// 分页控件对齐方式-居右
    SeedPageControlAlignmentRight,
};

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

/// 轮播控件外观属性
@interface SeedSlideControlAppearance : NSObject

#pragma mark - 轮播控件属性

/// 轮播图类型, 默认图文正常轮播(SeedSlideControlStyleGraphic)
@property (nonatomic, assign) SeedSlideControlStyle s_style;
/// 轮播图是否可以滚动, 默认YES
@property (nonatomic, assign) BOOL s_scrollEnabled;
/// 轮播图是否无限循环, 默认YES
@property (nonatomic, assign) BOOL s_endless;
/// 自动轮播时间间隔(默认 5.0f秒, 不自动轮播设置为CGFLOAT_MAX)
@property (nonatomic, assign) CGFloat s_timeInterval;
/// 轮播滚动方向, 默认 UICollectionViewScrollDirectionHorizontal
@property (nonatomic, assign) UICollectionViewScrollDirection s_scrollDirection;
/// 轮播占位图, 默认 nil
@property (nonatomic, strong, nullable) UIImage *s_placeholder;
/// 加载进度视图模式, 默认 SeedSlideControlLoadingProgressModePie
@property (nonatomic, assign) SeedSlideControlLoadingProgressMode s_progressMode;

/// 是否显示分页控件, 默认 YES
@property (nonatomic, assign) BOOL s_showPageControl;
/// 单页是否自动隐藏分页控件, 默认 YES
@property (nonatomic, assign) BOOL s_autoHide;
/// 分页控件对齐方式, 默认 SeedPageControlAlignmentCenter
@property (nonatomic, assign) SeedPageControlAlignment s_alignment;
/// 分页控件偏移量, 默认 CGPointZero
@property (nonatomic, assign) CGPoint s_offset;


#pragma mark - 图文正常轮播类型有效

/// 轮播图片填充模式, 默认 UIViewContentModeScaleAspectFit
@property (nonatomic, assign) UIViewContentMode s_contentMode;
/// 是否只显示文本内容, 默认 NO
@property (nonatomic, assign) BOOL s_onlyText;
/// 文本框背景色, 默认 [UIColor clearColor]
@property (nonatomic, strong) UIColor *s_labelBackgroundColor;
/// 文本框文字颜色, 默认 [UIColor darkTextColor]
@property (nonatomic, strong) UIColor *s_labelTextColor;
/// 文本框文字字体, 默认 [UIFont systemFontOfSize:14.0f]
@property (nonatomic, strong) UIFont *s_labelTextFont;
/// 文本框文字对齐方式, 默认 NSTextAlignmentLeft
@property (nonatomic, assign) NSTextAlignment s_labelTextAlignment;


#pragma mark - 图片缩放浏览类型有效

/// 最大缩放比例, 默认 2.0f
@property (nonatomic, assign) CGFloat s_maximumZoomScale;

@end

NS_ASSUME_NONNULL_END
