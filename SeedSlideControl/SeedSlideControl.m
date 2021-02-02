//
//  SeedSlideControl.m
//  SeedSlideControl
//
//  Created by Hao on 2020/11/19.
//  Copyright © 2020 GuanQinghao. All rights reserved.
//

#import "SeedSlideControl.h"
#import "seedPageControl.h"
#import "SeedSlideControlGraphicCollectionViewCell.h"
#import "SeedSlideControlZoomableCollectionViewCell.h"


/// 控制台打印
#ifdef DEBUG
#define NSLog(format, ...)  printf("[%s] [%s] %s [%d] %s\n",[[[NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSinceNow:(8 * 60 * 60)]] substringToIndex:19] UTF8String],[[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String],[[NSString stringWithUTF8String:__FUNCTION__] UTF8String],__LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])
#else
#define NSLog(...)
#endif


/// 唯一标识
static NSString *kSlideControlCollectionViewCellKey = @"kSlideControlCollectionViewCellKey";


/// 滑动视图的手动拖拽方向
typedef NS_ENUM(NSUInteger, UIScrollViewScrollingDirection) {
    
    /// 向上拖拽
    UIScrollViewScrollingDirectionUp,
    /// 向下拖拽
    UIScrollViewScrollingDirectionDown,
    /// 向左拖拽
    UIScrollViewScrollingDirectionLeft,
    /// 向右拖拽
    UIScrollViewScrollingDirectionRight,
};


@interface SeedSlideControl () <
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout> {
    
    //MARK:判断滑动方向
    /// 记录滚动视图最后一次偏移量
    CGPoint lastContentOffset;
    /// 滚动视图的滚动方向
    UIScrollViewScrollingDirection scrollingDirection;
}

/// 集合视图布局
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/// 集合视图
@property (nonatomic, strong) UICollectionView *slideCollectionView;
/// 分页控件
@property (nonatomic, strong) SeedPageControl *pageControl;

/// 定时器
@property (nonatomic, weak) NSTimer *timer;

/// 轮播内容的个数
@property (nonatomic, assign) NSInteger itemCount;
/// 当前索引值
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

@implementation SeedSlideControl

#pragma mark --------------------------- <lifecycle> ---------------------------

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 轮播控件外观属性
        _s_slideControlAppearance = [[SeedSlideControlAppearance alloc] init];
        // 分页控件外观属性
        _s_pageControlAppearance = [[SeedPageControlAppearance alloc] init];
        
        // 轮播控件
        [self addSubview:self.slideCollectionView];
        // 分页控件
        [self addSubview:self.pageControl];
        [self bringSubviewToFront:self.pageControl];
    }
    
    return self;
}

/// 视图即将加入或移除
/// @param newSuperview 新的父视图, nil 表示移除视图
- (void)willMoveToSuperview:(UIView *)newSuperview {
    NSLog(@"");
    
    // 移除视图, 释放timer
    if (!newSuperview) {
        
        [self invalidateTimer];
    }
}

#pragma mark ---------------------------- <layout> ----------------------------

/// 布局子视图
- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"");
    
    _slideCollectionView.frame = self.bounds;
    _flowLayout.itemSize = self.bounds.size;
    
    if (_itemCount > 0) {
        
        // 根据滚动方向滚动到指定位置, 无限轮播时初始位置为section1
        self.currentIndexPath = _s_slideControlAppearance.s_endless ? [NSIndexPath indexPathForItem:0 inSection:1] : [NSIndexPath indexPathForItem:0 inSection:0];
        [self scrollToItemAtIndexPath:self.currentIndexPath animated:NO];
    }
    
    // 分页控件尺寸
    CGSize size = [_pageControl s_sizeWithPageControlStyle:_s_pageControlAppearance.s_style pages:_itemCount];
    
    // 分页控件的水平位置, 默认居中 (两侧边距10.0f)
    CGFloat x;
    switch (_s_slideControlAppearance.s_alignment) {
            
        case SeedPageControlAlignmentLeft: {
            
            x = 10.0f + _s_slideControlAppearance.s_offset.x;
        }
            break;
        case SeedPageControlAlignmentCenter: {
            
            x = 0.5f * (CGRectGetWidth(self.frame) - size.width);
        }
            break;
        case SeedPageControlAlignmentRight: {
            
            x = CGRectGetWidth(_slideCollectionView.frame) - size.width - 10.0f + _s_slideControlAppearance.s_offset.x;
        }
            break;
    }
    
    // 分页控件的垂向位置
    CGFloat y = CGRectGetHeight(_slideCollectionView.frame) - size.height - 10.0f + _s_slideControlAppearance.s_offset.y;
    
    // 更新分页控件尺寸
    [_pageControl sizeToFit];
    
    // 分页控件
    _pageControl.frame = CGRectMake(x, y, size.width, size.height);
    _pageControl.hidden = !_s_slideControlAppearance.s_showPageControl;
}

