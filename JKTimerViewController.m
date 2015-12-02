//
//  JKTimerViewController.m
//  fancyColor-BLE
//
//  Created by wzq on 14/8/19.
//  Copyright (c) 2014年 wzq. All rights reserved.
//

#import "JKTimerViewController.h"
#import "JKRGBTabBarViewController.h"
#import "JKBLEManager.h"
#import "JKBLEServicAndCharacter.h"
#import "SVProgressHUD.h"

#define kTurn_On_time @"_TURNONTIME_"
#define kTurn_Off_time @"_TURNOFFTIME_"
#define kTurn_On_status @"kTurn_On_status"
#define kTurn_Off_status @"kTurn_Off_status"
#define kTurn_On_mode @"kTurn_on_mode"
#define ON 1
#define OFF 0
#define TIMER_ON 1
#define TIMER_OFF 0

#define kTimer @"K_TIMER"

@interface JKTimerViewController ()
{
    NSString *turnOnTime;
    NSString *turnOffTime;
    NSString *sltScene;
    NSMutableDictionary *timerDict;
    NSMutableArray *ipArray;
    
    NSDate *onDate;
    NSDate *offDate;
    NSArray *modeArr;
    
    //蓝牙设备
    NSMutableArray *bleDevices;
    NSMutableArray *localCharacter;
    NSMutableArray *currentDevice;
}
@end

@implementation JKTimerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sltScene = [NSString stringWithFormat:@"%@_%@",((JKRGBTabBarViewController *)self.tabBarController).selectedSceneName,kTimer];
    self.view.backgroundColor = RGB(99, 168, 224);
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    img.frame = self.view.bounds;
    [self.view addSubview:img];
    
    [self.view bringSubviewToFront:self.cancelBtn];
    [self.view bringSubviewToFront:self.tableview];
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.tableFooterView = [UIView new];
    self.tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    //获取相应的组别下的定时开关的数据
    NSDictionary *timerDictTemp = [[NSUserDefaults standardUserDefaults] objectForKey:sltScene];
    timerDict = [NSMutableDictionary dictionaryWithDictionary:timerDictTemp];
    
    turnOnTime = [timerDict objectForKey:kTurn_On_time];
    turnOffTime = [timerDict objectForKey:kTurn_Off_time];

    modeArr = @[
             NSLocalizedString(@"Static red", @""),
             NSLocalizedString(@"Static blue", @""),
             NSLocalizedString(@"Static green", @""),
             NSLocalizedString(@"Static cyan", @""),
             NSLocalizedString(@"Static yellow", @""),
             NSLocalizedString(@"Static purple", @""),
             NSLocalizedString(@"Static white", @""),
             NSLocalizedString(@"Tricolor jump", @""),
             NSLocalizedString(@"Seven-color jump", @""),
             NSLocalizedString(@"Tricolor gradient", @""),
             NSLocalizedString(@"Seven-color gradient", @""),
             NSLocalizedString(@"Warm 0% Cold 100%", @""),
             NSLocalizedString(@"Warm 10% Cold 90%", @""),
             NSLocalizedString(@"Warm 20% Cold 80%", @""),
             NSLocalizedString(@"Warm 30% Cold 70%", @""),
             NSLocalizedString(@"Warm 40% Cold 60%", @""),
             NSLocalizedString(@"Warm 50% Cold 50%", @""),
             NSLocalizedString(@"Warm 60% Cold 40%", @""),
             NSLocalizedString(@"Warm 70% Cold 30%", @""),
             NSLocalizedString(@"Warm 80% Cold 20%", @""),
             NSLocalizedString(@"Warm 90% Cold 10%", @""),
             NSLocalizedString(@"Warm 100% Cold 0%", @"")
             ];
    
    
    bleDevices = ((JKRGBTabBarViewController *)self.tabBarController).pers;//uuid 集合
    localCharacter = [JKBLEManager shareInstance].writeCharacteristic;      //有效特征值
    
    currentDevice = [NSMutableArray new];
    
    //初始化数据，从uuid获得相应的设备通道和特征值
    for (NSString *str in bleDevices)
    {
        for (JKBLEServicAndCharacter *obj in [JKBLEManager shareInstance].writeCharacteristic)
        {
            if ([obj.bleDevice.identifier.UUIDString isEqualToString:str] && ![currentDevice containsObject:obj])
            {
                [currentDevice addObject:obj];
            }
        }
    }

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.numberOfLines = 0;
    label.text = NSLocalizedString(@"timerWarn", @"");
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    self.tableview.tableFooterView = label;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.navigationController.toolbar setHidden:YES];
    [self.tabBarController.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)sendCMD:(NSData*)data
{
    for (JKBLEServicAndCharacter *obj in currentDevice) {
        [obj.bleDevice writeValue:data forCharacteristic:obj.character type:CBCharacteristicWriteWithoutResponse];
    }

    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Done", @"")];
}


