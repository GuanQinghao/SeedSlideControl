//
//  GQHSlideView.m
//  Seed
//
//  Created by GuanQinghao on 13/12/2017.
//  Copyright © 2017 GuanQinghao. All rights reserved.
//

#import "GQHSlideView.h"
#import "GQHSlideViewCollectionViewCell.h"
#import "GQHPageControl.h"
#import "UIImageView+WebCache.h"


/// 唯一标识
static NSString *kSlideViewCollectionViewCellKey = @"GQHSlideViewCollectionViewCell";

@interface GQHSlideView () <UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,GQHPageControlDelegate>

/// 轮播图集合视图
@property (nonatomic, strong) UICollectionView *slideCollectionView;
/// 集合视图布局
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/// 分页控件
@property (nonatomic, strong) GQHPageControl *pageControl;
/// 背景图片视图
@property (nonatomic, strong) UIImageView *backgroundImageView;
/// 定时器
@property (nonatomic, weak) NSTimer *timer;
/// 轮播内容的个数
@property (nonatomic, assign) NSInteger itemCount;

@end

@implementation GQHSlideView

/// 轮播图滚动到指定索引值
/// @param slideView 轮播图
/// @param index 指定索引值
- (void)qh_slideView:(GQHSlideView *)slideView scrollToIndex:(NSInteger)index {
    NSLog(@"%s", __func__);
    
    if (0 == _itemCount) {
        
        return;
    }
    
    // 当前轮播图的索引值
    NSIndexPath *indexPath = [self currentIndexPath];
    
    // 根据滚动方向滚动到指定位置
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:indexPath.section] animated:YES];
}

#pragma mark - LifeCycle

/// 初始化
/// @param frame N/A
- (instancetype)initWithFrame:(CGRect)frame {
    NSLog(@"%s", __func__);
    
    if (self = [super initWithFrame:frame]) {
        
        // 轮播图背景色
        self.backgroundColor = UIColor.lightGrayColor;
        
        // 轮播时间间隔3秒
        _qh_timeInterval = 3.0f;
        
        // 轮播图图片内容显示方式
        _qh_slideViewContentMode = UIViewContentModeScaleToFill;
        
        // 分页控件外观
        _qh_appearance = [[GQHPageControlAppearance alloc] init];
        
        // 配置轮播集合视图
        [self setupSlideCollectionView];
        
        // 配置分页控件
        [self setupPageControl];
    }
    
    return self;
}

/// 配置轮播集合视图
- (void)setupSlideCollectionView {
    NSLog(@"%s", __func__);
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.minimumLineSpacing = 0.0f;
    _flowLayout.minimumInteritemSpacing = 0.0f;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _slideCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
    _slideCollectionView.delegate = self;
    _slideCollectionView.dataSource = self;
    _slideCollectionView.pagingEnabled = YES;
    _slideCollectionView.showsVerticalScrollIndicator = NO;
    _slideCollectionView.showsHorizontalScrollIndicator = NO;
    _slideCollectionView.backgroundColor = [UIColor clearColor];
    [_slideCollectionView registerClass:[GQHSlideViewCollectionViewCell class] forCellWithReuseIdentifier:kSlideViewCollectionViewCellKey];
    [self addSubview:_slideCollectionView];
}

/// 设置分页控件
- (void)setupPageControl {
    NSLog(@"%s", __func__);
    
    // 先移除分页控件
    if (_pageControl) {
        
        [_pageControl removeFromSuperview];
    }
    
    if (0 == _itemCount) {
        
        return;
    }
    
    _pageControl.qh_delegate = self;
    [self addSubview:self.pageControl];
    [self bringSubviewToFront:self.pageControl];
    
    // 轮播图总页数
    _pageControl.qh_totalPages = _itemCount;
}

