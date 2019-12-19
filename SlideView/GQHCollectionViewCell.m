//
//  GQHCollectionViewCell.m
//  SlideView
//
//  Created by Mac on 2019/12/17.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#import "GQHCollectionViewCell.h"


@interface GQHCollectionViewCell ()

/**
 文本框
 */
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GQHCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 图片视图
        [self.contentView addSubview:self.qh_imageView];
        // 文本框视图
        [self.contentView addSubview:self.titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
//    [super layoutSubviews];
    
    if (_qh_onlyText) {
        
        _titleLabel.frame = self.bounds;
    } else {
        
        _qh_imageView.frame = self.bounds;
        
        _titleLabel.frame = self.bounds;
        
    }
}

#pragma mark - Setter

- (void)setQh_title:(NSString *)qh_title {
    
    _qh_title = qh_title;
    _titleLabel.text = qh_title;
    
    _titleLabel.hidden = NO;
}

- (void)setQh_titleLabelBackgroundColor:(UIColor *)qh_titleLabelBackgroundColor {
    
    _qh_titleLabelBackgroundColor = qh_titleLabelBackgroundColor;
    _titleLabel.backgroundColor = qh_titleLabelBackgroundColor;
}

- (void)setQh_titleLabelTextColor:(UIColor *)qh_titleLabelTextColor {
    
    _qh_titleLabelTextColor = qh_titleLabelTextColor;
    _titleLabel.textColor = qh_titleLabelTextColor;
}

- (void)setQh_titleLabelTextFont:(UIFont *)qh_titleLabelTextFont {
    
    _qh_titleLabelTextFont = qh_titleLabelTextFont;
    _titleLabel.font = qh_titleLabelTextFont;
}

- (void)setQh_titleLabelTextAlignment:(NSTextAlignment)qh_titleLabelTextAlignment {
    
    _qh_titleLabelTextAlignment = qh_titleLabelTextAlignment;
    _titleLabel.textAlignment = qh_titleLabelTextAlignment;
}

#pragma mark - Getter

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.hidden = YES;
        _titleLabel.numberOfLines = 0;
    }
    
    return _titleLabel;
}

- (UIImageView *)qh_imageView {
    
    if (!_qh_imageView) {
        
        _qh_imageView = [[UIImageView alloc] init];
    }
    
    return _qh_imageView;
}

@end
