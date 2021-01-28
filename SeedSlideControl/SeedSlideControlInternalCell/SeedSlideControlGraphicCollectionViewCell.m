//
//  SeedSlideControlGraphicCollectionViewCell.m
//  SeedSlideControl
//
//  Created by Hao on 2020/11/19.
//  Copyright © 2020 GuanQinghao. All rights reserved.
//

#import "SeedSlideControlGraphicCollectionViewCell.h"
#import "UIImageView+WebCache.h"


@interface SeedSlideControlGraphicCollectionViewCell ()

/// 重新下载按钮
@property (nonatomic, strong) UIButton *reloadButton DEPRECATED_MSG_ATTRIBUTE("TODO");
/// 下载进度视图
@property (nonatomic, strong) SeedSlideControlLoadingIndicator *loadingIndicator;
/// 文本框
@property (nonatomic, strong) UILabel *textLabel;
/// 图片视图
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SeedSlideControlGraphicCollectionViewCell

#pragma mark --------------------------- <lifecycle> ---------------------------

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 图片视图
        [self.contentView addSubview:self.imageView];
        // 文本框
        [self.contentView addSubview:self.textLabel];
    }
    
    return self;
}

#pragma mark ---------------------------- <layout> ----------------------------

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    self.textLabel.frame = self.bounds;
}
#pragma mark ---------------------------- <method> ----------------------------

#pragma mark - target method

/// 重新加载资源
/// @param sender 重载按钮
- (IBAction)reloadAsset:(id)sender {
    
    [self setS_asset:_s_asset];
}

#pragma mark - private method

/// 处理图片资源
/// @param asset 图片资源
- (void)dealWithImageAsset:(id)asset {
    
    [self.reloadButton removeFromSuperview];
    [self.loadingIndicator removeFromSuperview];
    
    if (_s_onlyText) {
        
        self.imageView.image = nil;
        return;
    }
    
    // 图片和文本资源:图片<image>和文字<text>字典(NSDictionary)
    // 图片资源:图片URL字符串(NSString)、图片对象(UIImage)、图片名称(NSString)或图片路径(NSString)
    // 文本资源:文本字符串(NSString)
    
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
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:asset] placeholderImage:self.s_placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
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
            
            self.imageView.image = image;
        }
    } else if ([asset isKindOfClass:UIImage.class]) {
        
        // 图片资源:图片对象(UIImage)
        self.imageView.image = (UIImage *)asset;
    } else {
        
        // 未能识别资源文件
        self.imageView.image = _s_placeholder;
        NSLog(@"未能识别资源文件:%s--%d",__func__,__LINE__);
    }
}

/// 处理文本资源
/// @param asset 文本资源
- (void)dealWithTextAsset:(NSString *)asset {
    
    self.textLabel.text = asset;
}

#pragma mark ------------------------ <setter & getter> ------------------------

#pragma mark - setter

-(void)setS_asset:(id)s_asset {
    
    // 图片和文本资源:图片<image>和文字<text>字典(NSDictionary)
    // 图片资源:图片URL字符串(NSString)、图片对象(UIImage)、图片名称(NSString)或图片路径(NSString)
    // 文本资源:文本字符串(NSString)
    _s_asset = s_asset;
    
    if ([s_asset isKindOfClass:NSDictionary.class]) {
        
        // 图片和文本资源:图片<image>
        id imageAsset = [s_asset objectForKey:@"image"];
        [self dealWithImageAsset:imageAsset];
        
        // 图片和文本资源:文字<text>
        NSString *textAsset = [s_asset objectForKey:@"text"];
        [self dealWithTextAsset:textAsset];
    } else if ([s_asset isKindOfClass:NSString.class]) {
        
        if (_s_onlyText) {
            
            // 文本资源:文本字符串(NSString)
            [self dealWithTextAsset:s_asset];
        } else {
            
            // 图片资源:图片URL字符串(NSString)、图片名称(NSString)或图片路径(NSString)
            [self dealWithImageAsset:s_asset];
        }
    } else if ([s_asset isKindOfClass:UIImage.class]) {
        
        // 图片资源:图片对象(UIImage)
        [self dealWithImageAsset:s_asset];
    } else {
        
        NSLog(@"未能识别资源文件:%s--%d",__func__,__LINE__);
    }
}

- (void)setS_progressMode:(SeedSlideControlLoadingProgressMode)s_progressMode {
    
    _s_progressMode = s_progressMode;
    self.loadingIndicator.s_progressMode = s_progressMode;
}

- (void)setS_contentMode:(UIViewContentMode)s_contentMode {
    
    _s_contentMode = s_contentMode;
    self.imageView.contentMode = s_contentMode;
}

- (void)setS_labelBackgroundColor:(UIColor *)s_labelBackgroundColor {
    
    _s_labelBackgroundColor = s_labelBackgroundColor;
    self.textLabel.backgroundColor = s_labelBackgroundColor;
}

- (void)setS_labelTextColor:(UIColor *)s_labelTextColor {
    
    _s_labelTextColor = s_labelTextColor;
    self.textLabel.textColor = s_labelTextColor;
}

- (void)setS_labelTextFont:(UIFont *)s_labelTextFont {
    
    _s_labelTextFont = s_labelTextFont;
    self.textLabel.font = s_labelTextFont;
}

- (void)setS_labelTextAlignment:(NSTextAlignment)s_labelTextAlignment {
    
    _s_labelTextAlignment = s_labelTextAlignment;
    self.textLabel.textAlignment = s_labelTextAlignment;
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
        [_reloadButton setImage:[UIImage imageWithContentsOfFile:bundlePath] forState:UIControlStateNormal];//TODO:
        
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

- (UILabel *)textLabel {
    
    if (!_textLabel) {
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.numberOfLines = 0;
    }
    
    return _textLabel;
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
    }
    
    return _imageView;
}

@end