/// 布局子视图
- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"%s", __func__);
    
    _backgroundImageView.frame = self.bounds;
    _slideCollectionView.frame = self.bounds;
    // 单元格大小
    _flowLayout.itemSize = self.bounds.size;
    if (_qh_itemSize.width > 0 && _qh_itemSize.height > 0) {
        
        _flowLayout.itemSize = _qh_itemSize;
    }
    
    if (_itemCount > 0) {
        
        // 根据滚动方向滚动到指定位置, 初始位置为section1
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] animated:NO];
    }
    
    // 分页控件尺寸
    CGSize size = [_pageControl qh_sizeWithPageControlStyle:_qh_appearance.qh_style pages:_itemCount];
    
    // 分页控件的水平位置, 默认居中 (两侧边距10.0f)
    CGFloat x;
    switch (_qh_appearance.qh_alignment) {
            
        case GQHPageControlAlignmentLeft: {
            
            x = 10.0f + _qh_appearance.qh_pageControlOffset.x;
        }
            break;
        case GQHPageControlAlignmentCenter: {
            
            x = (CGRectGetWidth(self.frame) - size.width) * 0.5f ;
        }
            break;
        case GQHPageControlAlignmentRight: {
            
            x = CGRectGetWidth(_slideCollectionView.frame) - size.width - 10.0f + _qh_appearance.qh_pageControlOffset.x;
        }
            break;
    }
    
    // 分页控件的垂向位置
    CGFloat y = CGRectGetHeight(_slideCollectionView.frame) - size.height - 10.0f + _qh_appearance.qh_pageControlOffset.y;
    
    // 更新分页控件尺寸
    [_pageControl sizeToFit];
    
    // 分页控件
    _pageControl.frame = CGRectMake(x, y, size.width, size.height);
    _pageControl.hidden = !_qh_appearance.qh_showPageControl;
}

/// N/A
/// @param newSuperview N/A
- (void)willMoveToSuperview:(UIView *)newSuperview {
    NSLog(@"%s", __func__);
    
    // 父视图释放, 释放timer
    if (!newSuperview) {
        
        [self invalidateTimer];
    }
}

#pragma mark - UICollectionViewDataSource

/// 集合视图某组的单元格个数
/// @param collectionView 集合视图
/// @param section 组索引值
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%s", __func__);
    
    return _itemCount;
}

/// 集合视图组数
/// @param collectionView 集合视图
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSLog(@"%s", __func__);
    
    // 固定值
    return 3;
}

/// 集合视图的单元格视图
/// @param collectionView 集合视图
/// @param indexPath 单元格索引值
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSlideViewCollectionViewCellKey forIndexPath:indexPath];
    
    if ([self.qh_delegate respondsToSelector:@selector(qh_setupCustomCell:forIndex:slideView:)] && [self.qh_delegate respondsToSelector:@selector(qh_customCollectionViewCellClassForSlideView:)] && [self.qh_delegate qh_customCollectionViewCellClassForSlideView:self]) {
        
        // 自定义轮播图集合视图的单元格视图(代码)
        [self.qh_delegate qh_setupCustomCell:cell forIndex:indexPath.item slideView:self];
        
        return cell;
    } else {
        
        GQHSlideViewCollectionViewCell *imageCell = (GQHSlideViewCollectionViewCell *)cell;
        
        // 默认只显示图片, 数据源为图片数组: 图片URL字符串、图片对象、图片名称或图片路径
        NSString *imagePath = _qh_imageArray[indexPath.item];
        if ([imagePath isKindOfClass:NSString.class]) {
            
            if ([imagePath hasPrefix:@"http"]) {
                
                // URL字符串
                [imageCell.qh_imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:_qh_placeholderImage];
            } else {
                
                // 图片名称
                UIImage *image = [UIImage imageNamed:imagePath];
                if (!image) {
                    
                    // 本地图片路径
                    image = [UIImage imageWithContentsOfFile:imagePath];
                }
                
                imageCell.qh_imageView.image = image;
            }
        } else if ([imagePath isKindOfClass:UIImage.class]) {
            
            // 图片对象
            imageCell.qh_imageView.image = (UIImage *)imagePath;
        } else {
            
            // 轮播图资源文件未知
            imageCell.qh_imageView.image = _qh_placeholderImage;
            NSLog(@"轮播图资源文件未知:%s--%d",__func__,__LINE__);
        }
        
        // 图片填充模式
        imageCell.qh_imageView.contentMode = _qh_slideViewContentMode;
        imageCell.clipsToBounds = YES;
        
        return imageCell;
    }
}

