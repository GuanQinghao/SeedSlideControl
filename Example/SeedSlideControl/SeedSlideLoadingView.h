//
//  SeedSlideLoadingView.h
//  SeedSlideControl_Example
//
//  Created by Hao on 2021/1/27.
//  Copyright © 2021 GuanQinghao. All rights reserved.
//

#import <UIKit/UIKit.h>


/// 加载进度视图模式
typedef NS_ENUM(NSUInteger, SeedSlideLoadingProgressMode) {
    
    SeedSlideLoadingProgressModePie,    /// 饼形
    SeedSlideLoadingProgressModeCircle, /// 环形
};


NS_ASSUME_NONNULL_BEGIN

@interface SeedSlideLoadingView : UIView

/// 加载进度(0.0 ~ 1.0)
@property (nonatomic, assign) CGFloat s_progress;

/// 加载进度视图模式, 默认 SeedSlideLoadingProgressModePie
@property (nonatomic, assign) SeedSlideLoadingProgressMode s_progressMode;

@end

NS_ASSUME_NONNULL_END
