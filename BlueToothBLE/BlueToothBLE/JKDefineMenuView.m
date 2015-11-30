//
//  JKDefineMenuView.m
//  BlueToothBLE
//
//  Created by klicen on 15/11/17.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKDefineMenuView.h"

@interface JKDefineMenuView ()
{
    UIView *backView;
    UIView *superView;
    CGRect finalFrame;
    CGRect orignalFrame;
    BOOL isShowing;
    
    FXBlurView *blur;
}
@end

@implementation JKDefineMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)view
{
    self = [super initWithFrame:frame];
    finalFrame = frame;
    superView = view;
    
    self.allowAutoDisappear = YES;
    
    blur = [[FXBlurView alloc] initWithFrame:frame];
    blur.blurRadius = 15;
    blur.dynamic = YES;
    blur.blurEnabled = YES;
    blur.tintColor = [UIColor clearColor];
    
    
    //ios 8
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    effectView.frame = self.bounds;
//    [self addSubview:effectView];
    
    return self;

}

- (void)setBackgroundView:(UIView *)backgroundView
{
    self.backgroundView = backgroundView;
    backgroundView.frame = self.bounds;
//    [self addSubview:backgroundView];
}

- (void)showMenu
{
    if (isShowing) {
        return;
    }
    
    backView = [[UIView alloc] initWithFrame:superView.frame];
    backView.backgroundColor = [UIColor clearColor];
    
    if (_allowAutoDisappear) {
        [self addAllGesture:backView];
    }
    
    
    
    [backView addSubview:self];
    
    if (_style == JKDefineMenuViewTop) {
        
        //上部菜单
        orignalFrame = CGRectMake(CGRectGetMinX(finalFrame), -CGRectGetHeight(finalFrame), CGRectGetWidth(finalFrame), CGRectGetHeight(finalFrame));
    } else {
        
        orignalFrame = CGRectMake(CGRectGetMinX(finalFrame), CGRectGetMaxY(superView.frame), CGRectGetWidth(finalFrame), CGRectGetHeight(finalFrame));
    }
    
    self.frame = orignalFrame;
    blur.frame = finalFrame;
    blur.alpha = 0;
    
    [superView addSubview:blur];
    [superView addSubview:backView];
    
    
    
    [UIView animateWithDuration:.25 animations:^{
        self.frame = finalFrame;
        blur.alpha = 1;
    } completion:^(BOOL finished) {
        
        isShowing = YES;
    }];
    

}

- (void)addAllGesture:(UIView *)view
{
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackView:)];
    [view addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipBackView:)];
    [view addGestureRecognizer:swip];
    
}

- (void)dismissMenu
{
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.frame = orignalFrame;
        blur.frame = orignalFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [blur removeFromSuperview];
        [backView removeFromSuperview];
        isShowing = NO;
        
    }];

}

- (void)tapBackView:(UITapGestureRecognizer *)tap
{
    [self dismissMenu];
}

- (void)swipBackView:(UISwipeGestureRecognizer *)swipe
{
    [self dismissMenu];
}


@end
