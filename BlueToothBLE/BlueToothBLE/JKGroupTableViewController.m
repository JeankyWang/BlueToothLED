//
//  JKGroupTableViewController.m
//  fancyColor-BLE
//
//  Created by wzq on 14/8/16.
//  Copyright (c) 2014年 wzq. All rights reserved.
//

#import "JKGroupTableViewController.h"
#import "JKBLEManager.h"


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
}
@end

@implementation JKGroupTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    
    
    
    
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ble_bg"]];
    img.frame = self.view.bounds;
    [self.view addSubview:img];
    
    groupArray = [NSMutableArray arrayWithCapacity:0];
    allDevices = [NSMutableArray arrayWithCapacity:0];
    [self.view bringSubviewToFront:self.tableview];
    self.tableview.tableFooterView = [UIView new];
    self.tableview.backgroundColor = [UIColor clearColor];
    CGRect frame = self.tableview.frame;
    frame.size.width = FullScreen_width;
    self.tableview.frame = frame;

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


- (void)timerTest
{
    
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
    NSLog(@"running--");
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.toolbar setHidden:NO];
    
}


- (IBAction)addGroup:(id)sender
{

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Add new group", @"")
                                                   message:@""
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                         otherButtonTitles:NSLocalizedString(@"Confirm", @""), nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *groupFiled = [alert textFieldAtIndex:0];
    alert.tag = NO_NAME_ALERT_TAG;
    groupFiled.placeholder = NSLocalizedString(@"Add new group", @"");
    
    [alert show];
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

- (void)switchChanged:(UISwitch *)switcher
{
    
    int index = (int)switcher.tag;
    
    if (index != -1 && switcher.isOn)
    {
        NSMutableArray *dvs = [[groupArray objectAtIndex:index] objectForKey:@"device"];
        if(dvs == nil || dvs.count == 0)
        {
            [switcher setOn:NO];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"warning", @"") message:NSLocalizedString(@"Add device first", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"Confirm", @""), nil];
            alert.tag = NO_DEVICE_ALERT_TAG;
            selectRowNo = index;
            [alert show];
            return;
        }

    }
    
    
    Byte cmd[] = {0x7e,0x04,0x04,switcher.isOn?0x01:0x00,0x00,0xff,0xff,0x0,0xef};
    NSData *data = [NSData dataWithBytes:&cmd length:sizeof(cmd)];
    
    if(index == -1)
    {
        
        for (JKBLEServicAndCharacter *bc in [JKBLEManager shareInstance].writeCharacteristic)
        {
            [bc.bleDevice writeValue:data forCharacteristic:bc.character type:CBCharacteristicWriteWithResponse];
        }
        
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[groupArray objectAtIndex:index]];
    
    [dict setObject:@(switcher.isOn) forKey:@"status"];
     NSMutableArray *array = [[groupArray objectAtIndex:switcher.tag] objectForKey:@"device"];
    
    [currentDevice removeAllObjects];
    
    
    for (NSString *str in array)
    {
        for (JKBLEServicAndCharacter *obj in [JKBLEManager shareInstance].writeCharacteristic)
        {
            if ([obj.bleDevice.identifier.UUIDString isEqualToString:str])
            {
//                [currentDevice addObject:obj];
                [obj.bleDevice writeValue:data forCharacteristic:obj.character type:CBCharacteristicWriteWithResponse];
                
            }
            
            
        }
    }
    
    
    

    [self saveGroup];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -JKBLEListSelectDelegate

- (void)selectBLE:(CBPeripheral*)pers groupNo:(int)row
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[groupArray objectAtIndex:row]];
    NSMutableArray *devs = [NSMutableArray arrayWithArray:[dict objectForKey:@"device"]];
    

    if (![devs containsObject:pers.identifier.UUIDString])
    {
        [devs addObject:pers.identifier.UUIDString];
    }
    
    [dict setObject:devs forKey:@"device"];
    
    [groupArray replaceObjectAtIndex:row withObject:dict];
    
    
    [self saveGroup];
    [_tableview reloadData];
}

- (void)unbindByRow:(NSInteger)row
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[groupArray objectAtIndex:row]];
    NSMutableArray *devs = [NSMutableArray arrayWithArray:[dict objectForKey:@"device"]];
    [devs removeAllObjects];
    [dict setObject:devs forKey:@"device"];
    
    [groupArray replaceObjectAtIndex:row withObject:dict];
    
    [self saveGroup];
    [_tableview reloadData];
}

