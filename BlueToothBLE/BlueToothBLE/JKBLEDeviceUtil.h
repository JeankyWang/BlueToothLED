//
//  JKBLEDeviceUtil.h
//  fancyColor-BLE
//
//  Created by wzq on 14/10/17.
//  Copyright (c) 2014年 wzq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreBluetooth/CoreBluetooth.h"
@interface JKBLEDeviceUtil : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic,copy) NSString *serviceUUID;
@property (nonatomic,copy) NSString *writeCharaUUID;


+ (JKBLEDeviceUtil *)shareInstance;
- (void)beginScan;
- (void)connect;
- (void)disConnect;
- (void)refresh;

- (NSArray *)getAllBLEDevices;
- (NSArray *)getBLEDeviceByUUID:(NSString *)uuid;
- (NSArray *)getBLEDeviceByName:(NSString *)name;
- (void)writeData:(NSData*)data withUUID:(NSString *)UUID toBLEDevice:(NSArray *)devices;

@end
