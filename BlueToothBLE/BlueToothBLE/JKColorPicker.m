//
//  JKColorPicker.m
//  BlueToothBLE
//
//  Created by klicen on 15/11/17.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKColorPicker.h"

@implementation JKColorPicker

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
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"color_pan"]];
        [self addSubview:img];
    }
    
    return self;
}

@end
