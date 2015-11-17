//
//  JKDefineMenuView.h
//  BlueToothBLE
//
//  Created by klicen on 15/11/17.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import <UIKit/UIKit.h>


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

- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)view;
- (void)showMenu;
- (void)dismissMenu;
@end
