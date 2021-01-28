//
//  SeedSlideControl.h
//  SeedSlideControl
//
//  Created by Hao on 2020/11/19.
//  Copyright © 2020 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeedPageControl.h"
#import "SeedSlideControlAppearance.h"


NS_ASSUME_NONNULL_BEGIN

@class SeedSlideControl;
@protocol SeedSlideControlDelegate <NSObject>

@optional

/// 轮播控件点击回调
/// @param slideControl 轮播控件
/// @param index 点击的索引值
- (void)s_slideControl:(SeedSlideControl *)slideControl didSelectItemAtIndex:(NSInteger)index;

/// 轮播控件滚动回调
/// @param slideControl 轮播控件
/// @param index 滚动结束后的索引值
- (void)s_slideControl:(SeedSlideControl *)slideControl didScrollToIndex:(NSInteger)index;

/// 自定义轮播控件cell类
/// @param slideControl 轮播控件
- (Class)s_customCollectionViewCellClassForSlideControl:(SeedSlideControl *)slideControl;

/// 自定义轮播控件cell填充数据及其他设置
/// @param slideControl 轮播控件
/// @param cell 自定义Cell
/// @param index 索引值
- (void)s_slideControl:(SeedSlideControl *)slideControl setCustomCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

/// 轮播控件
@interface SeedSlideControl : UIView

/// 轮播控件滚动到指定索引值
/// @param slideControl 轮播控件
/// @param index 指定索引值
- (void)s_slideControl:(SeedSlideControl *)slideControl scrollToIndex:(NSInteger)index;

#pragma mark - 数据源

/// 自定义Cell对应的数据源, 可以是字典、模型
@property (nonatomic, strong) NSArray *s_data;

/// image or imageName or imagePath or imageURL or imageURLString
@property (nonatomic, strong) NSArray *s_imageArray;


#pragma mark - 回调

/// 代理
@property (nonatomic, weak) id<SeedSlideControlDelegate> s_delegate;

/// 点击监听
@property (nonatomic, copy) void (^s_selectItemMonitorBlock)(NSInteger index);
/// 滚动监听
@property (nonatomic, copy) void (^s_scrollToItemMonitorBlock)(NSInteger index);


#pragma mark - 轮播属性

/// 轮播外观属性
@property (nonatomic, strong) SeedSlideControlAppearance *s_slideControlAppearance;


#pragma mark - 分页控件属性

/// 分页控件外观属性
@property (nonatomic, strong) SeedPageControlAppearance *s_pageControlAppearance;

@end

NS_ASSUME_NONNULL_END