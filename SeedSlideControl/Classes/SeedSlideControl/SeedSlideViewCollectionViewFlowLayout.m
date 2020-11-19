//
//  SeedSlideViewCollectionViewFlowLayout.m
//  SeedSlideControl
//
//  Created by Hao on 2020/11/19.
//

#import "SeedSlideViewCollectionViewFlowLayout.h"


@implementation SeedSlideViewCollectionViewFlowLayout

/// 初始化布局
- (void)prepareLayout {
    [super prepareLayout];

}

/// 集合视图bounds发生变化是否需要重新布局
/// @param newBounds 集合视图新的bounds
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

/// 元素布局属性组
/// @param rect 可见范围
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    switch (self.scrollDirection) {
            
        case UICollectionViewScrollDirectionVertical: {
            
            // 垂向滚动
            
            // 获取元素对应的布局属性对象
            NSArray *attributesArray = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
            // 集合视图高度度
            CGFloat height = CGRectGetHeight(self.collectionView.bounds);
            
            // 显示范围
            CGRect visible = CGRectZero;
            visible.origin = self.collectionView.contentOffset;
            visible.size = self.collectionView.bounds.size;
            
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
                CGFloat scale = 1 - standardized * _s_scale;
                
                // 水平缩放
                attributes.transform3D = CATransform3DMakeScale(scale, 1.0f, 1.0f);
                
                // 垂向滚动, 左中右对齐
                switch (_s_alignment) {
                        
                    case SeedSlideViewCollectionViewFlowLayoutAlignmentCenter: {
                        
                        // 默认就是居中
                    }
                        break;
                    case SeedSlideViewCollectionViewFlowLayoutAlignmentTop:
                    case SeedSlideViewCollectionViewFlowLayoutAlignmentBottom: {
                        
                        // 当水平滚动时才有效, 此时默认居中
                        NSAssert(YES, @"only valid when 'scrollDirection' is 'UICollectionViewScrollDirectionHorizontal'.");
                    }
                        break;
                    case SeedSlideViewCollectionViewFlowLayoutAlignmentLeft: {
                        
                        // 居左垂向滚动
                        CGFloat x = 0.5f * (1 - scale) * self.itemSize.width;
                        CGRect frame = CGRectMake(-x, attributes.frame.origin.y, attributes.size.width, attributes.size.height);
                        attributes.frame = frame;
                    }
                        break;
                    case SeedSlideViewCollectionViewFlowLayoutAlignmentRight: {
                        
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
            
            // 获取元素对应的布局属性对象
            NSArray *attributesArray = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
            // 集合视图宽度
            CGFloat width = CGRectGetWidth(self.collectionView.bounds);
            
            // 显示范围
            CGRect visible = CGRectZero;
            visible.origin = self.collectionView.contentOffset;
            visible.size = self.collectionView.bounds.size;
            
            for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
                
                // 布局元素中心点距可见范围中心点的距离
                CGFloat distance = fabs(CGRectGetMidX(visible) - attributes.center.x);
                
                // 距离中心点太远, 不需要计算, 节省性能
                if ( distance > width) {
                    
                    continue;
                }
                
                // 标准化距离
                CGFloat standardized = distance/width;
                // 缩放比例(公式保证距离为0时不缩放)
                CGFloat scale = 1 - _s_scale * standardized;
                // 垂向缩放
                attributes.transform3D = CATransform3DMakeScale(1.0f, scale, 1.0f);
                
                // 水平滚动, 上中下对齐
                switch (_s_alignment) {
                        
                    case SeedSlideViewCollectionViewFlowLayoutAlignmentCenter: {
                        
                        // 默认就是居中
                    }
                        break;
                    case SeedSlideViewCollectionViewFlowLayoutAlignmentTop: {
                        
                        // 居上水平滚动
                        CGFloat y = 0.5f * (1 - scale) * self.itemSize.height;
                        CGRect frame = CGRectMake(attributes.frame.origin.x, -y, attributes.size.width, attributes.size.height);
                        attributes.frame = frame;
                    }
                        break;
                    case SeedSlideViewCollectionViewFlowLayoutAlignmentBottom: {
                        
                        // 居下水平滚动
                        CGFloat y = 0.5f * (1 - scale) * self.itemSize.height;
                        CGRect frame = CGRectMake(attributes.frame.origin.x, y, attributes.size.width, attributes.size.height);
                        attributes.frame = frame;
                    }
                        break;
                    case SeedSlideViewCollectionViewFlowLayoutAlignmentLeft:
                    case SeedSlideViewCollectionViewFlowLayoutAlignmentRight: {
                        
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

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    return self.collectionView.contentOffset;
}

- (void)setS_scale:(CGFloat)s_scale {
    
    // 0.0f <= scale < 1.0f
    s_scale = (s_scale < 0.0f) ? 0.0f : ((s_scale < 1.0f) ? s_scale : 0.99f);
    _s_scale = s_scale;
}

- (void)setS_alignment:(SeedSlideViewCollectionViewFlowLayoutAlignment)s_alignment {
    
    _s_alignment = s_alignment;
}

@end
