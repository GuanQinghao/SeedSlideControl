//
//  SeedPageControl.m
//  SeedSlideControl
//
//  Created by Hao on 2020/10/29.
//

#import "SeedPageControl.h"
#import "SeedPageControlGraphicIndicator.h"


@interface SeedPageControl ()

/// 标签样式页码指示器(单个)
@property (nonatomic, strong) SeedPageControlGraphicIndicator *textualIndicator;
/// 经典样式和图文样式页码指示器数组(单个或多个)
@property (nonatomic, strong) NSMutableArray<__kindof UIView *> *indicatorMutableArray;

@end

@implementation SeedPageControl

#pragma mark --------------------------- <lifecycle> ---------------------------

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _s_totalPages = 0;
        _s_currentPage = 0;
    }
    
    return self;
}

#pragma mark ---------------------------- <layout> ----------------------------

- (void)sizeToFit {
    
    // 分页控件中心点
    CGPoint center = self.center;
    // 分页控件的尺寸
    CGSize size = [self s_sizeWithPageControlStyle:_s_appearance.s_style pages:_s_totalPages];
    // 分页控件新的frame
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), size.width, size.height);
    // 分页控件中心点
    self.center = center;
    
    // 重置所有页码指示器
    [self resetAllIndicators];
}

#pragma mark ---------------------------- <method> ----------------------------

#pragma mark - public method

/// 分页控件的尺寸
/// @param style 分页控件样式
/// @param count 分页控件总页数
- (CGSize)s_sizeWithPageControlStyle:(SeedPageControlStyle)style pages:(NSInteger)count {
    
    // 分页控件样式
    switch (style) {
            
        case SeedPageControlStyleClassic: {
            
            // 经典样式(图文样式特例)
        }
        case SeedPageControlStyleGraphic: {
            
            // 图文样式
            CGFloat width = (_s_appearance.s_size.width + _s_appearance.s_spacing) * (count - 1) + _s_appearance.s_currentSize.width;
            CGFloat height = MAX(_s_appearance.s_size.height, _s_appearance.s_currentSize.height);
            
            return CGSizeMake(width, height);
        }
            break;
        case SeedPageControlStyleTextual: {
            
            // 标签样式(图文样式特例)
            return _s_appearance.s_size;
        }
            break;
    }
}

#pragma mark - target method

/// 点击分页控件上的页码指示器
/// @param touches N/A
/// @param event N/A
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    if (touch.view != self) {
        
        // 选中的页码索引值
        NSInteger index = [self.indicatorMutableArray indexOfObject:touch.view];
        
        if ([self.s_delegate respondsToSelector:@selector(s_pageControl:didSelectPageAtIndex:)]) {
            
            [self.s_delegate s_pageControl:self didSelectPageAtIndex:index];
        }
    }
}

#pragma mark - private method

/// 重置所有页码指示器
- (void)resetAllIndicators {
    
    // 移除所有页码指示器
    while (self.subviews.count) {
        
        [self.subviews.lastObject removeFromSuperview];
    }
    
    // 清空页码指示器数组
    [self.indicatorMutableArray removeAllObjects];
    
    if (1 > _s_totalPages) {
        
        return;
    }
    
    switch (_s_appearance.s_style) {
            
        case SeedPageControlStyleClassic: {
            
            // 经典样式(就是图文样式的特例)
            for (NSInteger i = 0; i < _s_totalPages; i++) {
                
                // 创建经典样式页码指示器
                SeedPageControlGraphicIndicator *indicator = [[SeedPageControlGraphicIndicator alloc] init];
                // 设置页码指示器外观
                [self updateClassicIndicator:indicator atIndex:i];
                [self addSubview:indicator];
                [self.indicatorMutableArray addObject:indicator];
            }
        }
            break;
        case SeedPageControlStyleGraphic: {
            
            // 图文样式
            for (NSInteger i = 0; i < _s_totalPages; i++) {
                
                // 创建图文样式页码指示器
                SeedPageControlGraphicIndicator *indicator = [[SeedPageControlGraphicIndicator alloc] init];
                // 设置页码指示器外观
                [self updateGraphicIndicator:indicator atIndex:i];
                [self addSubview:indicator];
                [self.indicatorMutableArray addObject:indicator];
            }
        }
            break;
        case SeedPageControlStyleTextual: {
            
            // 标签样式(也是图文样式的特例, 但只有一个)
            self.textualIndicator = [[SeedPageControlGraphicIndicator alloc] init];
            // 设置页码指示器外观
            [self updateTextualIndicator:self.textualIndicator atIndex:0];
            [self addSubview:self.textualIndicator];
        }
            break;
    }
    
    [self checkStateAtIndex:_s_currentPage];
}