#pragma mark --------------------- <delegate & datasource> ---------------------

#pragma mark - UICollectionViewDelegate

/// 集合视图单元格视图已经移除显示范围
/// @param collectionView 集合视图
/// @param cell 单元格视图
/// @param indexPath 单元格索引值
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"");
    
    if (_s_slideControlAppearance.s_style == SeedSlideControlStyleZoomable) {
        
        // 缩放浏览模式, 恢复缩放比例
        SeedSlideControlZoomableCollectionViewCell *internalCell = (SeedSlideControlZoomableCollectionViewCell *)cell;
        [internalCell s_zoomWith:1.0f];
    }
}

#pragma mark - UICollectionViewDataSource

/// 集合视图某组的单元格个数
/// @param collectionView 集合视图
/// @param section 组索引值
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"");
    
    return _itemCount;
}

/// 集合视图组数
/// @param collectionView 集合视图
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSLog(@"");
    
    // 是否无限循环
    return _s_slideControlAppearance.s_endless ? 3 : 1;
}

/// 集合视图的单元格视图
/// @param collectionView 集合视图
/// @param indexPath 单元格索引值
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"");
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSlideControlCollectionViewCellKey forIndexPath:indexPath];
    
    if ([self.s_delegate respondsToSelector:@selector(s_slideControl:setCustomCell:atIndex:)] && [self.s_delegate respondsToSelector:@selector(s_customCollectionViewCellClassForSlideControl:)] && [self.s_delegate s_customCollectionViewCellClassForSlideControl:self]) {
        
        // 自定义轮播控件集合视图的单元格视图
        [self.s_delegate s_slideControl:self setCustomCell:cell atIndex:indexPath.item];
        
        return cell;
    } else {
        
        switch (_s_slideControlAppearance.s_style) {
            case SeedSlideControlStyleGraphic: {
                
                // 轮播控件类型-图文正常轮播
                SeedSlideControlGraphicCollectionViewCell *internalCell = (SeedSlideControlGraphicCollectionViewCell *)cell;
                
                internalCell.s_labelTextFont = _s_slideControlAppearance.s_labelTextFont;
                internalCell.s_labelTextColor = _s_slideControlAppearance.s_labelTextColor;
                internalCell.s_labelBackgroundColor = _s_slideControlAppearance.s_labelBackgroundColor;
                internalCell.s_labelTextAlignment = _s_slideControlAppearance.s_labelTextAlignment;
                internalCell.s_placeholder = _s_slideControlAppearance.s_placeholder;
                internalCell.s_progressMode = _s_slideControlAppearance.s_progressMode;
                internalCell.s_contentMode = _s_slideControlAppearance.s_contentMode;
                internalCell.s_onlyText = _s_slideControlAppearance.s_onlyText;
                internalCell.s_asset = _s_dataSource[indexPath.item];
                
                return internalCell;
            }
                break;
            case SeedSlideControlStyleZoomable: {
                
                // 轮播控件类型-图片缩放浏览
                SeedSlideControlZoomableCollectionViewCell *internalCell = (SeedSlideControlZoomableCollectionViewCell *)cell;
                
                internalCell.s_placeholder = _s_slideControlAppearance.s_placeholder;
                internalCell.s_progressMode = _s_slideControlAppearance.s_progressMode;
                internalCell.s_maximumZoomScale = _s_slideControlAppearance.s_maximumZoomScale;
                internalCell.s_asset = _s_dataSource[indexPath.item];
                internalCell.s_onClick = ^(id  _Nullable sender) {
                    
                    if ([self.s_delegate respondsToSelector:@selector(s_slideControl:didSelectItemAtIndex:)]) {
                        
                        [self.s_delegate s_slideControl:self didSelectItemAtIndex:indexPath.item];
                    }
                    
                    if (self.s_selectItemMonitorBlock) {
                        
                        self.s_selectItemMonitorBlock(indexPath.item);
                    }
                };
                
                return internalCell;
            }
                break;
        }
    }
}

/// 点击集合视图某个单元格视图
/// @param collectionView 集合视图
/// @param indexPath 选中的单元格视图索引值
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"");
    
    if ([self.s_delegate respondsToSelector:@selector(s_slideControl:didSelectItemAtIndex:)]) {

        // 代理回调
        [self.s_delegate s_slideControl:self didSelectItemAtIndex:indexPath.item];
    }
    
    if (self.s_selectItemMonitorBlock) {

        // block回调
        self.s_selectItemMonitorBlock(indexPath.item);
    }
}

#pragma mark - UIScrollViewDelegate

/// 视图已经滚动
/// @param scrollView 滚动视图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"");
    
    if (_itemCount > 0) {
        
        // 分页指示器页码
        _pageControl.s_currentPage = self.currentIndexPath.item;
    }
}

