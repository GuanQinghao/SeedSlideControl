//
//  GQHPageControl.h
//  Seed
//
//  Created by GuanQinghao on 12/12/2017.
//  Copyright © 2017 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GQHPageControlAppearance.h"


NS_ASSUME_NONNULL_BEGIN

@class GQHPageControl;
@protocol GQHPageControlDelegate <NSObject>

@required

@optional

/// 分页控件选中页码
/// @param pageControl 分页控件
/// @param index 选中的页码索引值
- (void)qh_pageControl:(GQHPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

@interface GQHPageControl : UIControl

/// 分页控件的尺寸
/// @param style 分页控件样式
/// @param count 分页控件总页数
- (CGSize)qh_sizeWithPageControlStyle:(GQHPageControlStyle)style pages:(NSInteger)count;

/// 代理
@property (nonatomic, weak) id<GQHPageControlDelegate> qh_delegate;
/// 分页控件外观属性
@property (nonatomic, strong) GQHPageControlAppearance *qh_appearance;
/// 分页控件页码总数
@property (nonatomic, assign) NSInteger qh_totalPages;
/// 分页控件当前页码索引值
@property (nonatomic, assign) NSInteger qh_currentPage;

@end

NS_ASSUME_NONNULL_END
