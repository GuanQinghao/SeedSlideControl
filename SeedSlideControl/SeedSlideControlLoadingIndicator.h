//
//  SeedSlideControlLoadingIndicator.h
//  SeedSlideControl
//
//  Created by Hao on 2021/1/27.
//  Copyright © 2021 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>


/// 加载进度视图模式
typedef NS_ENUM(NSUInteger, SeedSlideControlLoadingProgressMode) {
    
    SeedSlideControlLoadingProgressModePie,    /// 饼形
    SeedSlideControlLoadingProgressModeCircle, /// 环形
};


NS_ASSUME_NONNULL_BEGIN

@interface SeedSlideControlLoadingIndicator : UIView

/// 加载进度(0.0 ~ 1.0)
@property (nonatomic, assign) CGFloat s_progress;

/// 加载进度视图模式, 默认 SeedSlideControlLoadingProgressModePie
@property (nonatomic, assign) SeedSlideControlLoadingProgressMode s_progressMode;

@end

NS_ASSUME_NONNULL_END
