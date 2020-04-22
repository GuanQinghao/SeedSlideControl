//
//  GQHSlideView.h
//  Seed
//
//  Created by GuanQinghao on 13/12/2017.
//  Copyright © 2017 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GQHPageControlAppearance.h"


@class GQHSlideView;
@protocol GQHSlideViewDelegate <NSObject>

@required

@optional

/// 轮播图点击回调
/// @param slideView 轮播图
/// @param index 点击的索引值
- (void)qh_slideView:(GQHSlideView *)slideView didSelectItemAtIndex:(NSInteger)index;

/// 轮播图滚动回调
/// @param slideView 轮播图
/// @param index 滚动结束后的索引值
- (void)qh_slideView:(GQHSlideView *)slideView didScrollToIndex:(NSInteger)index;

/// 自定义轮播图cell类
/// @param slideView 轮播图
- (Class)qh_customCollectionViewCellClassForSlideView:(GQHSlideView *)slideView;

/// 自定义轮播图cell填充数据及其他设置
/// @param cell 自定义Cell
/// @param index 索引值
/// @param slideView 轮播图
- (void)qh_setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index slideView:(GQHSlideView *)slideView;

@end


@interface GQHSlideView : UIView

/// 轮播图滚动到指定索引值
/// @param slideView 轮播图
/// @param index 指定索引值
- (void)qh_slideView:(GQHSlideView *)slideView scrollToIndex:(NSInteger)index;

#pragma mark - 数据源
/// 自定义Cell对应的数据源, 可以是字典、模型
@property (nonatomic, strong) NSArray *qh_data;
/// image or imageName or imagePath or imageURL or imageURLString
@property (nonatomic, strong) NSArray *qh_imageArray;

#pragma mark - 回调
/// 代理
@property (nonatomic, weak) id<GQHSlideViewDelegate> qh_delegate;
/// 点击监听
@property (nonatomic, copy) void (^selectItemMonitorBlock)(NSInteger index);
/// 滚动监听
@property (nonatomic, copy) void (^scrollToItemMonitorBlock)(NSInteger index);

#pragma mark - 轮播属性
/// 自动轮播时间间隔(默认 3.0f秒, 不自动轮播设置为CGFLOAT_MAX)
@property (nonatomic, assign) CGFloat qh_timeInterval;
/// 轮播滚动方向
@property (nonatomic, assign) UICollectionViewScrollDirection qh_scrollDirection;
/// 轮播图片填充模式
@property (nonatomic, assign) UIViewContentMode qh_slideViewContentMode;
/// 轮播占位图
@property (nonatomic, strong) UIImage *qh_placeholderImage;

#pragma mark - 分页控件属性
/// 分页控件外观属性
@property (nonatomic, strong) GQHPageControlAppearance *qh_appearance;

@end
