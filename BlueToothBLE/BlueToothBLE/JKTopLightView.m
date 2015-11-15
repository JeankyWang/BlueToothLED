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
        offOnBtn = [[UIButton alloc] initWithFrame:CGRectMake(18, CGRectGetHeight(frame)/2-12.5, 25, 25)];
        
        UIImageView *light = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"light_bg"]];
        
        lightBgView = [[UIView alloc] initWithFrame:CGRectMake(light.center.x - 22.5, light.center.y + 10 - 35, 45, 60)];
        lightBgView.layer.cornerRadius = 20;

        lightBgView.backgroundColor = [UIColor redColor];
        
        [self addSubview:lightBgView];
        [self addSubview:light];
        
        conditionBtn = [[UIButton alloc] initWithFrame:CGRectMake(18, CGRectGetHeight(frame)/2-12.5, 25, 25)];
    }
    
    return self;
}

- (void)setLightColor:(UIColor *)color
{

}

@end
