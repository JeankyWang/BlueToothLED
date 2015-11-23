//
//  JKScenesTableViewController.h
//  BlueToothBLE
//
//  Created by wzq on 15/11/5.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKScenesSelectDelegate <NSObject>

- (void)addScenes:(NSArray *)scenes;

@end

@interface JKScenesTableViewController : UITableViewController
@property (nonatomic,assign) id<JKScenesSelectDelegate> delegate;
@end