/// 视图将要开始拖动
/// @param scrollView 滚动视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"");
    
    // 记录滑动前的contentOffset
    lastContentOffset = scrollView.contentOffset;
    
    // 开始手动拖动销毁定时器
    [self invalidateTimer];
}

/// 视图已经结束拖动
/// @param scrollView 滚动视图
/// @param decelerate 减速度
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"");
    
    // 判断手滑动的方向
    switch (self.flowLayout.scrollDirection) {
            
        case UICollectionViewScrollDirectionVertical: {
            
            // 垂直滑动
            if (scrollView.contentOffset.y < lastContentOffset.y ){
                
                // 向下
                scrollingDirection = UIScrollViewScrollingDirectionDown;
            } else {
                // 向上
                scrollingDirection = UIScrollViewScrollingDirectionUp;
            }
        }
            break;
        case UICollectionViewScrollDirectionHorizontal: {
            
            // 水平滑动
            if (scrollView.contentOffset.x < lastContentOffset.x ){
                
                // 向右
                scrollingDirection = UIScrollViewScrollingDirectionRight;
            } else {
                // 向左
                scrollingDirection = UIScrollViewScrollingDirectionLeft;
            }
        }
            
            break;
    }
    
    // 计算索引值
    switch (scrollingDirection) {
        case UIScrollViewScrollingDirectionUp:
        case UIScrollViewScrollingDirectionLeft: {
            
            // 向上向左
            NSInteger section = self.currentIndexPath.section;
            NSInteger item = self.currentIndexPath.item + 1;
            if (item >= _itemCount) {
                
                section = _s_slideControlAppearance.s_endless ? (section + 1) : 0;
                item = _s_slideControlAppearance.s_endless ? 0 : (_itemCount - 1);
            }
            
            self.currentIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
        }
            break;
        case UIScrollViewScrollingDirectionDown:
        case UIScrollViewScrollingDirectionRight: {
            
            // 向下向右
            NSInteger section = self.currentIndexPath.section;
            NSInteger item = self.currentIndexPath.item - 1;
            if (item < 0) {
                
                section = _s_slideControlAppearance.s_endless ? (section - 1) : 0;
                item = _s_slideControlAppearance.s_endless ? (_itemCount - 1) : 0;
            }
            
            self.currentIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
        }
            break;
    }
    
    if (_s_slideControlAppearance.s_style == SeedSlideControlStyleGraphic) {
        
        // 视图拖动结束创建定时器
        [self setupTimer];
    }
    
    // 滚动到指定索引值
    [self scrollToItemAtIndexPath:self.currentIndexPath animated:YES];
}

/// 视图滚动过渡动画
/// @param scrollView 滚动视图
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"");
    
    // 当前页码
    _pageControl.s_currentPage = self.currentIndexPath.item;
    
    if (_s_slideControlAppearance.s_endless) {
        
        // 保证显示区域为Section1
        if (0 == self.currentIndexPath.section || 2 == self.currentIndexPath.section) {
            
            self.currentIndexPath = [NSIndexPath indexPathForItem:self.currentIndexPath.item inSection:1];
        }
        
        switch (_flowLayout.scrollDirection) {
                
            case UICollectionViewScrollDirectionHorizontal: {
                
                [_slideCollectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            }
                break;
            case UICollectionViewScrollDirectionVertical: {
                
                [_slideCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndexPath.item inSection:1] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
            }
                break;
        }
    }
    
    if ([self.s_delegate respondsToSelector:@selector(s_slideControl:didScrollToIndex:)]) {
        
        // 轮播图滑动结束代理回调
        [self.s_delegate s_slideControl:self didScrollToIndex:self.currentIndexPath.item];
    }
    
    if (self.s_scrollToItemMonitorBlock) {
        
        // 轮播图滑动结束block回调
        self.s_scrollToItemMonitorBlock(self.currentIndexPath.item);
    }
}

#pragma mark ---------------------------- <method> ----------------------------

#pragma mark - public method

/// 轮播控件滚动到指定索引值
/// @param slideControl 轮播控件
/// @param index 指定索引值
- (void)s_slideControl:(SeedSlideControl *)slideControl scrollToIndex:(NSInteger)index {
    NSLog(@"");
    
    if (_itemCount > 0) {
            
        // 根据滚动方向滚动到指定位置
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:self.currentIndexPath.section] animated:YES];
    }
}

#pragma mark - target method

#pragma mark - private method

/// 释放定时器
- (void)invalidateTimer {
    NSLog(@"");
    
    // 如果timer存在 则暂停timer并置为nil
    if (_timer) {
        
        [_timer invalidate];
        _timer = nil;
    }
}

