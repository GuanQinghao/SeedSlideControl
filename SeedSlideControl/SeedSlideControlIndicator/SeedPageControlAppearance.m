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
        
        //MARK:轮播图属性
        // 分页控件对齐方式
        _s_alignment = SeedPageControlAlignmentCenter;
        // 分页控件的偏移量
        _s_pageControlOffset = CGPointZero;
        
        //MARK:分页控件属性
        // 分页控件样式
        _s_style = SeedPageControlStyleClassic;
        // 页码指示器之间的水平间距
        _s_spacing = 8.0f;
        // 单页时是否隐藏分页控件
        _s_hidesForSinglePage = YES;
        // 是否显示分页控件
        _s_showPageControl = YES;
        
        //MARK:页码指示器属性
        // 页码指示器大小
        _s_size = CGSizeMake(10.0f, 10.0f);
        // 当前页码指示器大小
        _s_currentSize = CGSizeMake(20.0f, 20.0f);
        // 页码指示器背景色
        _s_backgroundColor = [UIColor whiteColor];
        // 当前页码指示器背景色
        _s_currentBackgroundColor = [UIColor redColor];
    }
    
    return self;
}

@end
