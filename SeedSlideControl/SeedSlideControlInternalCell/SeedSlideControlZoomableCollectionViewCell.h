//
//  SeedSlideControlZoomableCollectionViewCell.h
//  SeedSlideControl
//
//  Created by Hao on 2021/1/27.
//  Copyright © 2021 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeedSlideControlLoadingIndicator.h"


NS_ASSUME_NONNULL_BEGIN

/// 内置可缩放单元格视图
@interface SeedSlideControlZoomableCollectionViewCell : UICollectionViewCell

/// 图片资源:图片URL字符串(NSString)、图片对象(UIImage)、图片名称(NSString)或图片路径(NSString)
@property (nonatomic, weak) id s_asset;

#pragma mark - 轮播属性

/// 占位图
@property (nonatomic, strong) UIImage *s_placeholder;
/// 加载进度视图模式, 默认 SeedSlideControlLoadingProgressModePie
@property (nonatomic, assign) SeedSlideControlLoadingProgressMode s_progressMode;

#pragma mark - 图片缩放浏览类型属性
/// 最大缩放比例
@property (nonatomic, assign) CGFloat s_maximumZoomScale;
/// 视图单击回调
@property (nonatomic, copy) void (^s_clikc)(id _Nullable sender);

/// 缩放视图
/// @param scale 缩放比例
- (void)s_zoomWith:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