- (void)sendTimer:(Byte)timerOnOff high:(Byte)high low:(Byte)low onOff:(Byte)onoff mode:(Byte)mode second:(Byte)sec
{
    Byte data[] = {0x7e,timerOnOff,0x0d,high,low,onoff,mode,sec,0xef};
    NSData *b_data = [NSData dataWithBytes:&data length:sizeof(data)];
    [self sendCMD:b_data];
}



#pragma mark -tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }

    cell.textLabel.font = [UIFont systemFontOfSize:48];
    
    //
    UISwitch *onoff = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 20, 80, 30)];
    onoff.tag = indexPath.row;
    [onoff addTarget:self action:@selector(openTimer:) forControlEvents:UIControlEventValueChanged];
    onoff.onTintColor = RGB(63, 186, 240);
    cell.accessoryView = onoff;

    switch (indexPath.row) {
        case 0:
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"timerOn", @""), [timerDict objectForKey:kTurn_On_mode]==nil? @"":[modeArr objectAtIndex:((NSString *)[timerDict objectForKey:kTurn_On_mode]).intValue]];
            
            if (turnOnTime) {
                cell.textLabel.text = turnOnTime;
            }
            else
            {
                cell.textLabel.text = @"00:00";
            }
            
            BOOL isOn = ((NSString *)[timerDict objectForKey:kTurn_On_status]).boolValue;
            
            [onoff setOn:isOn];
            
            

            
            
            
            
        }
            
            break;
        case 1:
            cell.detailTextLabel.text = NSLocalizedString(@"timerOff", @"");
            if (turnOffTime) {
                cell.textLabel.text = turnOffTime;
            }
            else
            {
                cell.textLabel.text = @"00:00";
            }
            
            [onoff setOn:((NSString *)[timerDict objectForKey:kTurn_Off_status]).boolValue];
            break;
            
        default:
            break;
    }
    
    
    
    
    

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    BOOL isOn = ((UISwitch *)cell.accessoryView).isOn;
//    JKTimePickerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"JKTimePickerViewController"];
//    [self.navigationController pushViewController:vc animated:YES];
    [self showTimePicker:indexPath];
    
}

//开启定时器开关
- (void)openTimer:(UISwitch *)switcher
{
    
    // 打开定时关 需要把具体时间也发送过去
    //interval 得到秒数
    int interval = (onDate.timeIntervalSince1970 - (int)onDate.timeIntervalSince1970 % 60 - [NSDate date].timeIntervalSince1970);
    if(interval <= 0) interval += 24*60*60;
    int min = interval/60;
    int sec = interval%60;
    
   
    
    Byte hight = min >> 8;
    Byte low = min;
    NSLog(@"hight:%d low:%d",hight,low);
    
    switch (switcher.tag)
    {
        case 0:
            [timerDict setObject:@(switcher.isOn) forKey:kTurn_On_status];
            Byte mode = ((NSString *)[timerDict objectForKey:kTurn_On_mode]).intValue;
            
            [[NSUserDefaults standardUserDefaults] setObject:timerDict forKey:sltScene];
            
            if (switcher.isOn) {
                //打开定时开 需要把具体时间也发送过去
               
                
                [self sendTimer:ON high:hight low:low onOff:TIMER_ON mode:mode second:sec];
                
            }else{
            
                [self sendTimer:OFF high:0 low:0 onOff:TIMER_ON mode:0 second:0];
            }
            
            break;
        case 1:
            [timerDict setObject:@(switcher.isOn) forKey:kTurn_Off_status];
            [[NSUserDefaults standardUserDefaults] setObject:timerDict forKey:sltScene];
            
            if (switcher.isOn) {
                
                
                [self sendTimer:ON high:hight low:low onOff:TIMER_OFF mode:1 second:sec];
                
            }
            else
            {
                [self sendTimer:OFF high:0 low:0 onOff:TIMER_OFF mode:0 second:0];
            }
            break;
            
        default:
            break;
    }

}

