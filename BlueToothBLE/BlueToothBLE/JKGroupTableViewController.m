//
//  JKGroupTableViewController.m
//  fancyColor-BLE
//
//  Created by wzq on 14/8/16.
//  Copyright (c) 2014年 wzq. All rights reserved.
//

#import "JKGroupTableViewController.h"
#import "JKBLEManager.h"
#import "FXBlurView.h"

#define _GROUP_KEY_ @"_group_"
#define NO_DEVICE_ALERT_TAG 100
#define NO_NAME_ALERT_TAG 101
#define WRITE_SERVICE_UUID @"FFE5"
#define WRITE_CHARA_UUID @"FFE9"
//#define WRITE_SERVICE_UUID_OTHER @"FF10"
//#define WRITE_CHARA_UUID_OTHER @"FF11"
#define WRITE_SERVICE_UUID_OTHER @"49535343-FE7D-4AE5-8FA9-9FAFD205E455"
#define WRITE_CHARA_UUID_OTHER @"49535343-8841-43F4-A8D4-ECBE34729BB3"

@interface JKGroupTableViewController ()
{
    NSMutableArray *groupArray;
    CBCharacteristic *writeCharacteristic;
    
    NSMutableArray *writeChars;
    NSMutableArray *allDevices;
    NSMutableArray *connectedDevice;
    
    NSMutableArray *currentDevice;
    NSInteger selectRowNo;
    
    
    UIView *searchView;
    UIView *rotationView;
    UIView *noBLEView;
    
    
    CGFloat angle;
    
    NSTimer *searchingTime;
}
@end

@implementation JKGroupTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupData];
    [self setupUI];
    [self startAnimation];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(refreshBle:)];
    
    self.tableview.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.tableview];
    self.tableview.tableFooterView = [UIView new];
    self.tableview.backgroundColor = [UIColor clearColor];
    CGRect frame = self.tableview.frame;
    frame.size.width = FullScreen_width;
    self.tableview.frame = frame;
    
    
    [self setupSearchingView];
}

- (void)setupSearchingView
{
    searchView = [[UIView alloc] initWithFrame:self.view.bounds];
    searchView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searching_img"]];
    imageView.center = searchView.center;
    [searchView addSubview:imageView];
    
    
    UILabel *searchingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+10, FullScreen_width, 20)];
    searchingLabel.textAlignment = NSTextAlignmentCenter;
    searchingLabel.text = @"搜索中...";
    searchingLabel.textColor = [UIColor whiteColor];
    searchingLabel.font = Font(14);
    [searchView addSubview:searchingLabel];
    
    
    
    rotationView = [[UIView alloc] initWithFrame:imageView.bounds];
    
    
    UIImageView *spot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searching_spot"]];
    spot.frame = CGRectMake(CGRectGetWidth(imageView.frame)/2 - CGRectGetWidth(spot.frame)/2, 32, CGRectGetWidth(spot.frame), CGRectGetWidth(spot.frame));

    [rotationView addSubview:spot];
    [imageView addSubview:rotationView];
    rotationView.transform = CGAffineTransformMakeRotation(1);
    
    [self.view addSubview:searchView];
    
    
    searchingTime = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(hideSearchView) userInfo:nil repeats:NO];

}

- (void)showNoBLEView
{
    noBLEView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    imageView.center = searchView.center;
    [searchView addSubview:imageView];
    
    UILabel *noBLELabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+10, FullScreen_width, 20)];
    noBLELabel.textAlignment = NSTextAlignmentCenter;
    noBLELabel.text = @"没有设备";
    noBLELabel.textColor = [UIColor whiteColor];
    noBLELabel.font = Font(14);
    [noBLEView addSubview:noBLELabel];
    
    [self.view addSubview:noBLEView];
}

- (void)hideNoBLEView
{
    [noBLEView removeFromSuperview];
}

- (void)hideSearchView
{
    [searchView removeFromSuperview];
    if (_peripheralArray.count == 0) {
        [self showNoBLEView];
    }
}

- (void)setupData
{
    
    groupArray = [NSMutableArray arrayWithCapacity:0];
    allDevices = [NSMutableArray arrayWithCapacity:0];
    
    
    self.peripheralArray = [NSMutableArray new];
    connectedDevice = [NSMutableArray new];
    
    [allDevices addObject:@{@"name":NSLocalizedString(@"ALL DEVICES", @""),@"device":_peripheralArray,@"status":@false}];
    NSMutableArray *mulDict = [[NSUserDefaults standardUserDefaults] objectForKey:_GROUP_KEY_];
    
    if (mulDict) {
        [groupArray addObjectsFromArray:mulDict];
    }
    
    
    self.cbCentralMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    writeChars = [NSMutableArray new];
    currentDevice = [NSMutableArray new];


}


- (void)startAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.005];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startAnimation)];
    angle += 3;
    
    if (angle == 360) {
        angle = 0;
    }
    
    rotationView.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (IBAction)refreshBle:(id)sender
{
    
    
    for (CBPeripheral *per in _peripheralArray) {
        [_cbCentralMgr cancelPeripheralConnection:per];
    }
    
    [_peripheralArray removeAllObjects];
    [self centralManagerDidUpdateState:self.cbCentralMgr];
    
}

