//
//  JKTimerViewController.h
//  BlueToothBLE
//
//  Created by wzq on 15/11/18.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKSceneModel.h"

@interface JKTimerViewController : UIViewController
@property (nonatomic,strong) JKSceneModel *currentScene;
@property (nonatomic,strong) NSArray *deviceArray;
@end
