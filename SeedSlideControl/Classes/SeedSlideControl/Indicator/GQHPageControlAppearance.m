//
//  GQHPageControlAppearance.m
//  Seed
//
//  Created by Mac on 2019/10/16.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#import "GQHPageControlAppearance.h"


@implementation GQHPageControlAppearance

- (instancetype)init {
    
    if (self = [super init]) {
        
        //MARK:轮播图属性
        // 分页控件对齐方式
        _qh_alignment = GQHPageControlAlignmentCenter;
        // 分页控件的偏移量
        _qh_pageControlOffset = CGPointZero;
        
        //MARK:分页控件属性
        // 分页控件样式
        _qh_style = GQHPageControlStyleClassic;
        // 页码指示器之间的水平间距
        _qh_spacing = 8.0f;
        // 单页时是否隐藏分页控件
        _qh_hidesForSinglePage = YES;
        // 是否显示分页控件
        _qh_showPageControl = YES;
        
        //MARK:页码指示器属性
        // 页码指示器大小
        _qh_size = CGSizeMake(10.0f, 10.0f);
        // 当前页码指示器大小
        _qh_currentSize = CGSizeMake(20.0f, 20.0f);
        // 页码指示器背景色
        _qh_backgroundColor = [UIColor whiteColor];
        // 当前页码指示器背景色
        _qh_currentBackgroundColor = [UIColor redColor];
    }
    
    return self;
}

@end
