//
//  GQHPageControl.m
//  Seed
//
//  Created by GuanQinghao on 12/12/2017.
//  Copyright © 2017 GuanQinghao. All rights reserved.
//

#import "GQHPageControl.h"
#import "GQHPageControlGraphicIndicator.h"


@interface GQHPageControl ()

/// 标签样式页码指示器(单个)
@property (nonatomic, strong) GQHPageControlGraphicIndicator *textualIndicator;
/// 经典样式和图文样式页码指示器数组(单个或多个)
@property (nonatomic, strong) NSMutableArray<__kindof UIView *> *indicatorMutableArray;

@end

@implementation GQHPageControl

/// 分页控件的尺寸
/// @param style 分页控件样式
/// @param count 分页控件总页数
- (CGSize)qh_sizeWithPageControlStyle:(GQHPageControlStyle)style pages:(NSInteger)count {
    
    // 分页控件样式
    switch (style) {
            
        case GQHPageControlStyleClassic: {
            
            // 经典样式(图文样式特例)
        }
        case GQHPageControlStyleGraphic: {
            
            // 图文样式
            CGFloat width = (_qh_appearance.qh_size.width + _qh_appearance.qh_spacing) * (count - 1) + _qh_appearance.qh_currentSize.width;
            CGFloat height = MAX(_qh_appearance.qh_size.height, _qh_appearance.qh_currentSize.height);
            
            return CGSizeMake(width, height);
        }
            break;
        case GQHPageControlStyleTextual: {
            
            // 标签样式(图文样式特例)
            return _qh_appearance.qh_size;
        }
            break;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _qh_totalPages = 0;
        _qh_currentPage = 0;
    }
    
    return self;
}

#pragma mark - touchEvent

/// 点击分页控件上的页码指示器
/// @param touches N/A
/// @param event N/A
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    if (touch.view != self) {
        
        // 选中的页码索引值
        NSInteger index = [self.indicatorMutableArray indexOfObject:touch.view];
        
        if ([self.qh_delegate respondsToSelector:@selector(qh_pageControl:didSelectPageAtIndex:)]) {
            
            [self.qh_delegate qh_pageControl:self didSelectPageAtIndex:index];
        }
    }
}

#pragma mark - Layout

/// 系统方法
- (void)sizeToFit {
    
    // 分页控件中心点
    CGPoint center = self.center;
    // 分页控件的尺寸
    CGSize size = [self qh_sizeWithPageControlStyle:_qh_appearance.qh_style pages:_qh_totalPages];
    // 分页控件新的frame
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), size.width, size.height);
    // 分页控件中心点
    self.center = center;
    
    // 重置所有页码指示器
    [self resetAllIndicators];
}

/// 重置所有页码指示器
- (void)resetAllIndicators {
    
    // 移除所有页码指示器
    while (self.subviews.count) {
        
        [self.subviews.lastObject removeFromSuperview];
    }
    
    // 清空页码指示器数组
    [self.indicatorMutableArray removeAllObjects];
    
    if (1 > _qh_totalPages) {
        
        return;
    }

    // 单页隐藏指示器
    self.hidden = (1 == _qh_totalPages) ? _qh_appearance.qh_hidesForSinglePage : NO;
    
    switch (_qh_appearance.qh_style) {
            
        case GQHPageControlStyleClassic: {
            
            // 经典样式(就是图文样式的特例)
            for (NSInteger i = 0; i < _qh_totalPages; i++) {
                
                // 创建经典样式页码指示器
                GQHPageControlGraphicIndicator *indicator = [[GQHPageControlGraphicIndicator alloc] init];
                // 设置页码指示器外观
                [self updateClassicIndicator:indicator atIndex:i];
                [self addSubview:indicator];
                [self.indicatorMutableArray addObject:indicator];
            }
        }
            break;
        case GQHPageControlStyleGraphic: {
            
            // 图文样式
            for (NSInteger i = 0; i < _qh_totalPages; i++) {
                
                // 创建图文样式页码指示器
                GQHPageControlGraphicIndicator *indicator = [[GQHPageControlGraphicIndicator alloc] init];
                // 设置页码指示器外观
                [self updateGraphicIndicator:indicator atIndex:i];
                [self addSubview:indicator];
                [self.indicatorMutableArray addObject:indicator];
            }
        }
            break;
        case GQHPageControlStyleTextual: {
            
            // 标签样式(也是图文样式的特例, 但只有一个)
            self.textualIndicator = [[GQHPageControlGraphicIndicator alloc] init];
            // 设置页码指示器外观
            [self updateTextualIndicator:self.textualIndicator atIndex:0];
            [self addSubview:self.textualIndicator];
        }
            break;
    }
    
    [self checkStateAtIndex:_qh_currentPage];
}

