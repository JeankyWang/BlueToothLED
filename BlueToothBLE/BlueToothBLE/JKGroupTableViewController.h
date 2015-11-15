//
//  JKGroupTableViewController.h
//  fancyColor-BLE
//
//  Created by wzq on 14/8/16.
//  Copyright (c) 2014年 wzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreBluetooth/CoreBluetooth.h"
#import "JKBLEServicAndCharacter.h"



@interface JKGroupTableViewController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *peripheralArray;//全部的周边设备

@property (strong, nonatomic) CBCentralManager *cbCentralMgr;

@end