/// 点击集合视图某个单元格视图
/// @param collectionView 集合视图
/// @param indexPath 选中的单元格视图索引值
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
    
    if ([self.qh_delegate respondsToSelector:@selector(qh_slideView:didSelectItemAtIndex:)]) {

        // 代理回调
        [self.qh_delegate qh_slideView:self didSelectItemAtIndex:indexPath.item];
    } else if (self.selectItemMonitorBlock) {

        // block回调
        self.selectItemMonitorBlock(indexPath.item);
    }
}

#pragma mark - UIScrollViewDelegate
/// 视图已经滚动
/// @param scrollView 滚动视图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_itemCount > 0) {
        
        // 当前轮播图的索引值
        NSIndexPath *indexPath = [self currentIndexPath];
        // 当前页码
        _pageControl.qh_currentPage = indexPath.item;
    }
}

/// 视图将要开始拖动
/// @param scrollView 滚动视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
    
    // 开始手动拖动销毁定时器
    [self invalidateTimer];
}

/// 视图已经结束拖动
/// @param scrollView 滚动视图
/// @param decelerate 减速度
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"%s", __func__);
    
    if (!_timer) {
        
        // 视图拖动结束创建定时器
        [self setupTimer];
    }
    
    // 当前轮播图的索引值
    NSIndexPath *indexPath = [self currentIndexPath];
    
    // 滚动到指定索引值
    [self scrollToItemAtIndexPath:indexPath animated:YES];
}

/// 视图滚动过渡动画
/// @param scrollView 滚动视图
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
    
    // 当前轮播图的索引值
    NSIndexPath *indexPath = [self currentIndexPath];
    
    // 当前页码
    _pageControl.qh_currentPage = indexPath.item;
    
    switch (_flowLayout.scrollDirection) {
            
        case UICollectionViewScrollDirectionHorizontal: {
            
            if (0 == indexPath.section || 2 == indexPath.section) {
                
                [_slideCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:1] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            }
        }
            break;
        case UICollectionViewScrollDirectionVertical: {
            
            if (0 == indexPath.section || 2 == indexPath.section) {
                
                [_slideCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:1] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
            }
        }
            break;
    }
    
    if ([self.qh_delegate respondsToSelector:@selector(qh_slideView:didScrollToIndex:)]) {
        
        // 轮播图滑动结束代理回调
        [self.qh_delegate qh_slideView:self didScrollToIndex:indexPath.item];
    } else if (self.scrollToItemMonitorBlock) {
        
        // 轮播图滑动结束block回调
        self.scrollToItemMonitorBlock(indexPath.item);
    }
}

#pragma mark - PrivateMethod

/// 释放定时器
- (void)invalidateTimer {
    NSLog(@"%s", __func__);
    
    // 如果timer存在 则暂停timer并置为nil
    if (_timer) {
        
        [_timer invalidate];
        _timer = nil;
    }
}

/// 设置定时器
- (void)setupTimer {
    NSLog(@"%s", __func__);
    
    // 销毁定时器
    [self invalidateTimer];
    
    // 创建定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:_qh_timeInterval target:self selector:@selector(startAutomaticScrolling) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/// 根据滚动方向滚动到指定位置
/// @param indexPath 指定单元格索引值
- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    NSLog(@"%s", __func__);
    
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
    NSLog(@"%s", __func__);
    
    if (0 == _itemCount) {
        
        return;
    }
    
    // 当前轮播图的索引值
    NSIndexPath *currentIndexPath = [self currentIndexPath];
    // 轮播图目标索引值
    NSIndexPath *targetIndex;
    
    if (_itemCount == (currentIndexPath.item + 1)) {
        
        targetIndex = [NSIndexPath indexPathForItem:0 inSection:(currentIndexPath.section + 1)];
        
    } else {
        
        targetIndex = [NSIndexPath indexPathForItem:(currentIndexPath.item + 1) inSection:currentIndexPath.section];
    }
    
    // 根据滚动方向滚动到指定位置
    [self scrollToItemAtIndexPath:targetIndex animated:YES];
}

