//
//  SeedSlideViewCollectionViewFlowLayout.h
//  SeedSlideControl
//
//  Created by Hao on 2020/11/19.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/// 缩放对齐方式
typedef NS_ENUM(NSUInteger, SeedSlideViewCollectionViewFlowLayoutAlignment) {
    
    /// 居中
    SeedSlideViewCollectionViewFlowLayoutAlignmentCenter,
    
    /// 水平居上
    SeedSlideViewCollectionViewFlowLayoutAlignmentTop,
    /// 水平居下
    SeedSlideViewCollectionViewFlowLayoutAlignmentBottom,
    
    /// 垂向居左
    SeedSlideViewCollectionViewFlowLayoutAlignmentLeft,
    /// 垂向居右
    SeedSlideViewCollectionViewFlowLayoutAlignmentRight,
};

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

@interface SeedSlideViewCollectionViewFlowLayout : UICollectionViewFlowLayout

/// 3D效果缩放比例, 取值范围[0.0f, 1.0f], 默认0.0f, 表示不缩放
@property (nonatomic, assign) CGFloat s_scale;

/// 缩放对齐方式
@property (nonatomic, assign) SeedSlideViewCollectionViewFlowLayoutAlignment s_alignment;

@end

NS_ASSUME_NONNULL_END