/// 检查状态
/// @param index 当前索引值(标签样式使用)
- (void)checkStateAtIndex:(NSInteger)index {
    
    switch (_s_appearance.s_style) {
            
        case SeedPageControlStyleClassic: {
            
            // 经典样式(就是图文样式的特例)
            [self.indicatorMutableArray enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                // 更新经典样式指定页码指示器
                [self updateClassicIndicator:obj atIndex:idx];
            }];
        }
            break;
        case SeedPageControlStyleGraphic: {
            
            // 图文样式
            [self.indicatorMutableArray enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                // 更新图文样式指定页码指示器
                [self updateGraphicIndicator:obj atIndex:idx];
            }];
        }
            break;
        case SeedPageControlStyleTextual: {
            
            // 标签样式
            self.textualIndicator.s_textLabel.text = [NSString stringWithFormat:@"%@/%@",@(index + 1),@(_s_totalPages)];
        }
            break;
    }
}

/// 更新经典样式指定页码指示器
/// @param indicator 经典样式页码指示器
/// @param index 页码指示器对应的索引值
- (void)updateClassicIndicator:(SeedPageControlGraphicIndicator *)indicator atIndex:(NSInteger)index {
    
    // 分页控件的尺寸
    CGSize size = [self s_sizeWithPageControlStyle:_s_appearance.s_style pages:_s_totalPages];
    
    indicator.frame = CGRectMake(0.0f, 0.0f, _s_appearance.s_size.width, _s_appearance.s_size.height);
    // 背景色
    indicator.backgroundColor = _s_appearance.s_backgroundColor;
    // 切圆角
    indicator.layer.cornerRadius = 0.5f * MIN(_s_appearance.s_size.width, _s_appearance.s_size.height);
    indicator.layer.masksToBounds = YES;
    
    // 不显示图片和文本
    indicator.s_imageView.hidden = YES;
    indicator.s_textLabel.hidden = YES;
    
    if (index <= _s_currentPage) {
        
        CGFloat x = (_s_appearance.s_size.width + _s_appearance.s_spacing) * index + 0.5f * (CGRectGetWidth(self.frame) - size.width);
        CGFloat y = 0.5f * (CGRectGetHeight(self.frame) - _s_appearance.s_size.height);
        indicator.frame = CGRectMake(x, y, _s_appearance.s_size.width, _s_appearance.s_size.height);
        
        if (index == _s_currentPage) {
            
            CGFloat y = 0.5f * (CGRectGetHeight(self.frame) - _s_appearance.s_currentSize.height);
            indicator.frame = CGRectMake(x, y, _s_appearance.s_currentSize.width, _s_appearance.s_currentSize.height);
            // 当前背景色
            indicator.backgroundColor = _s_appearance.s_currentBackgroundColor;
            // 切圆角
            indicator.layer.cornerRadius = 0.5f * MIN(_s_appearance.s_currentSize.width, _s_appearance.s_currentSize.height);
            indicator.layer.masksToBounds = YES;
        }
    } else {
        
        CGFloat x = (_s_appearance.s_size.width + _s_appearance.s_spacing) * (index - 1) + _s_appearance.s_currentSize.width + _s_appearance.s_spacing + 0.5f * (CGRectGetWidth(self.frame) - size.width);
        CGFloat y = 0.5f * (CGRectGetHeight(self.frame) - _s_appearance.s_size.height);
        indicator.frame = CGRectMake(x, y, _s_appearance.s_size.width, _s_appearance.s_size.height);
    }
}

