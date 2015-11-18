//
//  JKTopLightView.m
//  BlueToothBLE
//
//  Created by wzq on 15/11/15.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKTopLightView.h"

@interface JKTopLightView ()
{
    UIButton *offOnBtn;
    UIButton *conditionBtn;
    UIView *lightBgView;
}
@end

@implementation JKTopLightView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        offOnBtn = [[UIButton alloc] initWithFrame:CGRectMake(FullScreen_width/4 - 35, CGRectGetHeight(frame)/2-12.5, 50, 50)];
        [offOnBtn setImage:[UIImage imageNamed:@"light_on"] forState:UIControlStateSelected];
        [offOnBtn setImage:[UIImage imageNamed:@"light_off"] forState:UIControlStateNormal];
        [offOnBtn addTarget:self action:@selector(offOnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:offOnBtn];
        
        UIImageView *light = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"light_bg"]];
        
        //灯光色view
        lightBgView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2 - 22.5, frame.size.height/2 - 30, 45, 60)];
        lightBgView.layer.cornerRadius = 20;
        lightBgView.backgroundColor = [UIColor lightGrayColor];
        light.center = CGPointMake(lightBgView.center.x, lightBgView.center.y-5);
        [self addSubview:lightBgView];
        [self addSubview:light];
        
        conditionBtn = [[UIButton alloc] initWithFrame:CGRectMake(FullScreen_width * 3/4 + 10, CGRectGetHeight(frame)/2-12.5, 50, 50)];
        [conditionBtn setImage:[UIImage imageNamed:@"light_condition"] forState:UIControlStateNormal];
        [conditionBtn addTarget:self action:@selector(conditionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:conditionBtn];
    }
    
    return self;
}

- (void)offOnBtnClick:(UIButton *)button
{
    button.selected = !button.selected;
    if ([_delegate respondsToSelector:@selector(offOnBtnClick:)]) {
        [_delegate offOnBtnClick:button];
    }
}

- (void)conditionBtnClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(conditionBtnClick:)]) {
        [_delegate conditionBtnClick:button];
    }
}

- (void)setLightColor:(UIColor *)color
{
    lightBgView.backgroundColor = color;
}

@end
