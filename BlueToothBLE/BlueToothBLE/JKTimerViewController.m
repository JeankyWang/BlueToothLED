//
//  JKTimerViewController.m
//  BlueToothBLE
//
//  Created by wzq on 15/11/18.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKTimerViewController.h"
#import "JKDefineMenuView.h"
#import "JKColorPicker.h"
#import "NSDate+SeparateColumn.h"
#import "JKSendDataTool.h"
#import "SVProgressHUD.h"


#define TIMER_ON 1
#define TIMER_OFF 0

@interface JKTimerViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *myTableView;
    JKDefineMenuView *bottomMenu;
    //#cb83ff
    UIAlertView *timeAlert;
    UIDatePicker *datePicker;
    NSInteger index;
//    NSDate *openDate;
//    NSDate *closeDate;
    
    NSMutableDictionary *timerDict;
}
@end

@implementation JKTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定时";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg"]];
    [self setupUI];
}

- (void)setupUI
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close_nav"] style:UIBarButtonItemStyleBordered target:self action:@selector(dismissSelf)];
    self.navigationItem.leftBarButtonItem = item;
    
    myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    
    UIButton *footer = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, FullScreen_width, 50)];
    [footer setTitleColor:[UIColor colorWithHexString:@"ff446a"] forState:UIControlStateNormal];
    [footer setTitle:@"  断电后定时信息失效，请重新设置" forState:UIControlStateNormal];
    [footer setImage:[UIImage imageNamed:@"warn"] forState:UIControlStateNormal];
    footer.titleLabel.font = Font(14);
    myTableView.tableFooterView = footer;
    
    
    //底部弹出色盘
//    bottomMenu = [[JKDefineMenuView alloc] initWithFrame:CGRectMake(0, FullScreen_height - 270, FullScreen_width, 270) inView:self.view];
//    bottomMenu.style = JKDefineMenuViewBottom;
//    bottomMenu.backgroundColor = [UIColor colorWithWhite:0 alpha:.1];
//    
//    JKColorPicker *colorPicker = [[JKColorPicker alloc] initWithFrame:CGRectMake(0, 0, 182, 182)];
//    colorPicker.center = CGPointMake(CGRectGetWidth(bottomMenu.frame)/2, CGRectGetHeight(bottomMenu.frame)/2-20);
//    [colorPicker addTarget:self action:@selector(chooseColor:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomMenu addSubview:colorPicker];
    
    timeAlert  = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.date = [NSDate date];
    
    [timeAlert setValue:datePicker forKey:@"accessoryView"];
    
    
    
}

- (void)dismissSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)chooseColor:(JKColorPicker *)picker
{

}

- (void)showBottomMenu:(UIButton *)button
{
    //判断是那个模式
    
    [bottomMenu showMenu];
}

- (void)hideBottomMenu
{
    [bottomMenu dismissMenu];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
//        if (index == 0) {
//            openDate = datePicker.date;
//        } else {
//            closeDate = datePicker.date;
//        }
        [self selectedHour:datePicker.date];
        [myTableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell_id"];
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:.23];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIView *lightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FullScreen_width/3, 100)];
    lightView.backgroundColor = [UIColor colorWithHexString:@"33233d"];
    
    UIImageView *lightImg = [[UIImageView alloc] initWithFrame:CGRectMake(FullScreen_width/6-25, 25, 50, 50)];
    lightImg.image = [UIImage imageNamed:@"timer_light"];
    lightImg.backgroundColor = [UIColor whiteColor];
    [lightView addSubview:lightImg];
    
    [cell.contentView addSubview:lightView];

    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lightView.frame), 0, FullScreen_width/2, 60)];
    timeLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:50];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:timeLabel];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(timeLabel.frame) + 10, CGRectGetMaxY(timeLabel.frame), FullScreen_width/3, 20)];
    typeLabel.font = Font(14);
    typeLabel.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:typeLabel];
    
    switch (indexPath.section) {
        case 0:
            if (_currentScene.openTime) {
                timeLabel.text = [_currentScene.openTime stringWithFormat:@"hh:mm"];
            } else {
                timeLabel.text = @"--:--";
            }
            
            typeLabel.text = @"开灯";
            break;
        case 1:
            
            if (_currentScene.closeTime) {
                timeLabel.text = [_currentScene.closeTime stringWithFormat:@"hh:mm"];
            } else {
                timeLabel.text = @"--:--";
            }

            typeLabel.text = @"关灯";
            break;
        default:
            break;
    }
    
    
    UISwitch *switcher = [[UISwitch alloc] initWithFrame:CGRectMake(FullScreen_width - 60, 35, 60, 30)];
    switcher.onTintColor = [UIColor colorWithHexString:@"5d4965"];
    if (indexPath.row == 0) {
        [switcher setOn:_currentScene.isOpenSet];
    } else {
        [switcher setOn:_currentScene.isCloseSet];
    }
    switcher.tag = indexPath.section;
    [switcher addTarget:self action:@selector(openOrCloseTimer:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:switcher];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    index = indexPath.section;
    [timeAlert show];
}

