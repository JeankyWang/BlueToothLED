//
//  JKSendDataTool.m
//  BlueToothBLE
//
//  Created by klicen on 15/12/2.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKSendDataTool.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "JKBLEsManager.h"

const static Byte start = 0xfe;// fe 7e
const static Byte end = 0xef;

@implementation JKSendDataTool

static JKSendDataTool *singleton;
+ (JKSendDataTool *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[super allocWithZone:NULL] init];
    });
    
    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self shareInstance];
}

- (void)openLight:(NSArray *)deviceArray
{
    Byte dataON[9]  = {start,0x04,0x04,0x01,0x00,0xff,0xff,0x0,end};
    NSData *data = [[NSData alloc]initWithBytes:dataON length:9];
    [self sendCMD:data devices:deviceArray];
}

- (void)closeLight:(NSArray *)deviceArray
{
    Byte dataOFF[9] = {start,0x04,0x04,0x00,0x00,0xff,0xff,0x0,end};
    NSData *data = [[NSData alloc]initWithBytes:dataOFF length:9];
    [self sendCMD:data devices:deviceArray];
}

- (void)sendDataBright:(Byte)brightness devices:(NSArray *)deviceArray
{
    Byte byte[] = {start,0x04,0x01,brightness==100?99:brightness,0xff,0xff,0xff,0x00,end};
    NSData *data = [[NSData alloc]initWithBytes:byte length:9];
    [self sendCMD:data devices:deviceArray];
}

- (void)sendDataRGBWithRed:(Byte)red green:(Byte)green blue:(Byte)blue devices:(NSArray *)deviceArray
{
    Byte byte[] = {start,0x07,0x05,0x03,red,green,blue,0x0,end};
    
    NSData *data = [[NSData alloc]initWithBytes:byte length:sizeof(byte)];
    [self sendCMD:data devices:deviceArray];
}

- (void)sendDataCTWithHot:(Byte)hot cold:(Byte)cold devices:(NSArray *)deviceArray
{
    Byte byte[] = {start,0x06,0x05,0x02,hot,cold,0xff,0x08,end};
    NSData *data = [[NSData alloc]initWithBytes:byte length:9];
    [self sendCMD:data devices:deviceArray];
}

- (void)sendDataDMBright:(Byte)brightness devices:(NSArray *)deviceArray
{
    Byte byte[] = {start,0x05,0x05,0x01,brightness,0xff,0xff,0x08,end};
    NSData *data = [[NSData alloc]initWithBytes:byte length:9];
    [self sendCMD:data devices:deviceArray];
}

- (void)sendDataSpeedWithValue:(Byte)speed devices:(NSArray *)deviceArray
{
    DLog(@"speed sending:%d",speed);
    
    Byte byte[9] = {start,0x04,0x02,speed,0xff,0xff,0xff,0x0,end};
    NSData *data = [[NSData alloc]initWithBytes:byte length:9];
    [self sendCMD:data devices:deviceArray];
}

- (void)sendDataModelWithValue:(Byte)value devices:(NSArray *)deviceArray
{
    DLog(@"rbg mode %d",0x80+value);
    Byte rgb[9] = {start,0x05,0x03,0x80+value,0x03,0xff,0xff,0x00,end};
    NSData *data = [[NSData alloc]initWithBytes:rgb length:9];
    [self sendCMD:data devices:deviceArray];
    
    
}

- (void)sendDataLightType:(JKLightChangeMode)mode speed:(NSInteger)speed colorCount:(NSInteger)count devices:(NSArray *)deviceArray
{
    Byte rgb[9] = {start,0x07,0x0e,mode,speed,count,0xff,0xff,end};
    NSData *data = [[NSData alloc]initWithBytes:rgb length:9];
    [self sendCMD:data devices:deviceArray];
}

- (void)sendCMD:(NSData*)data devices:(NSArray *)deviceArray
{
    for (CBPeripheral *per in deviceArray)
    {
        [per writeValue:data forCharacteristic:[JKBLEsManager sharedInstance].writeCharacter type:CBCharacteristicWriteWithoutResponse];
    }
}


@end
