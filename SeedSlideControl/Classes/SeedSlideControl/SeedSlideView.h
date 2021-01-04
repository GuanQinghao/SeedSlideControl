//
//  SeedSlideView.h
//  SeedSlideControl
//
//  Created by Hao on 2020/11/19.
//  Copyright © 2020 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeedPageControlAppearance.h"


NS_ASSUME_NONNULL_BEGIN

@class SeedSlideView;
@protocol SeedSlideViewDelegate <NSObject>

@required

@optional

/// 轮播图点击回调
/// @param slideView 轮播图
/// @param index 点击的索引值
- (void)s_slideView:(SeedSlideView *)slideView didSelectItemAtIndex:(NSInteger)index;

/// 轮播图滚动回调
/// @param slideView 轮播图
/// @param index 滚动结束后的索引值
- (void)s_slideView:(SeedSlideView *)slideView didScrollToIndex:(NSInteger)index;

/// 自定义轮播图cell类
/// @param slideView 轮播图
- (Class)s_customCollectionViewCellClassForSlideView:(SeedSlideView *)slideView;

/// 自定义轮播图cell填充数据及其他设置
/// @param cell 自定义Cell
/// @param index 索引值
/// @param slideView 轮播图
- (void)s_setupCustomCell:(__kindof UICollectionViewCell *)cell forIndex:(NSInteger)index slideView:(SeedSlideView *)slideView;

@end

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

@interface SeedSlideView : UIView

/// 轮播图滚动到指定索引值
/// @param slideView 轮播图
/// @param index 指定索引值
- (void)s_slideView:(SeedSlideView *)slideView scrollToIndex:(NSInteger)index;


#pragma mark - 数据源

/// 自定义Cell对应的数据源, 可以是字典、模型
@property (nonatomic, strong) NSArray *s_data;

/// image or imageName or imagePath or imageURL or imageURLString
@property (nonatomic, strong) NSArray *s_imageArray;


#pragma mark - 回调

/// 代理
@property (nonatomic, weak) id<SeedSlideViewDelegate> s_delegate;

/// 点击监听
@property (nonatomic, copy) void (^s_selectItemMonitorBlock)(NSInteger index);

/// 滚动监听
@property (nonatomic, copy) void (^s_scrollToItemMonitorBlock)(NSInteger index);


#pragma mark - 轮播属性

/// 轮播图是否可以滚动, 默认YES
@property (nonatomic, assign) BOOL s_scrollEnabled;

/// 自动轮播时间间隔(默认 3.0f秒, 不自动轮播设置为CGFLOAT_MAX)
@property (nonatomic, assign) CGFloat s_timeInterval;

/// 轮播滚动方向
@property (nonatomic, assign) UICollectionViewScrollDirection s_scrollDirection;

/// 轮播图片填充模式
@property (nonatomic, assign) UIViewContentMode s_slideViewContentMode;

/// 轮播占位图
@property (nonatomic, strong) UIImage *s_placeholderImage;


#pragma mark - 分页控件属性

/// 分页控件外观属性
@property (nonatomic, strong) SeedPageControlAppearance *s_appearance;

@end

NS_ASSUME_NONNULL_END
