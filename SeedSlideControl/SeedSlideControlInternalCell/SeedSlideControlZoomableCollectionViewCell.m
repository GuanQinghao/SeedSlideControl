//
//  SeedSlideControlZoomableCollectionViewCell.m
//  SeedSlideControl
//
//  Created by Hao on 2021/1/27.
//  Copyright © 2021 GuanQinghao. All rights reserved.
//

#import "SeedSlideControlZoomableCollectionViewCell.h"
#import "UIImageView+WebCache.h"


@interface SeedSlideControlZoomableCollectionViewCell ()<UIScrollViewDelegate> {
    
    // 图片视图正常宽度
    CGFloat _normalWidth;
    // 图片视图正常高度
    CGFloat _normalHeight;
}

/// 重新下载按钮
@property (nonatomic, strong) UIButton *reloadButton DEPRECATED_MSG_ATTRIBUTE("TODO");
/// 下载进度视图
@property (nonatomic, strong) SeedSlideControlLoadingIndicator *loadingIndicator;
/// 可缩放的图片视图
@property (nonatomic, strong) UIImageView *zoomableImageView;
/// 容器视图
@property (nonatomic, strong) UIScrollView *containerScrollView;

@end

@implementation SeedSlideControlZoomableCollectionViewCell

#pragma mark --------------------------- <lifecycle> ---------------------------

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.clipsToBounds = YES;
        
        /// 添加手势
        [self addGestureRecognizer];
        
        /// 容器视图
        [self.contentView addSubview:self.containerScrollView];
        /// 图片视图
        [self.containerScrollView addSubview:self.zoomableImageView];
        
        // 图片视图正常宽度
        _normalWidth = 0.0f;
        // 图片视图正常高度
        _normalHeight = 0.0f;
    }
    
    return self;
}

#pragma mark ---------------------------- <layout> ----------------------------

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGPoint center = CGPointMake(0.5f * width, 0.5 * height);
    
    self.containerScrollView.frame = self.bounds;
    self.loadingIndicator.center = center;
    self.reloadButton.center = center;
    
    // 图片原始大小
    CGFloat originalWidth = self.zoomableImageView.image ? self.zoomableImageView.image.size.width : 0.0f;
    CGFloat originalHeight = self.zoomableImageView.image ? self.zoomableImageView.image.size.height : 0.0f;
    
    if (originalWidth > 0.0f && originalHeight > 0.0f) {
        
        // 缩放比例
        CGFloat ratio = MIN((width / originalWidth), (height / originalHeight));
        _normalWidth = ratio * originalWidth;
        _normalHeight = ratio * originalHeight;
        self.zoomableImageView.frame = CGRectMake(0.0f, 0.0f, _normalWidth, _normalHeight);
    } else {
        
        self.zoomableImageView.frame = CGRectZero;
    }
    
    self.zoomableImageView.center = center;
}

#pragma mark --------------------- <delegate & datasource> ---------------------

#pragma mark - UIScrollViewDelegate

/// 需要缩放的视图
/// @param scrollView 滚动视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.zoomableImageView;
}

/// 开始缩放
/// @param scrollView 滚动视图
/// @param view 缩放视图
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    NSLog(@"will begin zooming");
    
}

/// 结束缩放
/// @param scrollView 滚动视图
/// @param view 缩放视图
/// @param scale 缩放比例
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    NSLog(@"did end zooming");
    
    [scrollView setZoomScale:scale animated:YES];
}

/// 视图缩放中
/// @param scrollView 滚动视图
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSLog(@"did zoom");
    
    CGFloat frameWidth = CGRectGetWidth(scrollView.frame);
    CGFloat frameHeight = CGRectGetHeight(scrollView.frame);
    
    CGFloat scalingWidth = scrollView.zoomScale * _normalWidth;
    CGFloat scalingHeight = scrollView.zoomScale * _normalHeight;
    
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    
    if (scalingWidth < frameWidth) {
        
        x = floor(0.5f * (frameWidth - scalingWidth));
    }
    
    if (scalingHeight < frameHeight) {
        
        y = floor(0.5f * (frameHeight - scalingHeight));
    }
    
    self.zoomableImageView.frame = CGRectMake(x, y, scalingWidth, scalingHeight);
    scrollView.contentSize = self.zoomableImageView.frame.size;
}

#pragma mark ---------------------------- <method> ----------------------------

#pragma mark - public method

/// 缩放视图
/// @param scale 缩放比例
- (void)s_zoomWith:(CGFloat)scale {
    NSLog(@"");
    
    [self.containerScrollView setZoomScale:scale animated:YES];
}

#pragma mark - target method

/// 重新加载资源
/// @param sender 重载按钮
- (IBAction)reloadAsset:(id)sender {
    
    [self setS_asset:_s_asset];
}

/// 单击
/// @param sender 单击手势
- (IBAction)onSingleClick:(UITapGestureRecognizer *)sender {
    NSLog(@"");
    
    if (self.s_clikc) {
        
        self.s_clikc(sender);
    }
}

/// 双击
/// @param sender 双击手势
- (IBAction)onDoubleClick:(UITapGestureRecognizer *)sender {
    NSLog(@"");
    
    CGPoint touchPoint = [sender locationInView:self];
    
    if (self.containerScrollView.zoomScale <= 1.0f) {
        
        CGFloat x = touchPoint.x + self.containerScrollView.contentOffset.x;
        CGFloat y = touchPoint.y + self.containerScrollView.contentOffset.y;
        [self.containerScrollView zoomToRect:CGRectMake(x, y, 10.0f, 10.0f) animated:YES];
    } else {
        
        [self.containerScrollView setZoomScale:1.0f animated:YES];
    }
}

