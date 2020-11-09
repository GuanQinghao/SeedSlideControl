//
//  SeedPageControlTextualIndicator.m
//  SeedSlideControl
//
//  Created by Hao on 2020/10/29.
//

#import "SeedPageControlTextualIndicator.h"


@interface SeedPageControlTextualIndicator ()

/// 页码指示器标签 自动适配大小
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation SeedPageControlTextualIndicator

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

- (void)setS_textColor:(UIColor *)s_textColor {
    
    _s_textColor = s_textColor;
    self.textLabel.textColor = s_textColor;
}

- (void)setS_textFont:(UIFont *)s_textFont {
    
    _s_textFont = s_textFont;
    self.textLabel.font = s_textFont;
    [self.textLabel sizeToFit];
}

- (void)setS_text:(NSString *)s_text {
    
    _s_text = s_text;
    self.textLabel.text = s_text;
    [self.textLabel sizeToFit];
}

#pragma mark - Getter

- (UILabel *)textLabel {
    
    if (!_textLabel) {
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = UIColor.clearColor;
        _textLabel.font = [UIFont systemFontOfSize:15.0f];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 1;
    }
    
    return _textLabel;
}

@end
