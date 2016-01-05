//
//  JKColorPicker.m
//  BlueToothBLE
//
//  Created by klicen on 15/11/17.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKColorPicker.h"
#import "UIImage+ColorAtPixel.h"


@interface JKColorPicker ()
{
    UIImageView *spot;
    UIImageView *img;
}
@end


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
        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"color_pan"]];
        [self addSubview:img];
        spot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"color_picker"]];
    }
    
    return self;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event
{
    CGPoint point = [touch locationInView:self];
    
    if ([self distanceToCenter:point] > CGRectGetWidth(self.frame)/2|| [self distanceToCenter:point] < 32) {
        return NO;
    }
    
    
    [self addLocationSpot:point];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event
{
    CGPoint point = [touch locationInView:self];
    
    
    if ([self distanceToCenter:point] > CGRectGetWidth(self.frame)/2 || [self distanceToCenter:point] < 32)
    {
        return NO;
    }
    
    [self addLocationSpot:point];
    return YES;
}

- (CGFloat)distanceToCenter:(CGPoint)point
{
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat distance = sqrtf((center.x - point.x)*(center.x - point.x) + (center.y-point.y)*(center.y-point.y));
    return distance;
}

- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event
{
    CGPoint point = [touch locationInView:self];
    if ([self distanceToCenter:point] > CGRectGetWidth(self.frame)/2-2 || [self distanceToCenter:point] < 33) {
        return;
    }
    
    [self addLocationSpot:point];
}

- (void)addLocationSpot:(CGPoint)point
{
    if (![self.subviews containsObject:spot]) {
        [self addSubview:spot];
    }
    
    spot.center = point;
    
    _selectColor = [img.image colorAtPixel:point];
    [self sendActionsForControlEvents:UIControlEventAllEvents];
    
}


@end
