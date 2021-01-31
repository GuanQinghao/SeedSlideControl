//
//  SeedPageControlGraphicIndicator.m
//  SeedSlideControl
//
//  Created by Hao on 2020/10/29.
//

#import "SeedPageControlGraphicIndicator.h"


@implementation SeedPageControlGraphicIndicator

#pragma mark --------------------------- <lifecycle> ---------------------------

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 背景色
        self.backgroundColor = UIColor.lightGrayColor;
        
        // 图片视图
        [self addSubview:self.s_imageView];
        // 文本标签
        [self addSubview:self.s_textLabel];
    }
    
    return self;
}

#pragma mark ---------------------------- <layout> ----------------------------

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 图片视图和文本标签视图与self同等大小
    self.s_textLabel.frame = self.bounds;
    self.s_imageView.frame = self.bounds;
}

#pragma mark ------------------------ <setter & getter> ------------------------

#pragma mark - setter

#pragma mark - getter

- (UIImageView *)s_imageView {
    
    if (!_s_imageView) {
        
        _s_imageView = [[UIImageView alloc] init];
        _s_imageView.backgroundColor = [UIColor clearColor];
        
        _s_imageView.userInteractionEnabled = YES;
        _s_imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _s_imageView.layer.cornerRadius = 0.0f;
        _s_imageView.layer.masksToBounds = YES;
    }
    
    return _s_imageView;
}

- (UILabel *)s_textLabel {
    
    if (!_s_textLabel) {
        
        _s_textLabel = [[UILabel alloc] init];
        _s_textLabel.backgroundColor = [UIColor clearColor];
        
        _s_textLabel.font = [UIFont systemFontOfSize:10.0f];
        _s_textLabel.textColor = [UIColor darkTextColor];
        _s_textLabel.textAlignment = NSTextAlignmentCenter;
        _s_textLabel.numberOfLines = 1;
    }
    
    return _s_textLabel;
}

@end
