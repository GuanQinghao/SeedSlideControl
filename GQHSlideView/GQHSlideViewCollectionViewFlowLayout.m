//
//  GQHSlideViewCollectionViewFlowLayout.m
//  Seed
//
//  Created by Mac on 2019/12/12.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#import "GQHSlideViewCollectionViewFlowLayout.h"


@implementation GQHSlideViewCollectionViewFlowLayout

/// 初始化布局
- (void)prepareLayout {
    [super prepareLayout];
    
}

/// 集合视图bounds发生变化是否需要重新布局
/// @param newBounds 集合视图新的bounds
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    // 获取元素对应的布局属性对象
    NSArray *attributesArray = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    // 显示范围
    CGRect visible = CGRectZero;
    visible.origin = self.collectionView.contentOffset;
    visible.size = self.collectionView.bounds.size;
    
    // 集合视图宽度
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    // 集合视图高度度
    CGFloat height = CGRectGetWidth(self.collectionView.bounds);
    
    
    switch (self.scrollDirection) {
            
        case UICollectionViewScrollDirectionVertical: {
            
            // 垂向滚动
            
            for (UICollectionViewLayoutAttributes *attributes  in attributesArray) {
                
                // 布局元素中心点距可见范围中心点的距离
                CGFloat distance = fabs(CGRectGetMidY(visible) - attributes.center.y);
                
                // 距离中心点太远, 不需要计算, 节省性能
                if ( distance > height) {
                    
                    continue;
                }
                
                // 标准化距离
                CGFloat standardized = distance/height;
                // 缩放比例(公式保证距离为0时不缩放)
                CGFloat scale = 1 - _qh_scale * standardized;
                
                // 水平缩放
                attributes.transform3D = CATransform3DMakeScale(scale, scale, 1.0f);
                
                // 垂向滚动, 左中右对齐
                switch (_qh_alignment) {
                        
                    case GQHSlideViewCollectionViewFlowLayoutAlignmentCenter: {
                        
                        // 默认就是居中
                    }
                        break;
                    case GQHSlideViewCollectionViewFlowLayoutAlignmentTop:
                    case GQHSlideViewCollectionViewFlowLayoutAlignmentBottom: {
                        
                        // 当水平滚动时才有效, 此时默认居中
                        NSAssert(YES, @"only valid when 'scrollDirection' is 'UICollectionViewScrollDirectionHorizontal'.");
                    }
                        break;
                    case GQHSlideViewCollectionViewFlowLayoutAlignmentLeft: {
                        
                        // 居左垂向滚动
                        CGFloat x = 0.5f * (1 - scale) * self.itemSize.width;
                        CGRect frame = CGRectMake(-x, attributes.frame.origin.y, attributes.size.width, attributes.size.height);
                        attributes.frame = frame;
                    }
                        break;
                    case GQHSlideViewCollectionViewFlowLayoutAlignmentRight: {
                        
                        // 居右垂向滚动
                        CGFloat x = 0.5f * (1 - scale) * self.itemSize.width;
                        CGRect frame = CGRectMake(x, attributes.frame.origin.y, attributes.size.width, attributes.size.height);
                        attributes.frame = frame;
                    }
                        break;
                }
            }
            
            return attributesArray;
        }
            break;
        case UICollectionViewScrollDirectionHorizontal: {
            
            // 水平滚动
            
            for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
                
                // 布局元素中心点距可见范围中心点的偏移量
                CGFloat offset = CGRectGetMidX(visible) - attributes.center.x;
                
                
                // 布局元素中心点距可见范围中心点的距离
                CGFloat distance = fabs(offset);
                
                // 缩放比例, 不可视范围内不缩放
                CGFloat scale = 1.0f;
                
                //
                CGFloat standardized = self.itemSize.width + self.minimumLineSpacing;
                
                
//                if (distance <= width) {
//                    // 可视范围内缩放
//                    // 标准化距离
//                    CGFloat standardized = distance/width;
//                    // 缩放比例(公式保证距离为0时不缩放)
//                    scale = 1 - standardized;
//                }
                
                if (distance > (self.itemSize.width + self.minimumLineSpacing)) {
                    
                    scale = _qh_scale;
                } else if (distance == 0.0f) {
                    
                    scale = 1.0f;
                    
                } else {
                    
                    scale = _qh_scale + (standardized - distance) * (1 - _qh_scale) / standardized;
                }
                
                // 缩放处理
                attributes.transform = CGAffineTransformMakeScale(scale, scale);
                
                // 水平滚动, 上中下对齐
                switch (_qh_alignment) {
                        
                    case GQHSlideViewCollectionViewFlowLayoutAlignmentCenter: {
                        
                        // 默认就是居中
                    }
                        break;
                    case GQHSlideViewCollectionViewFlowLayoutAlignmentTop: {
                        
                        // 居上水平滚动
                        CGFloat y = 0.5f * (1 - scale) * self.itemSize.height;
                        CGRect frame = CGRectMake(attributes.frame.origin.x, -y, attributes.size.width, attributes.size.height);
                        attributes.frame = frame;
                    }
                        break;
                    case GQHSlideViewCollectionViewFlowLayoutAlignmentBottom: {
                        
                        // 居下水平滚动
                        CGFloat y = 0.5f * (1 - scale) * self.itemSize.height;
                        CGRect frame = CGRectMake(attributes.frame.origin.x, y, attributes.size.width, attributes.size.height);
                        attributes.frame = frame;
                    }
                        break;
                    case GQHSlideViewCollectionViewFlowLayoutAlignmentLeft:
                    case GQHSlideViewCollectionViewFlowLayoutAlignmentRight: {
                        
                        // 当垂向滚动时才有效, 此时默认居中
                        NSAssert(YES, @"only valid when 'scrollDirection' is 'UICollectionViewScrollDirectionVertical'.");
                    }
                        break;
                }
            }
            
            return attributesArray;
        }
            break;
    }
}