- (void)controllLight:(UILongPressGestureRecognizer*)guesture
{

////    JKBLEListViewController *vc = [[JKBLEListViewController alloc]init];
//    JKGroupTableViewCell *cell = (JKGroupTableViewCell* )guesture.view;
//    int tag = cell.isOnSwitch.tag;
////    vc.perArray = self.peripheralArray;
////    vc.rowNum = tag;
////    vc.delegate = self;
////    vc.selectedDevices = [[groupArray objectAtIndex:tag] objectForKey:@"device"];
//    
//    JKRGBTabBarViewController *tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"JKRGBTabBarViewController"];
//    NSMutableArray *array = [[groupArray objectAtIndex:tag] objectForKey:@"device"];
//    
//    tabbar.pers = array;
//    [self.navigationController pushViewController:tabbar animated:YES];
//    
//    NSLog(@"进入调节模式");

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
    return groupArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell"];
    if (!cell)
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"groupCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
//        cell.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        cell.imageView.image = [UIImage imageNamed:@"rgb_item1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    
    
    NSDictionary *dict = [NSDictionary dictionary];
    
    if (indexPath.section == 0)
    {
//        cell.isOnSwitch.tag = -1;
        dict = [allDevices objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d %@ %d %@",((NSArray*)[dict objectForKey:@"device"]).count,NSLocalizedString(@"devices", @""),connectedDevice.count,NSLocalizedString(@"connected", @"")];
    }
    else
    {
//        cell.isOnSwitch.tag = indexPath.row;
        dict = [groupArray objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d %@",((NSArray*)[dict objectForKey:@"device"]).count,NSLocalizedString(@"devices", @"")];
    }
//    
    cell.textLabel.text = [dict objectForKey:@"name"];
//    [cell.isOnSwitch setOn:[[dict objectForKey:@"status"] boolValue]];
    
    //为开关增事件
//    [cell.isOnSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(controllLight:)];
    longPress.minimumPressDuration = 2;
    [cell addGestureRecognizer:longPress];

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (_peripheralArray.count == 0)
    {
//        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No device", @"")];
        return;
    }
    
    
//    JKRGBTabBarViewController *tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"JKRGBTabBarViewController"];
    
    //开关状态判断跳转
    if (indexPath.section == 0)
    {
        NSDictionary  *dict = [allDevices objectAtIndex:indexPath.row];
        NSMutableArray *uuids = [NSMutableArray new];
        for (CBPeripheral *per in _peripheralArray) {
            if (![uuids containsObject:per.identifier.UUIDString]) {
                [uuids addObject:per.identifier.UUIDString];
            }
        }
//        tabbar.selectedSceneName = [dict objectForKey:@"name"];
//        tabbar.pers = uuids;
//        [self presentViewController:tabbar animated:YES completion:^{}];

    }
    else
    {   //进入控制界面
        selectRowNo = indexPath.row;
//        
//        if(IOS8)
//        {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Control", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            //
//            
//                NSMutableArray *array = [[groupArray objectAtIndex:indexPath.row] objectForKey:@"device"];
//                
//                if(array == nil || array.count == 0)
//                {
//                    //没有设备进入设备列表进行添加
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"No device", @"") message:NSLocalizedString(@"Add device first", @"") delegate:self cancelButtonTitle:    NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"Confirm", @""), nil];
//                        alert.tag = NO_DEVICE_ALERT_TAG;
//                    
//                        [alert show];
//                        return;
//                    }
//                NSDictionary  *dict = [groupArray objectAtIndex:indexPath.row];
//                tabbar.selectedSceneName = [dict objectForKey:@"name"];
//                tabbar.pers = array;
//                [self presentViewController:tabbar animated:YES completion:^{}];
//          
//            }]];
//        
//            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Adddevice", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            //
//                if (indexPath.section == 0)
//                {
//                    return;
//                }
//                JKBLEListViewController *vc = [[JKBLEListViewController alloc]init];
//                vc.perArray = self.peripheralArray;
//                vc.rowNum = indexPath.row;
//                vc.delegate = self;
//                vc.selectedDevices = [[groupArray objectAtIndex:indexPath.row] objectForKey:@"device"];
//            
//                [self.navigationController pushViewController:vc animated:YES];
//            }]];
//            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//            //
//            }]];
//        
//            [self presentViewController:alert animated:YES completion:nil];
//        }
//        else
        {
        
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Control", @""),NSLocalizedString(@"Adddevice", @""), nil];
            [sheet showInView:self.view];
        }
        
        
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
        // Delete the row from the data source
        [groupArray removeObjectAtIndex:indexPath.row];
        [self saveGroup];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return NSLocalizedString(@"System", @"");
            break;
        case 1:
            return NSLocalizedString(@"User defined", @"");
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark -action sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
//            JKRGBTabBarViewController *tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"JKRGBTabBarViewController"];
            NSMutableArray *array = [[groupArray objectAtIndex:selectRowNo] objectForKey:@"device"];
            
            if(array == nil || array.count == 0)
            {
                //没有设备进入设备列表进行添加
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"No device", @"") message:NSLocalizedString(@"Add device first", @"") delegate:self cancelButtonTitle:    NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"Confirm", @""), nil];
                alert.tag = NO_DEVICE_ALERT_TAG;
                
                [alert show];
                return;
            }
            NSDictionary  *dict = [groupArray objectAtIndex:selectRowNo];
