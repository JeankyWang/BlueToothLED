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
    return self;

}

- (void)setBackgroundView:(UIView *)backgroundView
{
    self.backgroundView = backgroundView;
    backgroundView.frame = self.bounds;
    [self addSubview:backgroundView];
}

- (void)showMenu
{
    if (isShowing) {
        return;
    }
    
    backView = [[UIView alloc] initWithFrame:superView.frame];
    backView.backgroundColor = [UIColor clearColor];
    [self addAllGesture:backView];
    [backView addSubview:self];
    [superView addSubview:backView];
    
    
    if (_style == JKDefineMenuViewTop) {
        
        //上部菜单
        orignalFrame = CGRectMake(CGRectGetMinX(finalFrame), -CGRectGetHeight(finalFrame), CGRectGetWidth(finalFrame), CGRectGetHeight(finalFrame));
    } else {
        
        orignalFrame = CGRectMake(CGRectGetMinX(finalFrame), CGRectGetMaxY(superView.frame), CGRectGetWidth(finalFrame), CGRectGetHeight(finalFrame));
    }
    
    self.frame = orignalFrame;
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.frame = finalFrame;
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
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
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