- (int)getNextDay:(int)interval
{
    interval += 24*60*60;
    
    if (interval < 0) {
       return [self getNextDay:interval];
    } else {
        return interval;
    }
}

- (void)openOrCloseTimer:(UISwitch *)switcher
{
    
    NSDate *date = nil;
    if (switcher.tag == 0) {
        _currentScene.isOpenSet = switcher.isOn;
        date = _currentScene.openTime;
    } else {
        _currentScene.isCloseSet = switcher.isOn;
        date = _currentScene.closeTime;
    }
    
    if (!date) {
        [SVProgressHUD showInfoWithStatus:@"请先选择时间"];
        return;
    }
    
    // 打开定时关 需要把具体时间也发送过去
    //interval 得到秒数
    
    
    int interval = (date.timeIntervalSince1970 - (int)date.timeIntervalSince1970 % 60 - [NSDate date].timeIntervalSince1970);
    if(interval <= 0) interval = [self getNextDay:interval];
    
    
    int min = interval/60;
    int sec = interval%60;
    
    
    
    Byte hight = min >> 8;
    Byte low = min;
    NSLog(@"hight:%d low:%d",hight,low);
    
    switch (switcher.tag)
    {
        case 0:
            if (switcher.isOn) {
                //打开定时开 需要把具体时间也发送过去
                [self sendTimer:YES high:hight low:low onOff:TIMER_ON mode:21 second:sec];
                DLog(@"开灯开");
            }else{
                
                [self sendTimer:NO high:0 low:0 onOff:TIMER_ON mode:21 second:0];
                DLog(@"开灯关");

            }
            
            break;
        case 1:
            if (switcher.isOn) {
                [self sendTimer:YES high:hight low:low onOff:TIMER_OFF mode:1 second:sec];
                DLog(@"关灯开");

            }
            else
            {
                [self sendTimer:NO high:0 low:0 onOff:TIMER_OFF mode:0 second:0];
                DLog(@"关灯关");

            }
            break;
            
        default:
            break;
    }

}


#pragma  mark - time picker delegate
- (void) selectedHour:(NSDate *)date
{

    
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
    
    switch (index)
    {
        case 0:
        {
//            openDate = date;
            _currentScene.openTime = date;
            
            //发送定时指令
            [self sendTimer:_currentScene.isOpenSet high:hight low:low onOff:TIMER_ON mode:21 second:sec];
           
        }
            break;
        case 1:
            
//            closeDate = date;
            _currentScene.closeTime = date;
            [self sendTimer:YES high:hight low:low onOff:TIMER_OFF mode:0 second:sec];
            
            break;
            
        default:
            break;
    }
    
    
}

- (void)sendTimer:(Byte)timerOnOff high:(Byte)high low:(Byte)low onOff:(Byte)onoff mode:(Byte)mode second:(Byte)sec
{
    [[NSNotificationCenter defaultCenter] postNotificationName:JKSaveScenesNotification object:nil];
    [SVProgressHUD showSuccessWithStatus:@"设置完成"];
    Byte data[] = {0xfe,timerOnOff,0x0d,high,low,onoff,mode,sec,0xef};
    DLog(@"send date %s",data);
    NSData *b_data = [NSData dataWithBytes:&data length:sizeof(data)];
    [[JKSendDataTool shareInstance] sendCMD:b_data devices:_deviceArray];
}




@end
