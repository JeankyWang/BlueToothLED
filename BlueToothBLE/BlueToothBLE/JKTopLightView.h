//
//  JKTopLightView.h
//  BlueToothBLE
//
//  Created by wzq on 15/11/15.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKTopLightViewDelegate <NSObject>

- (void)offOnBtnClick:(UIButton *)offOnButton;
- (void)conditionBtnClick:(UIButton *)conditionBtn;

@end

@interface JKTopLightView : UIView
@property (nonatomic,assign) id<JKTopLightViewDelegate> delegate;
- (void)setLightColor:(UIColor *)color;
@end
