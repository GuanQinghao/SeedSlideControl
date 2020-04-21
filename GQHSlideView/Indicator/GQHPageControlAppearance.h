//
//  GQHPageControlAppearance.h
//  Seed
//
//  Created by Mac on 2019/10/16.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 分页控件对齐方式
 
 - GQHPageControlAlignmentLeft: 分页控件居左
 - GQHPageControlAlignmentCenter: 分页控件居中
 - GQHPageControlAlignmentRight: 分页控件居右
 */
typedef NS_ENUM(NSUInteger, GQHPageControlAlignment) {
    
    GQHPageControlAlignmentLeft,
    GQHPageControlAlignmentCenter,
    GQHPageControlAlignmentRight,
};


/**
 分页控件样式
 
 - GQHPageControlStyleClassic: 系统自带经典样式
 - GQHPageControlStyleGraphic: 图文样式
 - GQHPageControlStyleTextual: 标签样式
 */
typedef NS_ENUM(NSUInteger, GQHPageControlStyle) {
    
    GQHPageControlStyleClassic,
    GQHPageControlStyleGraphic,
    GQHPageControlStyleTextual,
};


NS_ASSUME_NONNULL_BEGIN

@interface GQHPageControlAppearance : NSObject

#pragma mark - 轮播图属性

/// 分页控件对齐方式
@property (nonatomic, assign) GQHPageControlAlignment qh_alignment;
/// 分页控件偏移量
@property (nonatomic, assign) CGPoint qh_pageControlOffset;


#pragma mark - 分页控件属性

/// 分页控件样式
@property (nonatomic, assign) GQHPageControlStyle qh_style;
/// 页码指示器之间的水平间距
@property (nonatomic, assign) CGFloat qh_spacing;
/// 单页是否隐藏分页控件
@property (nonatomic, assign) BOOL qh_hidesForSinglePage;
/// 是否显示分页控件
@property (nonatomic, assign) BOOL qh_showPageControl;


#pragma mark - 页码指示器属性

/// 页码指示器大小
@property (nonatomic, assign) CGSize qh_size;
/// 页码指示器背景色
@property (nonatomic, strong) UIColor *qh_backgroundColor;
/// 页码指示器图片
@property (nonatomic, strong) UIImage *qh_image;
/// 页码指示器文字颜色
@property (nonatomic, strong) UIColor *qh_textColor;
/// 页码指示器文字字体
@property (nonatomic, strong) UIFont *qh_textFont;
/// 页码指示器文字内容
@property (nonatomic, strong) NSString *qh_text;

/// 当前页码指示器大小
@property (nonatomic, assign) CGSize qh_currentSize;
/// 当前页码指示器背景色
@property (nonatomic, strong) UIColor *qh_currentBackgroundColor;
/// 当前页码指示器图片
@property (nonatomic, strong) UIImage *qh_currentImage;
/// 当前页码指示器文字颜色
@property (nonatomic, strong) UIColor *qh_currentTextColor;
/// 当前页码指示器文字字体
@property (nonatomic, strong) UIFont *qh_currentTextFont;
/// 当前页码指示器文字内容
@property (nonatomic, strong) NSString *qh_currentText;

@end

NS_ASSUME_NONNULL_END