/// 更新图文样式指定页码指示器
/// @param indicator 图文样式页码指示器
/// @param index 页码指示器对应的索引值
- (void)updateGraphicIndicator:(SeedPageControlGraphicIndicator *)indicator atIndex:(NSInteger)index {
    
    // 分页控件的尺寸
    CGSize size = [self s_sizeWithPageControlStyle:_s_appearance.s_style pages:_s_totalPages];
    
    indicator.frame = CGRectMake(0.0f, 0.0f, _s_appearance.s_size.width, _s_appearance.s_size.height);
    
    //TODO:图片格式?(固定、数组)
    indicator.s_imageView.image = _s_appearance.s_image;
    indicator.s_textLabel.textColor = _s_appearance.s_textColor;
    indicator.s_textLabel.font = _s_appearance.s_textFont;
    
    //TODO:文字格式?(固定、数组)
    indicator.s_textLabel.text = _s_appearance.s_text;
    
    if (index <= _s_currentPage) {
        
        CGFloat x = (_s_appearance.s_size.width + _s_appearance.s_spacing) * index + 0.5f * (CGRectGetWidth(self.frame) - size.width);
        CGFloat y = 0.5f * (CGRectGetHeight(self.frame) - _s_appearance.s_size.height);
        indicator.frame = CGRectMake(x, y, _s_appearance.s_size.width, _s_appearance.s_size.height);
        
        if (index == _s_currentPage) {
            
            CGFloat y = 0.5f * (CGRectGetHeight(self.frame) - _s_appearance.s_currentSize.height);
            indicator.frame = CGRectMake(x, y, _s_appearance.s_currentSize.width, _s_appearance.s_currentSize.height);
            
            //TODO:图片格式?(固定、数组)
            indicator.s_imageView.image = _s_appearance.s_currentImage;
            indicator.s_textLabel.textColor = _s_appearance.s_currentTextColor;
            indicator.s_textLabel.font = _s_appearance.s_currentTextFont;
            
            //TODO:文字格式?(固定、数组)
            indicator.s_textLabel.text = _s_appearance.s_currentText;
        }
    } else {
        
        CGFloat x = (_s_appearance.s_size.width + _s_appearance.s_spacing) * (index - 1) + _s_appearance.s_currentSize.width + _s_appearance.s_spacing + 0.5f * (CGRectGetWidth(self.frame) - size.width);
        CGFloat y = 0.5f * (CGRectGetHeight(self.frame) - _s_appearance.s_size.height);
        indicator.frame = CGRectMake(x, y, _s_appearance.s_size.width, _s_appearance.s_size.height);
    }
}

/// 更新标签样式页码指示器
/// @param indicator 标签样式页码指示器
/// @param index 页码指示器对应的索引值
- (void)updateTextualIndicator:(SeedPageControlGraphicIndicator *)indicator atIndex:(NSInteger)index {
    
    indicator.frame = CGRectMake(0.0f, 0.0f, _s_appearance.s_size.width, _s_appearance.s_size.height);
    // 背景色
    indicator.backgroundColor = _s_appearance.s_backgroundColor;
    // 切圆角
    indicator.layer.cornerRadius = 0.1f * MIN(_s_appearance.s_size.width, _s_appearance.s_size.height);
    indicator.layer.masksToBounds = YES;
    
    indicator.s_imageView.image = _s_appearance.s_image;
    indicator.s_textLabel.textColor = _s_appearance.s_textColor;
    indicator.s_textLabel.font = _s_appearance.s_textFont;
    
    indicator.s_textLabel.text = [NSString stringWithFormat:@"%@/%@",@(index + 1),@(_s_totalPages)];
}

#pragma mark ------------------------ <setter & getter> ------------------------

#pragma mark - setter

- (void)setS_totalPages:(NSInteger)s_totalPages {
    
    _s_totalPages = s_totalPages;
    
    // 重置所有页码标识视图
    [self resetAllIndicators];
}

- (void)setS_currentPage:(NSInteger)s_currentPage {
    
    // 总页数为0或当前页就是当前页
    if (0 == self.s_totalPages || s_currentPage == _s_currentPage) {
        
        return;
    }
    
    _s_currentPage = s_currentPage;
    
    // 刷新页码指示器状态
    [self checkStateAtIndex:s_currentPage];
}

- (void)setS_appearance:(SeedPageControlAppearance *)s_appearance {
    
    _s_appearance = s_appearance;
    
    // 重置所有页码标识视图
    [self resetAllIndicators];
}

#pragma mark - getter

- (SeedPageControlGraphicIndicator *)textualIndicator {
    
    if (!_textualIndicator) {
        
        _textualIndicator = [[SeedPageControlGraphicIndicator alloc] init];
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