/// 检查状态
/// @param index 当前索引值(标签样式使用)
- (void)checkStateAtIndex:(NSInteger)index {
    
    switch (_qh_appearance.qh_style) {
            
        case GQHPageControlStyleClassic: {
            
            // 经典样式(就是图文样式的特例)
            [self.indicatorMutableArray enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                // 更新经典样式指定页码指示器
                [self updateClassicIndicator:obj atIndex:idx];
            }];
        }
            break;
        case GQHPageControlStyleGraphic: {
            
            // 图文样式
            [self.indicatorMutableArray enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                // 更新图文样式指定页码指示器
                [self updateGraphicIndicator:obj atIndex:idx];
            }];
        }
            break;
        case GQHPageControlStyleTextual: {
            
            // 标签样式
            self.textualIndicator.qh_textLabel.text = [NSString stringWithFormat:@"%@/%@",@(index + 1),@(_qh_totalPages)];
        }
            break;
    }
}

/// 更新经典样式指定页码指示器
/// @param indicator 经典样式页码指示器
/// @param index 页码指示器对应的索引值
- (void)updateClassicIndicator:(GQHPageControlGraphicIndicator *)indicator atIndex:(NSInteger)index {
    
    // 分页控件的尺寸
    CGSize size = [self qh_sizeWithPageControlStyle:_qh_appearance.qh_style pages:_qh_totalPages];
    
    indicator.frame = CGRectMake(0.0f, 0.0f, _qh_appearance.qh_size.width, _qh_appearance.qh_size.height);
    // 背景色
    indicator.backgroundColor = _qh_appearance.qh_backgroundColor;
    // 切圆角
    indicator.layer.cornerRadius = 0.5f * MIN(_qh_appearance.qh_size.width, _qh_appearance.qh_size.height);
    indicator.layer.masksToBounds = YES;
    
    // 不显示图片和文本
    indicator.qh_imageView.hidden = YES;
    indicator.qh_textLabel.hidden = YES;
    
    if (index <= _qh_currentPage) {
        
        CGFloat x = (_qh_appearance.qh_size.width + _qh_appearance.qh_spacing) * index + 0.5f * (CGRectGetWidth(self.frame) - size.width);
        CGFloat y = 0.5f * (CGRectGetHeight(self.frame) - _qh_appearance.qh_size.height);
        indicator.frame = CGRectMake(x, y, _qh_appearance.qh_size.width, _qh_appearance.qh_size.height);
        
        if (index == _qh_currentPage) {
            
            CGFloat y = 0.5f * (CGRectGetHeight(self.frame) - _qh_appearance.qh_currentSize.height);
            indicator.frame = CGRectMake(x, y, _qh_appearance.qh_currentSize.width, _qh_appearance.qh_currentSize.height);
            // 当前背景色
            indicator.backgroundColor = _qh_appearance.qh_currentBackgroundColor;
            // 切圆角
            indicator.layer.cornerRadius = 0.5f * MIN(_qh_appearance.qh_currentSize.width, _qh_appearance.qh_currentSize.height);
            indicator.layer.masksToBounds = YES;
        }
    } else {
        
        CGFloat x = (_qh_appearance.qh_size.width + _qh_appearance.qh_spacing) * (index - 1) + _qh_appearance.qh_currentSize.width + _qh_appearance.qh_spacing + 0.5f * (CGRectGetWidth(self.frame) - size.width);
        CGFloat y = 0.5f * (CGRectGetHeight(self.frame) - _qh_appearance.qh_size.height);
        indicator.frame = CGRectMake(x, y, _qh_appearance.qh_size.width, _qh_appearance.qh_size.height);
    }
}

