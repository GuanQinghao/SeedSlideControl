//
//  SeedPageControl.h
//  SeedSlideControl
//
//  Created by Hao on 2020/10/29.
//

#import <UIKit/UIKit.h>
#import "SeedPageControlAppearance.h"


NS_ASSUME_NONNULL_BEGIN

@class SeedPageControl;
@protocol SeedPageControlDelegate <NSObject>

@optional

/// 分页控件选中页码
/// @param pageControl 分页控件
/// @param index 选中的页码索引值
- (void)s_pageControl:(SeedPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

@interface SeedPageControl : UIControl

/// 代理
@property (nonatomic, weak) id<SeedPageControlDelegate> s_delegate;
/// 分页控件外观属性
@property (nonatomic, strong) SeedPageControlAppearance *s_appearance;
/// 分页控件页码总数
@property (nonatomic, assign) NSInteger s_totalPages;
/// 分页控件当前页码索引值
@property (nonatomic, assign) NSInteger s_currentPage;

/// 分页控件的尺寸
/// @param style 分页控件样式
/// @param count 分页控件总页数
- (CGSize)s_sizeWithPageControlStyle:(SeedPageControlStyle)style pages:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
