//
//  SeedSlideControlGraphicCollectionViewCell.h
//  SeedSlideControl
//
//  Created by Hao on 2020/11/19.
//  Copyright © 2020 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeedSlideControlLoadingIndicator.h"


NS_ASSUME_NONNULL_BEGIN

/// 内置图文单元格视图
@interface SeedSlideControlGraphicCollectionViewCell : UICollectionViewCell

/// 数据源
/// 图片资源:图片URL字符串(NSString)、图片对象(UIImage)、图片名称(NSString)或图片路径(NSString)
/// 文本资源:文本字符串(NSString)
/// 图片和文本资源:图片<image>和文字<text>字典(NSDictionary)
@property (nonatomic, weak) id s_asset;

#pragma mark - 轮播属性

/// 占位图
@property (nonatomic, strong, nullable) UIImage *s_placeholder;
/// 加载进度视图模式, 默认 SeedSlideControlLoadingProgressModePie
@property (nonatomic, assign) SeedSlideControlLoadingProgressMode s_progressMode;

#pragma mark - 图文正常轮播类型属性

/// 图片填充模式
@property (nonatomic, assign) UIViewContentMode s_contentMode;

/// 文本框背景色
@property (nonatomic, strong) UIColor *s_labelBackgroundColor;
/// 文本框文字颜色
@property (nonatomic, strong) UIColor *s_labelTextColor;
/// 文本框文字字体
@property (nonatomic, strong) UIFont *s_labelTextFont;
/// 文本框高度, 默认整体高度
@property (nonatomic, assign) CGFloat s_labelHeight DEPRECATED_MSG_ATTRIBUTE("TODO");
/// 文本框文字对齐方式
@property (nonatomic, assign) NSTextAlignment s_labelTextAlignment;

/// 是否只显示文本内容
@property (nonatomic, assign) BOOL s_onlyText;

@end

NS_ASSUME_NONNULL_END
