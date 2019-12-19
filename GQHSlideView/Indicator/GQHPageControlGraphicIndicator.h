//
//  GQHPageControlGraphicIndicator.h
//  Seed
//
//  Created by Mac on 2019/10/16.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/**
 图文样式页码指示器
 */
@interface GQHPageControlGraphicIndicator : UIView

/**
 图片视图
 */
@property (nonatomic, strong) UIImageView *qh_imageView;

/**
 文本标签
 */
@property (nonatomic, strong) UILabel *qh_textLabel;

@end

NS_ASSUME_NONNULL_END
