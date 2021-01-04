//
//  SeedSlideViewCollectionViewCell.m
//  SeedSlideControl
//
//  Created by Hao on 2020/11/19.
//  Copyright © 2020 GuanQinghao. All rights reserved.
//

#import "SeedSlideViewCollectionViewCell.h"


@implementation SeedSlideViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 图片视图
        [self.contentView addSubview:self.s_imageView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _s_imageView.frame = self.bounds;
}

- (UIImageView *)s_imageView {
    
    if (!_s_imageView) {
        
        _s_imageView = [[UIImageView alloc] init];
        _s_imageView.userInteractionEnabled = YES;
    }
    
    return _s_imageView;
}

@end
