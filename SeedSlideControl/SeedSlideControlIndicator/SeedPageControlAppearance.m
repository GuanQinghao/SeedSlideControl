//
//  SeedPageControlAppearance.m
//  SeedSlideControl
//
//  Created by Hao on 2020/10/29.
//

#import "SeedPageControlAppearance.h"


@implementation SeedPageControlAppearance

- (instancetype)init {
    
    if (self = [super init]) {
        
        //MARK:分页控件属性
        // 分页控件样式
        _s_style = SeedPageControlStyleClassic;
        // 页码指示器之间的水平间距
        _s_spacing = 8.0f;
        
        
        //MARK:页码指示器属性
        // 页码指示器大小
        _s_size = CGSizeMake(10.0f, 10.0f);
        // 页码指示器背景色
        _s_backgroundColor = [UIColor lightGrayColor];
        // 页码指示器文字颜色
        _s_textColor = [UIColor darkTextColor];
        // 页码指示器文字字体
        _s_textFont = [UIFont systemFontOfSize:10.0f];
        
        // 页码指示器大小
        _s_size = CGSizeMake(10.0f, 10.0f);
        // 当前页码指示器大小
        _s_currentSize = CGSizeMake(20.0f, 20.0f);
        // 页码指示器背景色
        _s_backgroundColor = [UIColor whiteColor];
        // 当前页码指示器背景色
        _s_currentBackgroundColor = [UIColor redColor];
        
        // 当前页码指示器大小
        _s_currentSize = CGSizeMake(10.0f, 10.0f);
        // 当前页码指示器背景色
        _s_currentBackgroundColor = [UIColor lightGrayColor];
        // 当前页码指示器文字颜色
        _s_currentTextColor = [UIColor darkTextColor];
        // 当前页码指示器文字字体
        _s_currentTextFont = [UIFont systemFontOfSize:10.0f];
    }
    
    return self;
}

@end
