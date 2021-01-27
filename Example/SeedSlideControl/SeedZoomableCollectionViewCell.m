//
//  SeedZoomableCollectionViewCell.m
//  SeedSlideControl_Example
//
//  Created by Hao on 2021/1/27.
//  Copyright © 2021 GuanQinghao. All rights reserved.
//

#import "SeedZoomableCollectionViewCell.h"
#import "SeedSlideLoadingView.h"
#import <SDWebImage.h>


@interface SeedZoomableCollectionViewCell ()<UIScrollViewDelegate>

/// 容器视图
@property (nonatomic, strong) UIScrollView *containerScrollView;
/// 可缩放的图片视图
@property (nonatomic, strong) UIImageView *zoomableImageView;
/// 下载进度视图
@property (nonatomic, strong) SeedSlideLoadingView *loadingView;
/// 重新下载按钮
@property (nonatomic, strong) UIButton *reloadButton;

@end

@implementation SeedZoomableCollectionViewCell

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
    self.loadingView.center = center;
    self.reloadButton.center = center;
    
    // 图片原始大小
    CGFloat originalWidth = self.zoomableImageView.image ? self.zoomableImageView.image.size.width : width;
    CGFloat originalHeight = self.zoomableImageView.image ? self.zoomableImageView.image.size.height : height;
    
    // 缩放比例
    CGFloat ratio = MIN((width / originalWidth), (height / originalHeight));
    
    self.zoomableImageView.frame = CGRectMake(0.0f, 0.0f, ratio * originalWidth, ratio * originalHeight);
    self.zoomableImageView.center = center;
}

#pragma mark --------------------- <delegate & datasource> ---------------------

#pragma mark - UIScrollViewDelegate

/// 需要缩放的视图
/// @param scrollView 滚动视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    NSLog(@"view for zooming");
    
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
    
    CGFloat scaledWidth = scrollView.zoomScale * self.normalWidth;
    CGFloat scaledHeight = scrollView.zoomScale * self.normalHeight;
    
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    
    if (scaledWidth < frameWidth) {
        
        x = floor(0.5f * (frameWidth - scaledWidth));
    }
    
    if (scaledHeight < frameHeight) {
        
        y = floor(0.5f * (frameHeight - scaledHeight));
    }
    
    self.imageView.frame = CGRectMake(x, y, scaledWidth, scaledHeight);
    scrollView.contentSize = self.imageView.frame.size;
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

/// 单击
/// @param sender 单击手势
- (IBAction)onSingleClick:(UITapGestureRecognizer *)sender {
    NSLog(@"");
    
//    // 单击手势，从父视图移除
//    [self removeFromSuperview];
//    UIApplication.sharedApplication.statusBarHidden = NO;
}

/// 双击
/// @param sender 双击手势
- (IBAction)onDoubleClick:(UITapGestureRecognizer *)sender {
    NSLog(@"");
    
    if (1.0f == self.containerScrollView.zoomScale || self.containerScrollView.zoomScale > 2.0f) {
        
        [self.containerScrollView setZoomScale:2.0f animated:YES];
    } else if (self.containerScrollView.zoomScale > 1.0f && self.containerScrollView.zoomScale <= 2.0f) {
        
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

#pragma mark ------------------------ <setter & getter> ------------------------

#pragma mark - setter

- (void)setS_asset:(id)s_asset {
    
    _s_asset = s_asset;
    
    // 图片URL字符串、图片对象、图片名称或图片路径
    if ([s_asset isKindOfClass:NSString.class]) {
        
        if ([s_asset hasPrefix:@"http"]) {
            
            // URL字符串
            [self.zoomableImageView sd_setImageWithURL:[NSURL URLWithString:s_asset] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
                //TODO:图片下载进度
            } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
                //TODO:图片下载完成处理(成功和失败)
            }];
        } else {
            
            // 图片名称
            UIImage *image = [UIImage imageNamed:s_asset];
            if (!image) {
                
                // 本地图片路径
                image = [UIImage imageWithContentsOfFile:s_asset];
            }
            
            self.zoomableImageView.image = image;
        }
    } else if ([s_asset isKindOfClass:UIImage.class]) {
        
        // 图片对象
        self.zoomableImageView.image = (UIImage *)s_asset;
    } else {
        
        // 轮播图资源文件未知
        self.zoomableImageView.image = _s_placeholderImage;
        NSLog(@"轮播图资源文件未知:%s--%d",__func__,__LINE__);
    }
    
    
    
    
    
    
}

#pragma mark - getter

- (UIScrollView *)containerScrollView {
    
    if (!_containerScrollView) {
        
        _containerScrollView = [[UIScrollView alloc] init];
        _containerScrollView.delegate = self;
        _containerScrollView.minimumZoomScale = 1.0f;
        _containerScrollView.maximumZoomScale = 5.0f;
        _containerScrollView.showsVerticalScrollIndicator = NO;
        _containerScrollView.showsHorizontalScrollIndicator = NO;
        _containerScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    return _containerScrollView;
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

@end
