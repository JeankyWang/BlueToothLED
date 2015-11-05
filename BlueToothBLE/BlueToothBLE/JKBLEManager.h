//
//  JKBLEManager.h
//  fancyColor-BLE
//
//  Created by wzq on 14/8/19.
//  Copyright (c) 2014年 wzq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface JKBLEManager : NSObject

//全部设备和对应的特征
@property (nonatomic, strong) NSMutableArray *writeCharacteristic;
+ (JKBLEManager *)shareInstance;
@end
