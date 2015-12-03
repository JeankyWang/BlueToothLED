//
//  JKControlViewController.h
//  BlueToothBLE
//
//  Created by wzq on 15/11/13.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "JKSceneModel.h"

@interface JKControlViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic,strong) NSArray *deviceArray;
@property (nonatomic,strong) CBCharacteristic *writeCharacter;
@property (nonatomic,strong) JKSceneModel *currentScene;
@end