//全部打开
- (void)allOn:(id)sender
{

    
    for ( int i = 0 ; i<groupArray.count; i++) {
        NSDictionary *dict = [groupArray objectAtIndex:i];
        NSMutableDictionary *m_dict = [NSMutableDictionary dictionaryWithDictionary:dict];
        [m_dict setValue:@true forKey:@"status"];
        
        [groupArray replaceObjectAtIndex:i withObject:m_dict];
    }
    
    
    
    Byte cmd[] = {0x7e,0x04,0x04,0x01,0x00,0xff,0xff,0x0,0xef};
    NSData *data = [NSData dataWithBytes:&cmd length:sizeof(cmd)];


    
    for (JKBLEServicAndCharacter *bc in [JKBLEManager shareInstance].writeCharacteristic)
    {
        [bc.bleDevice writeValue:data forCharacteristic:bc.character type:CBCharacteristicWriteWithoutResponse];
    }
   
    [_tableview reloadData];
}



- (void)connectBLE
{
    
    [self.cbCentralMgr stopScan];
    
    if(_peripheralArray == nil || _peripheralArray.count == 0)
    {
        return;
    }
    
    for (CBPeripheral *per in _peripheralArray)
    {
        if (per.state != CBPeripheralStateConnected)
        {
            [self.cbCentralMgr connectPeripheral:per options:nil];
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section==0)
    {
        return 1;
    }
    return _peripheralArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell"];
    if (!cell)
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"groupCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    
    cell.textLabel.text = @"BLE";


    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (_peripheralArray.count == 0)
    {
        return;
    }
    
    
    

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            return NO;
            break;
            
        default:
            return YES;
            break;
    }
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [groupArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        
        
    }
}


#pragma mark -action sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

#pragma mark - alert delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

}


#pragma mark - coreblue delegate
#pragma  mark - centralManagerdelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
            
        case CBCentralManagerStatePoweredOn:
            
            
            [self.cbCentralMgr scanForPeripheralsWithServices: nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES }];
            
            break;
            
        default:
            
            DLog(@"可能不支持蓝牙");
            
            break;
            
    }
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI

{
    
    if (![_peripheralArray containsObject:peripheral])
    {
        
        [_peripheralArray addObject:peripheral];
        [_tableview reloadData];
    }
    
    DLog(@"%@",RSSI);
        
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral

{
    //链接成功后必须去发现service
    DLog(@"connected successfully:%d",peripheral.RSSI.intValue);
    
    if (![connectedDevice containsObject:peripheral])
    {
        [connectedDevice addObject:peripheral];
        [self.tableview reloadData];
    }
    
    peripheral.delegate = self;
    
    DLog(@"搜索服务");
    [peripheral discoverServices:@[[CBUUID UUIDWithString:@"FFE5"],[CBUUID UUIDWithString:WRITE_SERVICE_UUID_OTHER]]];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
    DLog(@"-----------断开");
    if ([connectedDevice containsObject:peripheral])
    {
        [connectedDevice removeObject:peripheral];
    }
    
    //设备总数和连接的设备数去除
    if ([_peripheralArray containsObject:peripheral])
    {
        
//        [_peripheralArray removeObject:peripheral];

    }
    
    [self.tableview reloadData];
    
    [self connectBLE];
    DLog(@"-----------重新连接");
    
    

}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
    [self connectBLE];
    
}




#pragma mark - peripheraldelegate

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    
    DLog(@"RSSI 变化：%@",peripheral.RSSI);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error

{
    if( peripheral.identifier == NULL  ) return;
    if (!error) {
        DLog(@"====%@\n",peripheral.name);
        DLog(@"=========== %l of service for UUID %@ ===========\n",peripheral.services.count,peripheral.identifier.UUIDString);
        
        //一个外围设备含有多个服务通道，每个通道下面有多个特征，下一个通过服务通道寻找特征传输通道
        for (CBService *p in peripheral.services)
        {
            DLog(@"Service found with UUID: %@\n", p.UUID);
            
            //判断选择相应通道的服务uuid，如果是该通道就去发现该特征值
            if ([p.UUID isEqual:[CBUUID UUIDWithString:WRITE_SERVICE_UUID]]
                || [p.UUID isEqual:[CBUUID UUIDWithString:WRITE_SERVICE_UUID_OTHER]])
            {
                [peripheral discoverCharacteristics:nil forService:p];
            }
            
            [peripheral readRSSI];
        }
        
    }
    else {
        DLog(@"Service discovery was unsuccessfull !\n");
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error

{
    
//    CBService *s = [peripheral.services objectAtIndex:(peripheral.services.count - 1)];
    
    if (!error) {
        DLog(@"--------发现服务--------");
        for(CBCharacteristic *c in service.characteristics)
        {
            
            DLog(@"cbcharacteristic =%@",c);
            
            
            JKBLEServicAndCharacter *bAndc = [[JKBLEServicAndCharacter alloc]init];
            
            //活得可用通道
            if ([c.UUID isEqual:[CBUUID UUIDWithString:WRITE_CHARA_UUID]]
                || [c.UUID isEqual:[CBUUID UUIDWithString:WRITE_CHARA_UUID_OTHER]]) {
                writeCharacteristic = c;
                
                bAndc.bleDevice = peripheral;
                bAndc.character = c;
                if (![[JKBLEManager shareInstance].writeCharacteristic containsObject:bAndc])
                {
                    [[JKBLEManager shareInstance].writeCharacteristic addObject:bAndc];
                }
                
            }
            
        }
        DLog(@"===服务添加成功===\n");
        
        
    }
    else {
        DLog(@"Characteristic discorvery unsuccessfull !\n");
        
    }
    
    
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    
    uint8_t val = 1;
    NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
    [peripheral writeValue:valData forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
}


//发送数据的返回
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        DLog(@"=======%@",error.userInfo);
    }else{
        
        DLog(@"发送数据成功");
    }
}

@end
