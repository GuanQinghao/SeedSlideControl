//
//  SeedSlideView.m
//  SeedSlideControl
//
//  Created by Hao on 2020/11/19.
//  Copyright © 2020 GuanQinghao. All rights reserved.
//

#import "SeedSlideView.h"
#import "SeedSlideViewCollectionViewCell.h"
#import "SeedPageControl.h"
#import "UIImageView+WebCache.h"


/// 唯一标识
static NSString *kSlideViewCollectionViewCellKey = @"kSlideViewCollectionViewCellKey";


/// 滑动视图的手动拖拽方向
typedef NS_ENUM(NSUInteger, UIScrollViewScrollingDirection) {
    
    UIScrollViewScrollingDirectionUp,
    UIScrollViewScrollingDirectionDown,
    UIScrollViewScrollingDirectionLeft,
    UIScrollViewScrollingDirectionRight,
};


@interface SeedSlideView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    
    //MARK:判断滑动方向
    // 记录滚动视图最后一次偏移量
    CGPoint lastContentOffset;
    // 滚动视图的滚动方向
    UIScrollViewScrollingDirection scrollingDirection;
}

/// 轮播图集合视图
@property (nonatomic, strong) UICollectionView *slideCollectionView;
/// 集合视图布局
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/// 分页控件
@property (nonatomic, strong) SeedPageControl *pageControl;
/// 背景图片视图
@property (nonatomic, strong) UIImageView *backgroundImageView;
/// 定时器
@property (nonatomic, weak) NSTimer *timer;
/// 轮播内容的个数
@property (nonatomic, assign) NSInteger itemCount;
/// 当前索引值
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

@implementation SeedSlideView

/// 轮播图滚动到指定索引值
/// @param slideView 轮播图
/// @param index 指定索引值
- (void)s_slideView:(SeedSlideView *)slideView scrollToIndex:(NSInteger)index {
    
    if (0 == _itemCount) {
        
        return;
    }
    
    // 根据滚动方向滚动到指定位置
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:self.currentIndexPath.section] animated:YES];
}

#pragma mark --------------------------- <lifecycle> ---------------------------

/// 初始化
/// @param frame N/A
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 轮播图背景色
        self.backgroundColor = UIColor.lightGrayColor;
        
        //MARK:设置默认值
        /// 轮播图是否可以滚动, 默认YES
        _s_scrollEnabled = YES;
        // 轮播时间间隔3秒
        _s_timeInterval = 3.0f;
        // 轮播图图片内容显示方式
        _s_slideViewContentMode = UIViewContentModeScaleToFill;
        // 分页控件外观
        _s_appearance = [[SeedPageControlAppearance alloc] init];
        
        // 配置轮播集合视图
        [self setupSlideCollectionView];
        
        // 配置分页控件
        [self setupPageControl];
    }
    
    return self;
}

/// 配置轮播集合视图
- (void)setupSlideCollectionView {
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.minimumLineSpacing = 0.0f;
    _flowLayout.minimumInteritemSpacing = 0.0f;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _slideCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
    _slideCollectionView.delegate = self;
    _slideCollectionView.dataSource = self;
    _slideCollectionView.scrollEnabled = YES;
    _slideCollectionView.pagingEnabled = YES;
    _slideCollectionView.showsVerticalScrollIndicator = NO;
    _slideCollectionView.showsHorizontalScrollIndicator = NO;
    _slideCollectionView.backgroundColor = [UIColor clearColor];
    [_slideCollectionView registerClass:SeedSlideViewCollectionViewCell.class forCellWithReuseIdentifier:kSlideViewCollectionViewCellKey];
    _slideCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self addSubview:_slideCollectionView];
}

/// 设置分页控件
- (void)setupPageControl {
    
    // 先移除分页控件
    if (_pageControl) {
        
        [_pageControl removeFromSuperview];
    }
    
    if (0 == _itemCount) {
        
        return;
    }
    
    [self addSubview:self.pageControl];
    [self bringSubviewToFront:self.pageControl];
    
    // 轮播图总页数
    _pageControl.s_totalPages = _itemCount;
}