/*

/// 元素布局属性组
/// @param rect 可见范围
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    // 获取元素对应的布局属性对象
    NSArray *attributesArray = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    // 集合视图宽度
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    // 集合视图高度度
    CGFloat height = CGRectGetWidth(self.collectionView.bounds);
    
    // 显示范围
    CGRect visible = CGRectZero;
    visible.origin = self.collectionView.contentOffset;
    visible.size = self.collectionView.bounds.size;
    
    switch (self.scrollDirection) {
            
        case UICollectionViewScrollDirectionVertical: {
            
            // 垂向滚动
            
            for (UICollectionViewLayoutAttributes *attributes  in attributesArray) {
                
                // 布局元素中心点距可见范围中心点的距离
                CGFloat distance = fabs(CGRectGetMidY(visible) - attributes.center.y);
                
                // 距离中心点太远, 不需要计算, 节省性能
                if ( distance > height) {
                    
                    continue;
                }
                
                // 标准化距离
                CGFloat standardized = distance/height;
                // 缩放比例(公式保证距离为0时不缩放)
                CGFloat scale = 1 - _qh_scale * standardized;
                
                // 水平缩放
                attributes.transform3D = CATransform3DMakeScale(scale, scale, 1.0f);
                
                // 垂向滚动, 左中右对齐
                switch (_qh_alignment) {
                        
                    case GQHSlideViewCollectionViewFlowLayoutAlignmentCenter: {
                        
                        // 默认就是居中
                    }
                        break;
                    case GQHSlideViewCollectionViewFlowLayoutAlignmentTop:
                    case GQHSlideViewCollectionViewFlowLayoutAlignmentBottom: {
                        
                        // 当水平滚动时才有效, 此时默认居中
                        NSAssert(YES, @"only valid when 'scrollDirection' is 'UICollectionViewScrollDirectionHorizontal'.");
                    }
                        break;
                    case GQHSlideViewCollectionViewFlowLayoutAlignmentLeft: {
                        
                        // 居左垂向滚动
                        CGFloat x = 0.5f * (1 - scale) * self.itemSize.width;
                        CGRect frame = CGRectMake(-x, attributes.frame.origin.y, attributes.size.width, attributes.size.height);
                        attributes.frame = frame;
                    }
                        break;
                    case GQHSlideViewCollectionViewFlowLayoutAlignmentRight: {
                        
                        // 居右垂向滚动
                        CGFloat x = 0.5f * (1 - scale) * self.itemSize.width;
                        CGRect frame = CGRectMake(x, attributes.frame.origin.y, attributes.size.width, attributes.size.height);
                        attributes.frame = frame;
                    }
                        break;
                }
            }
            
            return attributesArray;
        }
            break;
        case UICollectionViewScrollDirectionHorizontal: {
            
            // 水平滚动
            
            for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
                
                // 布局元素中心点距可见范围中心点的偏移量
                CGFloat offset = CGRectGetMidX(visible) - attributes.center.x;
                // 布局元素中心点距可见范围中心点的距离
                CGFloat distance = fabs(offset);
                
                NSLog(@"distance : %f",distance);
                
                
                // 距离中心点太远, 不需要计算, 节省性能
                if (distance > width) {
                    
                    continue;
                }
                
                // 标准化距离
                CGFloat standardized = distance/width;
                // 缩放比例(公式保证距离为0时不缩放)
                CGFloat scale = 1 - _qh_scale * standardized;
                
                // 缩放平移处理
                CGAffineTransform transformScale = CGAffineTransformMakeScale(scale, 1.0f);
                attributes.transform = transformScale;
//                CGAffineTransform transformTranslation = CGAffineTransformMakeTranslation(0.5f * (offset * (1 - scale)), 0.0f);
                
                NSLog(@"*********%f",0.5f * (offset * (1 - scale)));
                
//                attributes.transform = CGAffineTransformConcat(transformScale, transformTranslation);
//                attributes.transform = transformScale;
                // 水平滚动, 上中下对齐
                switch (_qh_alignment) {
                        
                    case GQHSlideViewCollectionViewFlowLayoutAlignmentCenter: {
                        
                        // 默认就是居中
                    }
                        break;
                    case GQHSlideViewCollectionViewFlowLayoutAlignmentTop: {
                        
                        // 居上水平滚动
                        CGFloat y = 0.5f * (1 - scale) * self.itemSize.height;
                        CGRect frame = CGRectMake(attributes.frame.origin.x, -y, attributes.size.width, attributes.size.height);
                        attributes.frame = frame;
                    }
                        break;
                    case GQHSlideViewCollectionViewFlowLayoutAlignmentBottom: {
                        
                        // 居下水平滚动
                        CGFloat y = 0.5f * (1 - scale) * self.itemSize.height;
                        CGRect frame = CGRectMake(attributes.frame.origin.x, y, attributes.size.width, attributes.size.height);
                        attributes.frame = frame;
                    }
                        break;
                    case GQHSlideViewCollectionViewFlowLayoutAlignmentLeft:
                    case GQHSlideViewCollectionViewFlowLayoutAlignmentRight: {
                        
                        // 当垂向滚动时才有效, 此时默认居中
                        NSAssert(YES, @"only valid when 'scrollDirection' is 'UICollectionViewScrollDirectionVertical'.");
                    }
                        break;
                }
            }
            
            return attributesArray;
        }
            break;
    }
}

*/

