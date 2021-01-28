//
//  SeedSlideControlAppearance.h
//  SeedSlideControl
//
//  Created by Hao on 2020/10/29.
//

#import <UIKit/UIKit.h>
#import "SeedSlideControlLoadingIndicator.h"


NS_ASSUME_NONNULL_BEGIN

/// 轮播图类型
typedef NS_ENUM(NSUInteger, SeedSlideControlStyle) {
    
    /// 轮播图类型-图文正常轮播
    SeedSlideControlStyleGraphic,
    /// 轮播图类型-图片缩放浏览
    SeedSlideControlStyleZoomable,
};

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

/// 轮播控件属性
@interface SeedSlideControlAppearance : NSObject

#pragma mark - 轮播属性

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
/// 轮播占位图
@property (nonatomic, strong, nullable) UIImage *s_placeholder;
/// 加载进度视图模式, 默认 SeedSlideControlLoadingProgressModePie
@property (nonatomic, assign) SeedSlideControlLoadingProgressMode s_progressMode;


#pragma mark - 图文正常轮播类型有效

/// 轮播图片填充模式
@property (nonatomic, assign) UIViewContentMode s_contentMode;
/// 是否只显示文本内容
@property (nonatomic, assign) BOOL s_onlyText;
/// 文本框背景色
@property (nonatomic, strong) UIColor *s_labelBackgroundColor;
/// 文本框文字颜色
@property (nonatomic, strong) UIColor *s_labelTextColor;
/// 文本框文字字体
@property (nonatomic, strong) UIFont *s_labelTextFont;
/// 文本框高度
@property (nonatomic, assign) CGFloat s_labelHeight;
/// 文本框文字对齐方式
@property (nonatomic, assign) NSTextAlignment s_labelTextAlignment;


#pragma mark - 图片缩放浏览类型有效

/// 最大缩放比例
@property (nonatomic, assign) CGFloat s_maximumZoomScale;

@end

NS_ASSUME_NONNULL_END