- (void)showTimePicker:(NSIndexPath *)indexPath
{
    JKTimePickerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"JKTimePickerViewController"];
    vc.delegate = self;
    vc.index = indexPath;
    vc.modeRow = ((NSString *)[timerDict objectForKey:kTurn_On_mode]).intValue;
    [self presentViewController:vc animated:YES completion:nil];


}

//- (void)timeChange:(UIDatePicker*)picker
//{
//    NSDate *time = picker.date;
//    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
//    [fmt setDateFormat:@"HH:mm"];
//    
//    NSString *dateString = [fmt stringFromDate:time];
//   
//    
//    switch (picker.tag)
//    {
//        case 0:
//            turnOnTime = dateString;
//            [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:kTurn_On_time];
//            break;
//        case 1:
//            turnOffTime = dateString;
//            [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:kTurn_Off_time];
//            break;
//            
//        default:
//            break;
//    }
//    
//    
//    [self.tableview reloadData];
//}


#pragma  mark - time picker delegate
- (void) selectedHour:(NSDate *)date dateStr:(NSString*)dateString  andMode:(int)mode withIndexPath:(NSIndexPath *)index
{
    NSLog(@"date:%@, dateStr:%@ ,mode:%d, index:%@",date,dateString,mode,index);
    
    UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:index];
    cell.textLabel.text = dateString;
    BOOL isOn = ((UISwitch *)cell.accessoryView).isOn;
    
    NSLog(@"seleced scene name:%@",sltScene);
    if (!timerDict) {
        timerDict = [NSMutableDictionary new];
    }
    
    NSDate *now = [NSDate date];
    int interval = (date.timeIntervalSince1970 - (int)date.timeIntervalSince1970 % 60 - now.timeIntervalSince1970);
    
    
    if(interval <= 0) interval += 24*60*60;
    int min = interval / 60;
    int sec = interval % 60;
    Byte hight = min >> 8;
    Byte low = min;
    
    switch (index.row)
    {
        case 0:
        {
            turnOnTime = dateString;
            onDate = date;
            [timerDict setObject:turnOnTime forKey:kTurn_On_time];
            [timerDict setObject:@(mode) forKey:kTurn_On_mode];
            
            //保存
            [[NSUserDefaults standardUserDefaults] setObject:timerDict forKey:sltScene];
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@",NSLocalizedString(@"timerOn", @""),[modeArr objectAtIndex:mode]];
            
            //计算定时间隔,分钟为单位,两个字节高低位
            
            if (isOn) {
                //发送定时指令
                [self sendTimer:ON high:hight low:low onOff:TIMER_ON mode:mode second:sec];
            }else{
                
            }
            
        }
            break;
        case 1:
            turnOffTime = dateString;
            offDate = date;
            [timerDict setObject:turnOffTime forKey:kTurn_Off_time];
            
            [[NSUserDefaults standardUserDefaults] setObject:timerDict forKey:sltScene];
            
            if (isOn) {
                //发送定时关指令
                [self sendTimer:ON high:hight low:low onOff:TIMER_OFF mode:0 second:sec];
            }
            else
            {
            
            }

            break;
            
        default:
            break;
    }

    
}

#pragma mark - action sheetdelegate 

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    

    
}


- (IBAction)dismissVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
