//
//  JKDefineMenuView.h
//  BlueToothBLE
//
//  Created by jkjk on 15/11/17.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

typedef enum {
    JKDefineMenuViewTop,
    JKDefineMenuViewBottom
} JKDefineMenuStyle;

@protocol JKDefineMenuViewDelegate <NSObject>

- (CGRect)menuFrame;

@end

@interface JKDefineMenuView : UIView
@property (nonatomic,assign) JKDefineMenuStyle style;
@property (nonatomic,assign) CGFloat animationDuration;
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,assign) BOOL allowAutoDisappear;

- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)view;
- (void)showMenu;
- (void)dismissMenu;
@end
