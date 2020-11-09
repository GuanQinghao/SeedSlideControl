//
//  SeedPageControlTextualIndicator.h
//  SeedSlideControl
//
//  Created by Hao on 2020/10/29.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/// 标签样式页码指示器
@interface SeedPageControlTextualIndicator : UIView

/// 标签文字颜色
@property (nonatomic, strong) UIColor *s_textColor;
/// 标签文字字体
@property (nonatomic, strong) UIFont *s_textFont;
/// 标签文字内容 例: 2/5
@property (nonatomic, strong) NSString *s_text;

@end

NS_ASSUME_NONNULL_END
