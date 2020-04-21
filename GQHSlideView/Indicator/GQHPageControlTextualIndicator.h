//
//  GQHPageControlTextualIndicator.h
//  Seed
//
//  Created by Mac on 2019/10/16.
//  Copyright © 2019 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/// 标签样式页码指示器
@interface GQHPageControlTextualIndicator : UIView

/// 标签文字颜色
@property (nonatomic, strong) UIColor *qh_textColor;
///标签文字字体
@property (nonatomic, strong) UIFont *qh_textFont;
/// 标签文字内容 例: 2/5
@property (nonatomic, strong) NSString *qh_text;

@end

NS_ASSUME_NONNULL_END
