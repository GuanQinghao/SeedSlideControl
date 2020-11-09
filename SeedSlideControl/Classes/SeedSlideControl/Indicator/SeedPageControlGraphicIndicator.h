//
//  SeedPageControlGraphicIndicator.h
//  SeedSlideControl
//
//  Created by Hao on 2020/10/29.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/// 图文样式页码指示器
@interface SeedPageControlGraphicIndicator : UIView

/// 图片视图
@property (nonatomic, strong) UIImageView *s_imageView;
/// 文本标签
@property (nonatomic, strong) UILabel *s_textLabel;

@end

NS_ASSUME_NONNULL_END
