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
        lightBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 60)];
        lightBgView.backgroundColor = [UIColor redColor];
        [lightBgView addSubview:light];
        
        [self addSubview:lightBgView];
        
        
        conditionBtn = [[UIButton alloc] initWithFrame:CGRectMake(18, CGRectGetHeight(frame)/2-12.5, 25, 25)];
    }
    
    return self;
}

- (void)setLightColor:(UIColor *)color
{

}

@end
