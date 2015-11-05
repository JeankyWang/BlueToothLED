//
//  JKBLEServicAndCharacter.h
//  fancyColor-BLE
//
//  Created by wzq on 14/8/25.
//  Copyright (c) 2014年 wzq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

/**
 <p style="color:red;font-size:16px;">一个设备对一个其中一个可用的特征值</p>
 <strong>bleDevice:</strong> 蓝牙设备
 <br>
 <strong>character:</strong> 可写的通道特征
 **/
@interface JKBLEServicAndCharacter : NSObject
@property (nonatomic, strong) CBPeripheral *bleDevice;
@property (nonatomic, strong) CBCharacteristic *character;
@end
