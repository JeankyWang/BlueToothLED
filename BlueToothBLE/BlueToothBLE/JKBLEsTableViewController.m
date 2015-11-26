//
//  JKBLEsTableViewController.m
//  BlueToothBLE
//
//  Created by wzq on 15/11/24.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKBLEsTableViewController.h"
#import "JKBLEsManager.h"

@interface JKBLEsTableViewController ()

@end

@implementation JKBLEsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"所有设备";
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_bg"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [JKBLEsManager sharedInstance].allBLEArray.count;
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
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:.23];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tintColor = [UIColor whiteColor];
    }
    
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    CBPeripheral *peripheral = [JKBLEsManager sharedInstance].allBLEArray[indexPath.row];
    
    
    
    
    if (peripheral.state == CBPeripheralStateConnected)
    {
        cell.textLabel.textColor = BLE_Theme_Color;
        cell.detailTextLabel.textColor = BLE_Theme_Color;
        cell.detailTextLabel.text = @"已连接";
    } else {
        cell.textLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.text = @"未连接";
    }
    
    if ([_scene.devices containsObject:peripheral.name]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSString *rename = [[NSUserDefaults standardUserDefaults] objectForKey:peripheral.name];
    
    if (!rename){
        cell.textLabel.text = peripheral.name;
    } else {
        cell.textLabel.text = rename;
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBPeripheral *peripheral = [JKBLEsManager sharedInstance].allBLEArray[indexPath.row];
    [_scene.devices addObject:peripheral.name];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