/// 布局子视图
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _backgroundImageView.frame = self.bounds;
    _slideCollectionView.frame = self.bounds;
    _flowLayout.itemSize = self.bounds.size;
    
    if (_itemCount > 0) {
        
        // 根据滚动方向滚动到指定位置, 初始位置为section1
        self.currentIndexPath = [NSIndexPath indexPathForItem:0 inSection:1];
        [self scrollToItemAtIndexPath:self.currentIndexPath animated:NO];
    }
    
    // 分页控件尺寸
    CGSize size = [_pageControl s_sizeWithPageControlStyle:_s_appearance.s_style pages:_itemCount];
    
    // 分页控件的水平位置, 默认居中 (两侧边距10.0f)
    CGFloat x;
    switch (_s_appearance.s_alignment) {
            
        case SeedPageControlAlignmentLeft: {
            
            x = 10.0f + _s_appearance.s_pageControlOffset.x;
        }
            break;
        case SeedPageControlAlignmentCenter: {
            
            x = (CGRectGetWidth(self.frame) - size.width) * 0.5f ;
        }
            break;
        case SeedPageControlAlignmentRight: {
            
            x = CGRectGetWidth(_slideCollectionView.frame) - size.width - 10.0f + _s_appearance.s_pageControlOffset.x;
        }
            break;
    }
    
    // 分页控件的垂向位置
    CGFloat y = CGRectGetHeight(_slideCollectionView.frame) - size.height - 10.0f + _s_appearance.s_pageControlOffset.y;
    
    // 更新分页控件尺寸
    [_pageControl sizeToFit];
    
    // 分页控件
    _pageControl.frame = CGRectMake(x, y, size.width, size.height);
    _pageControl.hidden = !_s_appearance.s_showPageControl;
}

/// N/A
/// @param newSuperview N/A
- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    // 父视图释放, 释放timer
    if (!newSuperview) {
        
        [self invalidateTimer];
    }
}

#pragma mark --------------------- <delegate & datasource> ---------------------
#pragma mark - UICollectionViewDataSource

/// 集合视图某组的单元格个数
/// @param collectionView 集合视图
/// @param section 组索引值
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _itemCount;
}

/// 集合视图组数
/// @param collectionView 集合视图
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    // 固定值
    return 3;
}

/// 集合视图的单元格视图
/// @param collectionView 集合视图
/// @param indexPath 单元格索引值
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSlideViewCollectionViewCellKey forIndexPath:indexPath];
    
    if ([self.s_delegate respondsToSelector:@selector(s_setupCustomCell:forIndex:slideView:)] && [self.s_delegate respondsToSelector:@selector(s_customCollectionViewCellClassForSlideView:)] && [self.s_delegate s_customCollectionViewCellClassForSlideView:self]) {
        
        // 自定义轮播图集合视图的单元格视图(代码)
        [self.s_delegate s_setupCustomCell:cell forIndex:indexPath.item slideView:self];
        
        return cell;
    } else {
        
        SeedSlideViewCollectionViewCell *internalCell = (SeedSlideViewCollectionViewCell *)cell;
        
        // 默认只显示图片, 数据源为图片数组: 图片URL字符串、图片对象、图片名称或图片路径
        NSString *imagePath = _s_imageArray[indexPath.item];
        if ([imagePath isKindOfClass:NSString.class]) {
            
            if ([imagePath hasPrefix:@"http"]) {
                
                // URL字符串
                [internalCell.s_imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:_s_placeholderImage];
            } else {
                
                // 图片名称
                UIImage *image = [UIImage imageNamed:imagePath];
                if (!image) {
                    
                    // 本地图片路径
                    image = [UIImage imageWithContentsOfFile:imagePath];
                }
                
                internalCell.s_imageView.image = image;
            }
        } else if ([imagePath isKindOfClass:UIImage.class]) {
            
            // 图片对象
            internalCell.s_imageView.image = (UIImage *)imagePath;
        } else {
            
            // 轮播图资源文件未知
            internalCell.s_imageView.image = _s_placeholderImage;
            NSLog(@"轮播图资源文件未知:%s--%d",__func__,__LINE__);
        }
        
        // 图片填充模式
        internalCell.s_imageView.contentMode = _s_slideViewContentMode;
        internalCell.clipsToBounds = YES;
        
        return internalCell;
    }
}

/// 点击集合视图某个单元格视图
/// @param collectionView 集合视图
/// @param indexPath 选中的单元格视图索引值
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.s_delegate respondsToSelector:@selector(s_slideView:didSelectItemAtIndex:)]) {

        // 代理回调
        [self.s_delegate s_slideView:self didSelectItemAtIndex:indexPath.item];
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
    
    if (_itemCount > 0) {
        
        // 分页指示器页码
        _pageControl.s_currentPage = self.currentIndexPath.item;
    }
}

/// 视图将要开始拖动
/// @param scrollView 滚动视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    // 记录滑动前的contentOffset
    lastContentOffset = scrollView.contentOffset;
    
    // 开始手动拖动销毁定时器
    [self invalidateTimer];
}

/// 视图已经结束拖动
/// @param scrollView 滚动视图
/// @param decelerate 减速度
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
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
                
                section = section + 1;
                item = 0;
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
                
                section = section - 1;
                item = _itemCount - 1;
            }
            
            self.currentIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
        }
            break;
    }
    
    // 视图拖动结束创建定时器
    [self setupTimer];
    
    // 滚动到指定索引值
    [self scrollToItemAtIndexPath:self.currentIndexPath animated:YES];
}

