//
//  SeedPageControlAppearance.h
//  SeedSlideControl
//
//  Created by Hao on 2020/10/29.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

/// 分页控件样式
typedef NS_ENUM(NSUInteger, SeedPageControlStyle) {
    
    /// 分页控件样式-系统自带经典样式
    SeedPageControlStyleClassic,
    /// 分页控件样式-图文样式
    SeedPageControlStyleGraphic,
    /// 分页控件样式-标签样式
    SeedPageControlStyleTextual,
};

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

@interface SeedPageControlAppearance : NSObject

#pragma mark - 分页控件属性

/// 分页控件样式, 默认 SeedPageControlStyleClassic
@property (nonatomic, assign) SeedPageControlStyle s_style;
/// 页码指示器之间的水平间距, 默认 8.0f
@property (nonatomic, assign) CGFloat s_spacing;

#pragma mark - 页码指示器属性

/// 页码指示器大小, 默认 {10.0f,10.0f}
@property (nonatomic, assign) CGSize s_size;
/// 页码指示器背景色, 默认 [UIColor lightGrayColor]
@property (nonatomic, strong) UIColor *s_backgroundColor;
/// 页码指示器图片, 默认 nil
@property (nonatomic, strong) UIImage *s_image;
/// 页码指示器文字颜色, 默认 [UIColor darkTextColor]
@property (nonatomic, strong) UIColor *s_textColor;
/// 页码指示器文字字体, 默认 [UIFont systemFontOfSize:10.0f]
@property (nonatomic, strong) UIFont *s_textFont;
/// 页码指示器文字内容
@property (nonatomic, strong) NSString *s_text;

/// 当前页码指示器大小, 默认 {10.0f,10.0f}
@property (nonatomic, assign) CGSize s_currentSize;
/// 当前页码指示器背景色, 默认 [UIColor lightGrayColor]
@property (nonatomic, strong) UIColor *s_currentBackgroundColor;
/// 当前页码指示器图片, 默认 nil
@property (nonatomic, strong) UIImage *s_currentImage;
/// 当前页码指示器文字颜色, 默认 [UIColor darkTextColor]
@property (nonatomic, strong) UIColor *s_currentTextColor;
/// 当前页码指示器文字字体, 默认 [UIFont systemFontOfSize:10.0f]
@property (nonatomic, strong) UIFont *s_currentTextFont;
/// 当前页码指示器文字内容
@property (nonatomic, strong) NSString *s_currentText;

@end

NS_ASSUME_NONNULL_END
