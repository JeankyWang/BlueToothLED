//
//  JKNewScenceController.h
//  BlueToothBLE
//
//  Created by wzq on 15/11/13.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKSceneModel.h"

@protocol JKNewScenceDelegate <NSObject>

- (void)addNewScene:(JKSceneModel *)newScene;

@end

@interface JKNewScenceController : UITableViewController
@property (nonatomic,assign) id<JKNewScenceDelegate> delegate;
@end
