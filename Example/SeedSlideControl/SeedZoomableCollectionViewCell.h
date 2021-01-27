//
//  SeedZoomableCollectionViewCell.h
//  SeedSlideControl_Example
//
//  Created by Hao on 2021/1/27.
//  Copyright © 2021 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/// 内置可缩放的单元格视图
@interface SeedZoomableCollectionViewCell : UICollectionViewCell

/// 默认图片
@property (nonatomic, strong) UIImage *s_placeholderImage;

/// 资源文件(image or imageName or imagePath or imageURL or imageURLString)
@property (nonatomic, weak) id s_asset;

/// 视图单击回调
@property (nonatomic, copy) void (^s_clikc)(id _Nullable sender);

/// 缩放视图
/// @param scale 缩放比例
- (void)s_zoomWith:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