/// 视图滚动过渡动画
/// @param scrollView 滚动视图
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    // 当前页码
    _pageControl.s_currentPage = self.currentIndexPath.item;
    
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
    
    if ([self.s_delegate respondsToSelector:@selector(s_slideView:didScrollToIndex:)]) {
        
        // 轮播图滑动结束代理回调
        [self.s_delegate s_slideView:self didScrollToIndex:self.currentIndexPath.item];
    }
    
    if (self.s_scrollToItemMonitorBlock) {
        
        // 轮播图滑动结束block回调
        self.s_scrollToItemMonitorBlock(self.currentIndexPath.item);
    }
}

#pragma mark ---------------------------- <method> ----------------------------

#pragma mark - private method

/// 释放定时器
- (void)invalidateTimer {
    
    // 如果timer存在 则暂停timer并置为nil
    if (_timer) {
        
        [_timer invalidate];
        _timer = nil;
    }
}

/// 设置定时器
- (void)setupTimer {
    
    // 销毁定时器
    [self invalidateTimer];
    
    // 创建定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:_s_timeInterval target:self selector:@selector(startAutomaticScrolling) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/// 根据滚动方向滚动到指定位置
/// @param indexPath 指定单元格索引值
- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    
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
    
    if (!_s_scrollEnabled) {
        
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

/// 重置数据源
- (void)resetDataSource {
    
    _slideCollectionView.scrollEnabled = YES;
    
    // 重新设置分页控件
    [self setupPageControl];
    
    // 集合视图重新加载数据源
    [_slideCollectionView reloadData];
}

#pragma mark ------------------------ <setter & getter> ------------------------

#pragma mark - setter

- (void)setS_data:(NSArray *)s_data {
    
    _s_data = s_data;
    
    _itemCount = s_data.count;
    
    // 重置数据源
    [self resetDataSource];
}

- (void)setS_imageArray:(NSArray *)s_imageArray {
    
    // image or imageName or imagePath or imageURL or imageURLString
    _s_imageArray = s_imageArray;
    
    _itemCount = s_imageArray.count;
    
    // 重置数据源
    [self resetDataSource];
}

- (void)setS_delegate:(id<SeedSlideViewDelegate>)s_delegate {
    
    _s_delegate = s_delegate;
    
    if ([self.s_delegate respondsToSelector:@selector(s_customCollectionViewCellClassForSlideView:)]) {
        
        // 注册自定义Cell
        Class customClass = [self.s_delegate s_customCollectionViewCellClassForSlideView:self];
        
        if (customClass) {
            
            [self.slideCollectionView registerClass:customClass forCellWithReuseIdentifier:kSlideViewCollectionViewCellKey];
        }
    }
}

- (void)setS_scrollEnabled:(BOOL)s_scrollEnabled {
    
    _s_scrollEnabled = s_scrollEnabled;
    
    _slideCollectionView.scrollEnabled = s_scrollEnabled;
}

- (void)setS_timeInterval:(CGFloat)s_timeInterval {
    
    _s_timeInterval = s_timeInterval;
    
    [_slideCollectionView reloadData];
    
    if (s_timeInterval > 0.0f) {
        
        [self setupTimer];
    }
}

- (void)setS_scrollDirection:(UICollectionViewScrollDirection)s_scrollDirection {
    
    _s_scrollDirection = s_scrollDirection;
    
    _flowLayout.scrollDirection = s_scrollDirection;
}

- (void)setS_placeholderImage:(UIImage *)s_placeholderImage {
    
    _s_placeholderImage = s_placeholderImage;
    
    if (!_backgroundImageView) {
        
        UIImageView *backgroundView = [[UIImageView alloc] init];
        backgroundView.userInteractionEnabled = YES;
        backgroundView.contentMode = UIViewContentModeScaleToFill;
        [self insertSubview:backgroundView belowSubview:_slideCollectionView];
        _backgroundImageView = backgroundView;
    }
    
    _backgroundImageView.image = s_placeholderImage;
}

- (void)setS_appearance:(SeedPageControlAppearance *)s_appearance {
    
    _s_appearance = s_appearance;
    
    _pageControl.s_appearance = s_appearance;
    
    [self layoutIfNeeded];
}

#pragma mark - getter

- (SeedPageControl *)pageControl {
    
    if (!_pageControl) {
        
        _pageControl = [[SeedPageControl alloc] init];
        _pageControl.s_appearance = _s_appearance;
    }
    
    return _pageControl;
}

@end