//            tabbar.selectedSceneName = [dict objectForKey:@"name"];
//            tabbar.pers = array;
//            [self presentViewController:tabbar animated:YES completion:^{}];
        }
            break;
        case 1:
            [self jumpToDeviceList:selectRowNo];
            break;

            
        default:
            break;
    }
}

#pragma mark - alert delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:

            break;
        case 1:
        {
            if(alertView.tag == NO_NAME_ALERT_TAG)
            {
                UITextField *groupFiled = [alertView textFieldAtIndex:0];
                NSString *groupName = groupFiled.text;
                
                //组名不可为空
                if (groupName == nil || [groupName isEqualToString:@""])
                {
//                    [SVProgressHUD showErrorWithStatus:@"组名不可为空"];
                    break;
                }
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:groupName,@"name",[NSMutableArray new],@"device", @false,@"status",nil];
                [groupArray addObject:dict];
                [self saveGroup];
                [self.tableview reloadData];
                NSLog(@"添加分组");
            }
            else if (alertView.tag == NO_DEVICE_ALERT_TAG)
            {
                [self jumpToDeviceList:selectRowNo];
            }
            
            
            
            
        }
            break;
        default:
            break;
    }

}

- (void)jumpToDeviceList:(NSInteger)rowNo
{
//    JKBLEListViewController *vc = [[JKBLEListViewController alloc]init];
//    vc.perArray = self.peripheralArray;
//    vc.rowNum = rowNo;
//    vc.delegate = self;
//    vc.selectedDevices = [[groupArray objectAtIndex:rowNo] objectForKey:@"device"];
//    
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)saveGroup
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:groupArray forKey:_GROUP_KEY_];

}



#pragma mark - coreblue delegate
#pragma  mark - centralManagerdelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
            
        case CBCentralManagerStatePoweredOn:
            
            // Scans for any peripheral
            
            [self.cbCentralMgr scanForPeripheralsWithServices: nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES }];
            
            break;
            
        default:
            
            NSLog(@"Central Manager did change state");
            
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
    
    NSLog(@"%@",RSSI);
        
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral

{
    //链接成功后必须去发现service
    NSLog(@"connected successfully:%d",peripheral.RSSI.intValue);
    
    if (![connectedDevice containsObject:peripheral])
    {
        [connectedDevice addObject:peripheral];
        [self.tableview reloadData];
    }
    
    peripheral.delegate = self;
    
    NSLog(@"搜索服务");
    [peripheral discoverServices:@[[CBUUID UUIDWithString:@"FFE5"],[CBUUID UUIDWithString:WRITE_SERVICE_UUID_OTHER]]];
//    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
    NSLog(@"-----------断开");
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
    NSLog(@"-----------重新连接");
    
    

}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"-----occur some error");
    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"connect alert" message:@"" delegate:self cancelButtonTitle:@"dismiss" otherButtonTitles:nil, nil];
//    [alert show];
    
    
    
    
    
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
        NSLog(@"=========== %l of service for UUID %@ ===========\n",peripheral.services.count,peripheral.identifier.UUIDString);
        
        //一个外围设备含有多个服务通道，每个通道下面有多个特征，下一个通过服务通道寻找特征传输通道
        for (CBService *p in peripheral.services)
        {
            NSLog(@"Service found with UUID: %@\n", p.UUID);
            
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
        NSLog(@"Service discovery was unsuccessfull !\n");
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error

{
    
//    CBService *s = [peripheral.services objectAtIndex:(peripheral.services.count - 1)];
    
    if (!error) {
//        NSLog(@"=========== %d Characteristics of service ",service.characteristics.count);
//        NSLog(@"==========service:%@",service);
        NSLog(@"--------发现服务--------");
        for(CBCharacteristic *c in service.characteristics)
        {
            
            NSLog(@"cbcharacteristic =%@",c);
            
            
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
        NSLog(@"===服务添加成功===\n");
        
        
    }
    else {
        NSLog(@"Characteristic discorvery unsuccessfull !\n");
        
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
        NSLog(@"=======%@",error.userInfo);
    }else{
        
        NSLog(@"发送数据成功");
    }
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