#pragma mark - private method

/// 添加手势
- (void)addGestureRecognizer {
    
    // 单击手势
    UITapGestureRecognizer *singleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleClick:)];
    singleClick.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleClick];
    
    // 双击手势
    UITapGestureRecognizer *doubleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleClick:)];
    doubleClick.numberOfTapsRequired = 2;
    // 单击手势取消双击手势
    [singleClick requireGestureRecognizerToFail:doubleClick];
    [self addGestureRecognizer:doubleClick];
}

/// 处理图片资源
/// @param asset 图片资源
- (void)dealWithImageAsset:(id)asset {
    
    [self.reloadButton removeFromSuperview];
    [self.loadingIndicator removeFromSuperview];
    
    if ([asset isKindOfClass:NSString.class]) {
        
        // 图片资源:图片URL字符串(NSString)
        if ([asset hasPrefix:@"http"]) {
            
            CGFloat width = 0.5f * CGRectGetWidth(self.bounds);
            CGFloat height = 0.5f * CGRectGetHeight(self.bounds);
            CGPoint center = CGPointMake(width, height);
            
            // 下载进度视图
            self.loadingIndicator.center = center;
            self.loadingIndicator.s_progress = 0.0f;
            [self addSubview:self.loadingIndicator];
            
            __weak typeof(self) weakSelf = self;
            [self.zoomableImageView sd_setImageWithURL:[NSURL URLWithString:asset] placeholderImage:self.s_placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
                // 主线程刷新图片下载进度
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    weakSelf.loadingIndicator.s_progress = 1.0f * receivedSize / expectedSize;
                });
            } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
                // 图片下载完成处理(成功和失败)
                [weakSelf.loadingIndicator removeFromSuperview];
                
                // 图片下载失败
                if (error) {
                    
                    // 重新下载按钮
                    weakSelf.reloadButton.center = center;
                    [weakSelf addSubview:weakSelf.reloadButton];
                    return;
                }
                
                [weakSelf setNeedsLayout];
            }];
        } else {
            
            // 图片资源:图片名称(NSString)或图片路径(NSString)
            UIImage *image = [UIImage imageNamed:asset];
            if (!image) {
                
                // 图片资源:图片路径(NSString)
                image = [UIImage imageWithContentsOfFile:asset];
            }
            
            self.zoomableImageView.image = image;
        }
    } else if ([asset isKindOfClass:UIImage.class]) {
        
        // 图片资源:图片对象(UIImage)
        self.zoomableImageView.image = (UIImage *)asset;
    } else {
        
        // 未能识别资源文件
        self.zoomableImageView.image = _s_placeholder;
        NSLog(@"未能识别资源文件:%s--%d",__func__,__LINE__);
    }
}

#pragma mark ------------------------ <setter & getter> ------------------------

#pragma mark - setter

- (void)setS_asset:(id)s_asset {
    
    // 图片资源:图片URL字符串(NSString)、图片对象(UIImage)、图片名称(NSString)或图片路径(NSString)
    _s_asset = s_asset;
    
    [self dealWithImageAsset:s_asset];
}

- (void)setS_progressMode:(SeedSlideControlLoadingProgressMode)s_progressMode {
    
    _s_progressMode = s_progressMode;
    self.loadingIndicator.s_progressMode = s_progressMode;
}

- (void)setS_maximumZoomScale:(CGFloat)s_maximumZoomScale {
    
    _s_maximumZoomScale = s_maximumZoomScale;
    self.containerScrollView.maximumZoomScale = s_maximumZoomScale;
}

#pragma mark - getter

- (UIButton *)reloadButton {
    
    if (!_reloadButton) {
        
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.backgroundColor = [UIColor grayColor];
        _reloadButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
        _reloadButton.layer.cornerRadius = 5.0f;
        _reloadButton.clipsToBounds = YES;
        
        NSString *bundleName = @"SeedSlideControl.bundle";
        NSString *bundlePath = [[NSBundle bundleForClass:NSClassFromString(@"SeedSlideControl")] pathForResource:@"reload.png" ofType:nil inDirectory:bundleName];
        [_reloadButton setImage:[UIImage imageWithContentsOfFile:bundlePath] forState:UIControlStateNormal];
        
        [_reloadButton addTarget:self action:@selector(reloadAsset:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _reloadButton;
}

- (SeedSlideControlLoadingIndicator *)loadingIndicator {
    
    if (!_loadingIndicator) {
        
        _loadingIndicator = [[SeedSlideControlLoadingIndicator alloc] init];
    }
    
    return _loadingIndicator;
}

- (UIImageView *)zoomableImageView {
    
    if (!_zoomableImageView) {
        
        _zoomableImageView = [[UIImageView alloc] init];
        _zoomableImageView.backgroundColor = [UIColor clearColor];
        _zoomableImageView.contentMode = UIViewContentModeScaleToFill;
        _zoomableImageView.userInteractionEnabled = YES;
        _zoomableImageView.clipsToBounds = YES;
    }
    
    return _zoomableImageView;
}

- (UIScrollView *)containerScrollView {
    
    if (!_containerScrollView) {
        
        _containerScrollView = [[UIScrollView alloc] init];
        _containerScrollView.delegate = self;
        _containerScrollView.minimumZoomScale = 1.0f;
        _containerScrollView.showsVerticalScrollIndicator = NO;
        _containerScrollView.showsHorizontalScrollIndicator = NO;
        _containerScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    return _containerScrollView;
}

@end
