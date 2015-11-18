//
//  JKScrollView.m
//  BlueToothBLE
//
//  Created by klicen on 15/11/18.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKScrollView.h"

@implementation JKScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[UIControl class]]) {
        
        self.scrollEnabled = NO;
    } else {
        self.scrollEnabled = YES;
    }
    
    return view;
}

@end
