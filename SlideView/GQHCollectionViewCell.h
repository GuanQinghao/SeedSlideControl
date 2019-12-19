//
//  GQHCollectionViewCell.h
//  SlideView
//
//  Created by Mac on 2019/12/17.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GQHCollectionViewCell : UICollectionViewCell

/**
 文本内容
 */
@property (nonatomic, copy) NSString *qh_title;

/**
 文本框背景色
 */
@property (nonatomic, strong) UIColor *qh_titleLabelBackgroundColor;

/**
 文本框文字颜色
 */
@property (nonatomic, strong) UIColor *qh_titleLabelTextColor;

/**
 文本框文字字体
 */
@property (nonatomic, strong) UIFont *qh_titleLabelTextFont;

/**
 文本框高度
 */
@property (nonatomic, assign) CGFloat qh_titleLabelHeight;

/**
 文本框文字对齐方式
 */
@property (nonatomic, assign) NSTextAlignment qh_titleLabelTextAlignment;


/**
 图片视图
 */
@property (nonatomic, strong) UIImageView *qh_imageView;


/**
 是否已经设置
 */
@property (nonatomic, assign) BOOL qh_hasConfigured;

/**
 是否只显示文本内容
 */
@property (nonatomic, assign) BOOL qh_onlyText;

@end


NS_ASSUME_NONNULL_END
