//
//  JKBLEDeviceUtil.m
//  fancyColor-BLE
//
//  Created by wzq on 14/10/17.
//  Copyright (c) 2014年 wzq. All rights reserved.
//

#import "JKBLEDeviceUtil.h"
#import "JKBLEServicAndCharacter.h"
#import "JKBLEManager.h"


@interface JKBLEDeviceUtil()

{
    CBCentralManager *cbCentralMgr;
    NSMutableArray *deviceArray;
    NSMutableArray *connectedDevices;
    NSMutableArray *allChannel;
}


@end

@implementation JKBLEDeviceUtil

static JKBLEDeviceUtil *shareInstance = nil;

+ (JKBLEDeviceUtil *)shareInstance
{
    @synchronized(self)
    {
        if (shareInstance == nil)
        {
            shareInstance =  [[super allocWithZone:NULL] init];
        }
    }
    return shareInstance;

}

- (instancetype)init
{
    self = [super init];

    deviceArray = [NSMutableArray new];
    connectedDevices = [NSMutableArray new];
    cbCentralMgr = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    allChannel = [NSMutableArray new];

    return self;
}

- (void)beginScan
{
    [self refresh];
}

- (void)connect
{
    [self connectBLE];
}

- (void)disConnect
{
    
    for (CBPeripheral *per in deviceArray)
    {
        [cbCentralMgr cancelPeripheralConnection:per];
    }
    
}

- (void)refresh
{
    [self disConnect];
    [self centralManagerDidUpdateState:cbCentralMgr];
    usleep(30000);
    [self connectBLE];

}

- (NSArray *)getAllBLEDevices
{
    return deviceArray;
}

- (NSArray *)getBLEDeviceByUUID:(NSString *)uuid
{
    NSMutableArray *array = [NSMutableArray new];
    for (CBPeripheral *per in deviceArray) {
        if ([per.identifier.UUIDString isEqualToString:uuid] && ![array containsObject:per])
        {
            [array addObject:per];
        }
    }
    
    return array;
}


- (NSArray *)getBLEDeviceByName:(NSString *)name
{
    NSMutableArray *array = [NSMutableArray new];
    for (CBPeripheral *per in deviceArray) {
        if ([per.name isEqualToString:name] && ![array containsObject:per])
        {
            [array addObject:per];
        }
    }
    
    return array;
}

- (void)writeData:(NSData*)data withUUID:(NSString *)UUID toBLEDevice:(NSArray *)devices
{
    NSMutableArray *charas = [NSMutableArray new];
    
    for (CBPeripheral *per in devices)
    {
        for (CBService *ser in per.services)
        {
            for (CBCharacteristic *chara in ser.characteristics)
            {
                if ([chara.UUID isEqual:[CBUUID UUIDWithString:UUID]]
                    && ![charas containsObject:chara])
                {
                    [charas addObject:chara];
                }
            }
        }
    }
    
    for (CBCharacteristic *chara in charas)
    {
        [chara.service.peripheral writeValue:data forCharacteristic:chara type:CBCharacteristicWriteWithoutResponse];
    }
    
    
}

- (void)connectBLE
{
    for (CBPeripheral *per in deviceArray)
    {
        if (per.state != CBPeripheralStateConnected)
        {
            [cbCentralMgr connectPeripheral:per options:nil];
        }
        
    }
    [cbCentralMgr stopScan];

}

#pragma mark - coreblue delegate
#pragma  mark - centralManagerdelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
            
        case CBCentralManagerStatePoweredOn:
            
            // Scans for any peripheral
            NSLog(@"------------start scanning------------");
            [cbCentralMgr scanForPeripheralsWithServices: nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES }];
            
            break;
            
        default:
            
            NSLog(@"Central Manager did change state");
            
            break;
            
    }
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI

{
    
    if (![deviceArray containsObject:peripheral])
    {
        
        [deviceArray addObject:peripheral];

    }
    

    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral

{
    //链接成功后必须去发现service
    NSLog(@"connected successfully:%d",peripheral.RSSI.intValue);
    
    if (![connectedDevices containsObject:peripheral])
    {
        [connectedDevices addObject:peripheral];
    }
    
    peripheral.delegate = self;
    
    NSLog(@"搜索服务");
    [peripheral discoverServices:nil];
    
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
    NSLog(@"-----------断开");
    if ([connectedDevices containsObject:peripheral])
    {
        [connectedDevices removeObject:peripheral];
    }
    
    //设备总数和连接的设备数去除
    if ([deviceArray containsObject:peripheral])
    {
        
        [deviceArray removeObject:peripheral];
        
    }
    
    [self connectBLE];
    NSLog(@"-----------重新连接");
    
    
    
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"-----occur some error");
    [self connectBLE];
    
}




#pragma mark - peripheraldelegate

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    
    NSLog(@"RSSI 变化：%@",peripheral.RSSI);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error

{
    if( peripheral.identifier == NULL  ) return;
    if (!error) {
        NSLog(@"====%@\n",peripheral.name);
        NSLog(@"=========== %d of service for UUID %@ ===========\n",peripheral.services.count,peripheral.identifier.UUIDString);
        
        //一个外围设备含有多个服务通道，每个通道下面有多个特征，下一个通过服务通道寻找特征传输通道
        for (CBService *p in peripheral.services)
        {
            NSLog(@"Service found with UUID: %@\n", p.UUID);
            
            //判断选择相应通道的服务uuid，如果是该通道就去发现该特征值
            //屏蔽此处可以得到设备的所有服务通道
//            if ([p.UUID isEqual:[CBUUID UUIDWithString:self.serviceUUID]])
            {
                [peripheral discoverCharacteristics:nil forService:p];
            }
            
            [peripheral readRSSI];
        }
        
    }
    else {
        NSLog(@"Service discovery was unsuccessfull !\n");
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error

{
    
    //    CBService *s = [peripheral.services objectAtIndex:(peripheral.services.count - 1)];
    
    if (!error) {
        NSLog(@"--------发现服务--------");
        
        //每个服务通道下面有多个特征通道
//        for(CBCharacteristic *chara in service.characteristics)
//        {
//            
//            NSLog(@"cbcharacteristic =%@",chara);
//            
//            
//            JKBLEServicAndCharacter *bAndc = [[JKBLEServicAndCharacter alloc]init];
//            
//            //获取透传通道
////            if ([chara.UUID isEqual:[CBUUID UUIDWithString:WRITE_CHARA_UUID]])
//            {
////                writeCharacteristic = chara;//透传特征
//                
//                bAndc.bleDevice = peripheral;
//                bAndc.character = chara;
//                if (![[JKBLEManager shareInstance].writeCharacteristic containsObject:bAndc])
//                {
//                    [[JKBLEManager shareInstance].writeCharacteristic addObject:bAndc];
//                }
//                
//            }
//            
//        }
//        NSLog(@"===服务添加成功===\n");
        
        
    }
    else
    {
        NSLog(@"Characteristic discorvery failed !\n");
        
    }
    
    
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    
//    uint8_t val = 1;
//    NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
//    [peripheral writeValue:valData forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
}


//发送数据的返回
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"=======%@",error.userInfo);
    }else{
        
        NSLog(@"发送数据成功");
    }
}


@end
