//
//  GQHPageControlGraphicIndicator.m
//  Seed
//
//  Created by Mac on 2019/10/16.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#import "GQHPageControlGraphicIndicator.h"


@implementation GQHPageControlGraphicIndicator

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 背景色
        self.backgroundColor = UIColor.whiteColor;
        
        // 图片视图
        [self addSubview:self.qh_imageView];
        // 文本标签
        [self addSubview:self.qh_textLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 图片视图和文本标签视图与self同等大小
    self.qh_textLabel.frame = self.bounds;
    self.qh_imageView.frame = self.bounds;
}

#pragma mark - Setter

#pragma mark - Getter

- (UIImageView *)qh_imageView {
    
    if (!_qh_imageView) {
        
        _qh_imageView = [[UIImageView alloc] init];
        _qh_imageView.backgroundColor = [UIColor clearColor];
        
        _qh_imageView.userInteractionEnabled = YES;
        _qh_imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _qh_imageView.layer.cornerRadius = 0.0f;
        _qh_imageView.layer.masksToBounds = YES;
    }
    
    return _qh_imageView;
}

- (UILabel *)qh_textLabel {
    
    if (!_qh_textLabel) {
        
        _qh_textLabel = [[UILabel alloc] init];
        _qh_textLabel.backgroundColor = [UIColor clearColor];
        
        _qh_textLabel.font = [UIFont systemFontOfSize:10.0f];
        _qh_textLabel.textColor = [UIColor darkTextColor];
        _qh_textLabel.textAlignment = NSTextAlignmentCenter;
        _qh_textLabel.numberOfLines = 1;
    }
    
    return _qh_textLabel;
}

@end