/// 更新图文样式指定页码指示器
/// @param indicator 图文样式页码指示器
/// @param index 页码指示器对应的索引值
- (void)updateGraphicIndicator:(GQHPageControlGraphicIndicator *)indicator atIndex:(NSInteger)index {
    
    // 分页控件的尺寸
    CGSize size = [self qh_sizeWithPageControlStyle:_qh_appearance.qh_style pages:_qh_totalPages];
    
    indicator.frame = CGRectMake(0.0f, 0.0f, _qh_appearance.qh_size.width, _qh_appearance.qh_size.height);
    
    //TODO:图片格式?(固定、数组)
    indicator.qh_imageView.image = _qh_appearance.qh_image;
    indicator.qh_textLabel.textColor = _qh_appearance.qh_textColor;
    indicator.qh_textLabel.font = _qh_appearance.qh_textFont;
    
    //TODO:文字格式?(固定、数组)
    indicator.qh_textLabel.text = _qh_appearance.qh_text;
    
    if (index <= _qh_currentPage) {
        
        CGFloat x = (_qh_appearance.qh_size.width + _qh_appearance.qh_spacing) * index + 0.5f * (CGRectGetWidth(self.frame) - size.width);
        CGFloat y = 0.5f * (CGRectGetHeight(self.frame) - _qh_appearance.qh_size.height);
        indicator.frame = CGRectMake(x, y, _qh_appearance.qh_size.width, _qh_appearance.qh_size.height);
        
        if (index == _qh_currentPage) {
            
            CGFloat y = 0.5f * (CGRectGetHeight(self.frame) - _qh_appearance.qh_currentSize.height);
            indicator.frame = CGRectMake(x, y, _qh_appearance.qh_currentSize.width, _qh_appearance.qh_currentSize.height);
            
            //TODO:图片格式?(固定、数组)
            indicator.qh_imageView.image = _qh_appearance.qh_currentImage;
            indicator.qh_textLabel.textColor = _qh_appearance.qh_currentTextColor;
            indicator.qh_textLabel.font = _qh_appearance.qh_currentTextFont;
            
            //TODO:文字格式?(固定、数组)
            indicator.qh_textLabel.text = _qh_appearance.qh_currentText;
        }
    } else {
        
        CGFloat x = (_qh_appearance.qh_size.width + _qh_appearance.qh_spacing) * (index - 1) + _qh_appearance.qh_currentSize.width + _qh_appearance.qh_spacing + 0.5f * (CGRectGetWidth(self.frame) - size.width);
        CGFloat y = 0.5f * (CGRectGetHeight(self.frame) - _qh_appearance.qh_size.height);
        indicator.frame = CGRectMake(x, y, _qh_appearance.qh_size.width, _qh_appearance.qh_size.height);
    }
}

/// 更新标签样式页码指示器
/// @param indicator 标签样式页码指示器
/// @param index 页码指示器对应的索引值
- (void)updateTextualIndicator:(GQHPageControlGraphicIndicator *)indicator atIndex:(NSInteger)index {
    
    indicator.frame = CGRectMake(0.0f, 0.0f, _qh_appearance.qh_size.width, _qh_appearance.qh_size.height);
    // 背景色
    indicator.backgroundColor = _qh_appearance.qh_backgroundColor;
    // 切圆角
    indicator.layer.cornerRadius = 0.5f * MIN(_qh_appearance.qh_size.width, _qh_appearance.qh_size.height);
    indicator.layer.masksToBounds = YES;
    
    //TODO:图片格式
    indicator.qh_imageView.image = _qh_appearance.qh_image;
    indicator.qh_textLabel.textColor = _qh_appearance.qh_textColor;
    indicator.qh_textLabel.font = _qh_appearance.qh_textFont;
    
    //TODO:文字格式?(固定、数组)
    indicator.qh_textLabel.text = [NSString stringWithFormat:@"%@/%@",@(index + 1),@(_qh_totalPages)];
}

#pragma mark - Setter

- (void)setQh_totalPages:(NSInteger)qh_totalPages {
    
    _qh_totalPages = qh_totalPages;
    
    // 重置所有页码标识视图
    [self resetAllIndicators];
}

- (void)setQh_currentPage:(NSInteger)qh_currentPage {
    
    // 总页数为0或当前页就是当前页
    if (0 == self.qh_totalPages || qh_currentPage == _qh_currentPage) {
        
        return;
    }
    
    _qh_currentPage = qh_currentPage;
    // 刷新页码指示器状态
    [self checkStateAtIndex:qh_currentPage];
}

- (void)setQh_appearance:(GQHPageControlAppearance *)qh_appearance {
    
    _qh_appearance = qh_appearance;
    
    // 重置所有页码标识视图
    [self resetAllIndicators];
}

#pragma mark - Getter

- (GQHPageControlGraphicIndicator *)textualIndicator {
    
    if (!_textualIndicator) {
        
        _textualIndicator = [[GQHPageControlGraphicIndicator alloc] init];
    }
    
    return _textualIndicator;
}

- (NSMutableArray<UIView *> *)indicatorMutableArray {
    
    if (!_indicatorMutableArray) {
        
        _indicatorMutableArray = [NSMutableArray array];
    }
    
    return _indicatorMutableArray;
}

@end