/// 计算集合视图停止滚动时的偏移量
/// @param proposedContentOffset 预估的偏移量
/// @param velocity 速度
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    // 显示cell的矩形框
    CGRect rect;
    // 矩形框大小
    rect.size = self.collectionView.frame.size;
    
    // 最小间距
    __block CGFloat delta = CGFLOAT_MAX;
    
    // 计算集合视图中心点的X值
    CGFloat centerX = proposedContentOffset.x + 0.5f * CGRectGetWidth(self.collectionView.frame);
    // 计算集合视图中心点的Y值
    CGFloat centerY = proposedContentOffset.y + 0.5f * CGRectGetHeight(self.collectionView.frame);
    
    switch (self.scrollDirection) {
            
        case UICollectionViewScrollDirectionVertical: {
            // 垂向滚动
            
            // 矩形框位置
            rect.origin.x = 0.0f;
            rect.origin.y = proposedContentOffset.y;
            
            // 获得super已经计算好的布局属性
            NSArray<UICollectionViewLayoutAttributes *> *attributesArray = [super layoutAttributesForElementsInRect:rect];
            [attributesArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                // 布局属性中心点距矩形框中心点垂向距离
                CGFloat distance = obj.center.y - centerY;
                
                if (fabs(delta) > fabs(distance)) {
                    
                    // 找到最小值
                    delta = distance;
                }
            }];
            
            // 修改原布局属性的偏移量
            proposedContentOffset.y += delta;
        }
            break;
        case UICollectionViewScrollDirectionHorizontal: {
            // 水平滚动
            
            // 矩形框位置
            rect.origin.x = proposedContentOffset.x;
            rect.origin.y = 0.0f;
            
            // 获得super已经计算好的布局属性
            NSArray<UICollectionViewLayoutAttributes *> *attributesArray = [super layoutAttributesForElementsInRect:rect];
            [attributesArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                // 布局属性中心点距矩形框中心点垂向距离
                CGFloat distance = obj.center.x - centerX;
                
                if (fabs(delta) > fabs(distance)) {
                    
                    // 找到最小值
                    delta = distance;
                }
            }];
            
            // 修改原布局属性的偏移量
            proposedContentOffset.x += delta;
        }
            break;
    }
    
    return proposedContentOffset;
}

- (void)setQh_scale:(CGFloat)qh_scale {
    
    // 0.0f <= scale < 1.0f
    qh_scale = (qh_scale < 0.0f) ? 0.0f : ((qh_scale < 1.0f) ? qh_scale : 1.0f);
    _qh_scale = qh_scale;
}

- (void)setQh_alignment:(GQHSlideViewCollectionViewFlowLayoutAlignment)qh_alignment {
    
    _qh_alignment = qh_alignment;
}

@end
