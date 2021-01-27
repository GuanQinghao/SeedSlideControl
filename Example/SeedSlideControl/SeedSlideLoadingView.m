//
//  SeedSlideLoadingView.m
//  SeedSlideControl_Example
//
//  Created by Hao on 2021/1/27.
//  Copyright © 2021 GuanQinghao. All rights reserved.
//

#import "SeedSlideLoadingView.h"


@implementation SeedSlideLoadingView

#pragma mark --------------------------- <lifecycle> ---------------------------

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor grayColor];
        self.clipsToBounds = YES;
        
        self.s_progressMode = SeedSlideLoadingProgressModePie;
    }
    
    return self;
}

#pragma mark ---------------------------- <layout> ----------------------------

- (void)drawRect:(CGRect)rect {
    
    [UIColor.whiteColor set];
    
    switch (self.s_progressMode) {
        case SeedSlideLoadingProgressModePie: {
            // 饼形
            [self drawPieIn:rect];
        }
            break;
        case SeedSlideLoadingProgressModeCircle: {
            // 环形
            [self drawCircleIn:rect];
        }
            break;
    }
}

#pragma mark ---------------------------- <method> ----------------------------

#pragma mark - private method

/// 画饼形
/// @param rect 区域
- (void)drawPieIn:(CGRect)rect {
    
    // 圆半径
    CGFloat radius = 0.5f * CGRectGetWidth(rect);
    // 中心点
    CGPoint center = CGPointMake(radius, radius);
    
    // 先画一个圆
    UIBezierPath *circle = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    circle.lineWidth = 2.0f;
    [UIColor.whiteColor set];
    [circle stroke];
    
    // 再画扇形
    CGFloat start = -M_PI_2;
    CGFloat end = start + self.s_progress * M_2_PI;
    UIBezierPath *sector = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:YES];
    [UIColor.whiteColor set];
    // 绘制扇形
    [sector addLineToPoint:center];
    [sector closePath];
    [sector stroke];
    [sector fill];
}

/// 画环形
/// @param rect 区域
- (void)drawCircleIn:(CGRect)rect {
    
    // 圆环宽度
    CGFloat width = 5.0f;
    // 圆半径
    CGFloat radius = 0.5f * CGRectGetWidth(rect) - width;
    // 中心点
    CGPoint center = CGPointMake(radius, radius);
    // 起点
    CGFloat start = -M_PI_2;
    // 终点
    CGFloat end = start + self.s_progress * M_2_PI;
    
    // 画圆
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:YES];
    circle.lineWidth = width;
    circle.lineCapStyle = kCGLineCapRound;
    [UIColor.whiteColor set];
    [circle stroke];
}

#pragma mark ------------------------ <setter & getter> ------------------------

#pragma mark - setter

- (void)setS_progress:(CGFloat)s_progress {
    
    _s_progress = s_progress;
    
    [self setNeedsDisplay];
    
    if (s_progress >= 1.0f) {
        
        [self removeFromSuperview];
    }
}

- (void)setFrame:(CGRect)frame {
    
    frame.size.width = 50.0f;
    frame.size.height = 50.0f;
    
    self.layer.cornerRadius = 5.0f;
    
    [super setFrame:frame];
}

@end
