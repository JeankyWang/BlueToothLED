//
//  JKModeListViewController.h
//  LED Colors
//
//  Created by wzq on 14/6/30.
//  Copyright (c) 2014年 wzq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKUserdefindColorDelegate <NSObject>

- (void)selectdColorArray:(NSArray *)colors;

@end

@interface JKModeListViewController : UIViewController

@property (nonatomic,assign) id<JKUserdefindColorDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *colorsArray;

@end
