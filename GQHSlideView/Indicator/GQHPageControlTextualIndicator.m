//
//  GQHPageControlTextualIndicator.m
//  Seed
//
//  Created by Mac on 2019/10/16.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#import "GQHPageControlTextualIndicator.h"


@interface GQHPageControlTextualIndicator ()

/**
 页码指示器标签 自动适配大小
 */
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation GQHPageControlTextualIndicator

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 默认背景色
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        
        [self addSubview:self.textLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 内边距
    CGFloat horizontalPadding = 10.0f;
    CGFloat verticalPadding = 5.0f;
    
    CGFloat width = self.textLabel.frame.size.width;
    CGFloat height = self.textLabel.frame.size.height;
    
    // 计算布局
    self.frame = CGRectMake(0.0f, 0.0f, width + 2.0f * horizontalPadding, height + 2 * verticalPadding);
    self.textLabel.frame = CGRectMake(horizontalPadding, verticalPadding, width, height);
    
    // 圆角
    self.layer.cornerRadius = 0.5f * CGRectGetHeight(self.frame);
    self.layer.masksToBounds = YES;
}

#pragma mark - Setter

- (void)setQh_textColor:(UIColor *)qh_textColor {
    
    _qh_textColor = qh_textColor;
    self.textLabel.textColor = qh_textColor;
}

- (void)setQh_textFont:(UIFont *)qh_textFont {
    
    _qh_textFont = qh_textFont;
    self.textLabel.font = qh_textFont;
    [self.textLabel sizeToFit];
}

- (void)setQh_text:(NSString *)qh_text {
    
    _qh_text = qh_text;
    self.textLabel.text = qh_text;
    [self.textLabel sizeToFit];
}

#pragma mark - Getter

- (UILabel *)textLabel {
    
    if (!_textLabel) {
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = UIColor.clearColor;
        _textLabel.font = [UIFont systemFontOfSize:16.0f];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 1;
    }
    
    return _textLabel;
}

@end
