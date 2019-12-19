//
//  GQHSlideViewCollectionViewCell.m
//  Seed
//
//  Created by GuanQinghao on 12/12/2017.
//  Copyright © 2017 GuanQinghao. All rights reserved.
//

#import "GQHSlideViewCollectionViewCell.h"


@implementation GQHSlideViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 图片视图
        [self.contentView addSubview:self.qh_imageView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _qh_imageView.frame = self.bounds;
}

#pragma mark - Setter

#pragma mark - Getter

- (UIImageView *)qh_imageView {
    
    if (!_qh_imageView) {
        
        _qh_imageView = [[UIImageView alloc] init];
        _qh_imageView.userInteractionEnabled = YES;
    }
    
    return _qh_imageView;
}

@end
