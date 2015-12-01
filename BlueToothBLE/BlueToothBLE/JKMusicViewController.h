//
//  JKMusicViewController.h
//  BlueToothBLE
//
//  Created by wzq on 15/11/18.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface JKMusicViewController : UIViewController
@property (nonatomic,strong) NSArray *deviceArray;
@property (nonatomic,strong) CBCharacteristic *writeCharacter;
@end