/// 计算轮播图当前索引值
- (NSIndexPath *)currentIndexPath {
    
    NSInteger section = 1;
    NSInteger item = 0;
    
    switch (_flowLayout.scrollDirection) {
            
        case UICollectionViewScrollDirectionHorizontal: {
            
            // 计算偏移索引(四舍五入)
            NSInteger offset = round(_slideCollectionView.contentOffset.x / _flowLayout.itemSize.width);
            
            // 组索引
            section = offset / _itemCount;
            // 单元格索引
            item = offset % _itemCount;
        }
            break;
        case UICollectionViewScrollDirectionVertical: {
            
            // 计算偏移索引(四舍五入)
            NSInteger offset = round(_slideCollectionView.contentOffset.y / _flowLayout.itemSize.height);
            // 组索引
            section = offset / _itemCount;
            // 单元格索引
            item = offset % _itemCount;
        }
            break;
    }
    
    return [NSIndexPath indexPathForItem:item inSection:section];
}

/// 重置数据源
- (void)resetDataSource {
    NSLog(@"%s", __func__);
    
    _slideCollectionView.scrollEnabled = YES;
    
    // 重新设置分页控件
    [self setupPageControl];
    
    // 集合视图重新加载数据源
    [_slideCollectionView reloadData];
}

#pragma mark --Setter

- (void)setQh_data:(NSArray *)qh_data {
    
    _qh_data = qh_data;
    _itemCount = qh_data.count;
    
    // 重置数据源
    [self resetDataSource];
}

- (void)setQh_imageArray:(NSArray *)qh_imageArray {
    
    // image or imageName or imagePath or imageURL or imageURLString
    _qh_imageArray = qh_imageArray;
    _itemCount = qh_imageArray.count;
    
    // 重置数据源
    [self resetDataSource];
}

- (void)setQh_timeInterval:(CGFloat)qh_timeInterval {
    
    _qh_timeInterval = qh_timeInterval;
    
    [_slideCollectionView reloadData];
    
    [self setupTimer];
}

- (void)setQh_itemSize:(CGSize)qh_itemSize {
    
    _qh_itemSize = qh_itemSize;
    _flowLayout.itemSize = qh_itemSize;
}

- (void)setQh_scrollDirection:(UICollectionViewScrollDirection)qh_scrollDirection {
    
    _qh_scrollDirection = qh_scrollDirection;
    _flowLayout.scrollDirection = qh_scrollDirection;
}

- (void)setQh_delegate:(id<GQHSlideViewDelegate>)qh_delegate {

    _qh_delegate = qh_delegate;
    
    if ([self.qh_delegate respondsToSelector:@selector(qh_customCollectionViewCellClassForSlideView:)]) {
        
        // 注册自定义Cell
        Class customClass = [self.qh_delegate qh_customCollectionViewCellClassForSlideView:self];
        
        if (customClass) {
            
            [self.slideCollectionView registerClass:customClass forCellWithReuseIdentifier:kSlideViewCollectionViewCellKey];
        }
    }
}

- (void)setQh_placeholderImage:(UIImage *)qh_placeholderImage {
    
    _qh_placeholderImage = qh_placeholderImage;
    
    if (!_backgroundImageView) {
        
        UIImageView *backgroundView = [[UIImageView alloc] init];
        backgroundView.userInteractionEnabled = YES;
        backgroundView.contentMode = UIViewContentModeScaleToFill;
        [self insertSubview:backgroundView belowSubview:_slideCollectionView];
        _backgroundImageView = backgroundView;
    }
    
    _backgroundImageView.image = qh_placeholderImage;
}

- (void)setQh_appearance:(GQHPageControlAppearance *)qh_appearance {
    
    _qh_appearance = qh_appearance;
    _pageControl.qh_appearance = qh_appearance;
    
    [self layoutIfNeeded];
}

#pragma mark - Getter

- (GQHPageControl *)pageControl {
    
    if (!_pageControl) {
        
        _pageControl = [[GQHPageControl alloc] init];
        _pageControl.qh_appearance = _qh_appearance;
    }
    
    return _pageControl;
}

@end
