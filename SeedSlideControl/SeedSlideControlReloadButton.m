//
//  SeedSlideControlReloadButton.m
//  SeedSlideControl
//
//  Created by Hao on 2021/1/27.
//  Copyright © 2021 GuanQinghao. All rights reserved.
//

#import "SeedSlideControlReloadButton.h"


@implementation SeedSlideControlReloadButton

#pragma mark --------------------------- <lifecycle> ---------------------------

+ (instancetype)s_reloadButton {
    
    UIButton *internalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    internalButton.backgroundColor = [UIColor grayColor];
    internalButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    internalButton.layer.cornerRadius = 5.0f;
    internalButton.clipsToBounds = YES;
    
    NSString *bundleName = @"SeedSlideControl.bundle";
    NSString *bundlePath = [[NSBundle bundleForClass:NSClassFromString(@"SeedSlideControl")] pathForResource:@"reload.png" ofType:nil inDirectory:bundleName];
    [internalButton setImage:[UIImage imageWithContentsOfFile:bundlePath] forState:UIControlStateNormal];
    
    return internalButton;
}

#pragma mark ---------------------------- <layout> ----------------------------

#pragma mark ---------------------------- <method> ----------------------------

#pragma mark - private method

#pragma mark ------------------------ <setter & getter> ------------------------

#pragma mark - setter

@end