/// 设置定时器
- (void)setupTimer {
    NSLog(@"");
    
    // 销毁定时器
    [self invalidateTimer];
    
    // 创建定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:_s_slideControlAppearance.s_timeInterval target:self selector:@selector(startAutomaticScrolling) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/// 根据滚动方向滚动到指定位置
/// @param indexPath 指定单元格索引值
- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    NSLog(@"");
    
    switch (_flowLayout.scrollDirection) {
            
        case UICollectionViewScrollDirectionHorizontal: {
            
            [_slideCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
        }
            break;
        case UICollectionViewScrollDirectionVertical: {
            
            [_slideCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:animated];
        }
            break;
    }
}

/// 轮播图开始自动滚动
- (void)startAutomaticScrolling {
    NSLog(@"");
    
    if (!_s_slideControlAppearance.s_endless) {
        
        return;
    }
    
    if (!_s_slideControlAppearance.s_scrollEnabled) {
        
        return;
    }
    
    if (0 == _itemCount) {
        
        return;
    }
    
    NSInteger section = self.currentIndexPath.section;
    NSInteger item = self.currentIndexPath.item + 1;
    if (item >= _itemCount) {
        
        section = section + 1;
        item = 0;
    }
    self.currentIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
    
    // 根据滚动方向滚动到指定位置
    [self scrollToItemAtIndexPath:self.currentIndexPath animated:YES];
}

#pragma mark ------------------------ <setter & getter> ------------------------

#pragma mark - setter

- (void)setS_dataSource:(NSArray<NSString *> *)s_dataSource {
    
    _s_dataSource = s_dataSource;
    
    _itemCount = s_dataSource.count;
    _pageControl.s_totalPages = s_dataSource.count;
    [_slideCollectionView reloadData];
}

- (void)setS_delegate:(id<SeedSlideControlDelegate>)s_delegate {
    
    _s_delegate = s_delegate;
    
    if ([self.s_delegate respondsToSelector:@selector(s_customCollectionViewCellClassForSlideControl:)]) {
        
        // 注册自定义Cell
        Class customClass = [self.s_delegate s_customCollectionViewCellClassForSlideControl:self];
        
        if (customClass) {
            
            [self.slideCollectionView registerClass:customClass forCellWithReuseIdentifier:kSlideControlCollectionViewCellKey];
        }
    }
}

- (void)setS_slideControlAppearance:(SeedSlideControlAppearance *)s_slideControlAppearance {
    NSLog(@"");
    
    _s_slideControlAppearance = s_slideControlAppearance;
    
    // 类型
    switch (s_slideControlAppearance.s_style) {
        case SeedSlideControlStyleGraphic: {
            
            [_slideCollectionView registerClass:SeedSlideControlGraphicCollectionViewCell.class forCellWithReuseIdentifier:kSlideControlCollectionViewCellKey];
        }
            break;
        case SeedSlideControlStyleZoomable: {
            
            [_slideCollectionView registerClass:SeedSlideControlZoomableCollectionViewCell.class forCellWithReuseIdentifier:kSlideControlCollectionViewCellKey];
        }
            break;
    }
    
    // 定时器
    [_slideCollectionView reloadData];
    if (s_slideControlAppearance.s_timeInterval > 0.0f) {
        
        [self setupTimer];
    }
    
    // 是否可以滚动
    _slideCollectionView.scrollEnabled = s_slideControlAppearance.s_scrollEnabled;
    
    // 滚动方向
    _flowLayout.scrollDirection = s_slideControlAppearance.s_scrollDirection;
}

- (void)setS_pageControlAppearance:(SeedPageControlAppearance *)s_pageControlAppearance {
    NSLog(@"");
    
    _s_pageControlAppearance = s_pageControlAppearance;
    _pageControl.s_appearance = s_pageControlAppearance;
    
    [self layoutIfNeeded];
}

#pragma mark - getter

- (UICollectionView *)slideCollectionView {
    
    if (!_slideCollectionView) {
        
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0.0f;
        _flowLayout.minimumInteritemSpacing = 0.0f;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _slideCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
        _slideCollectionView.delegate = self;
        _slideCollectionView.dataSource = self;
        _slideCollectionView.scrollEnabled = YES;
        _slideCollectionView.pagingEnabled = YES;
        _slideCollectionView.showsVerticalScrollIndicator = NO;
        _slideCollectionView.showsHorizontalScrollIndicator = NO;
        _slideCollectionView.backgroundColor = [UIColor clearColor];
        [_slideCollectionView registerClass:SeedSlideControlGraphicCollectionViewCell.class forCellWithReuseIdentifier:kSlideControlCollectionViewCellKey];
        _slideCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    return _slideCollectionView;
}

- (SeedPageControl *)pageControl {
    
    if (!_pageControl) {
        
        _pageControl = [[SeedPageControl alloc] init];
        _pageControl.s_appearance = _s_pageControlAppearance;
    }
    
    return _pageControl;
}

@end
