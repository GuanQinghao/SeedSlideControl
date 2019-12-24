//
//  GQHSlideViewCollectionViewFlowLayout.h
//  Seed
//
//  Created by Mac on 2019/12/12.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>


/// 缩放对齐方式
typedef NS_ENUM(NSUInteger, GQHSlideViewCollectionViewFlowLayoutAlignment) {
    
    GQHSlideViewCollectionViewFlowLayoutAlignmentCenter,
    
    // 水平布局
    GQHSlideViewCollectionViewFlowLayoutAlignmentTop,
    GQHSlideViewCollectionViewFlowLayoutAlignmentBottom,
    
    // 垂向布局
    GQHSlideViewCollectionViewFlowLayoutAlignmentLeft,
    GQHSlideViewCollectionViewFlowLayoutAlignmentRight,
};


NS_ASSUME_NONNULL_BEGIN

@interface GQHSlideViewCollectionViewFlowLayout : UICollectionViewFlowLayout

/**
 3D效果缩放比例, 默认1.0f, < 1.0f: 缩小, > 1.0f: 放大
 */
@property (nonatomic, assign) CGFloat qh_scale;

/**
 缩放后对齐方式
 */
@property (nonatomic, assign) GQHSlideViewCollectionViewFlowLayoutAlignment qh_alignment;

@end

NS_ASSUME_NONNULL_END
