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

@interface JKTimerViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *myTableView;
    JKDefineMenuView *bottomMenu;
    //#cb83ff
    UIAlertView *timeAlert;
    UIDatePicker *datePicker;
    NSInteger index;
    NSDate *openDate;
    NSDate *closeDate;
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
    bottomMenu = [[JKDefineMenuView alloc] initWithFrame:CGRectMake(0, FullScreen_height - 270, FullScreen_width, 270) inView:self.view];
    bottomMenu.style = JKDefineMenuViewBottom;
    bottomMenu.backgroundColor = [UIColor colorWithWhite:0 alpha:.1];
    
    JKColorPicker *colorPicker = [[JKColorPicker alloc] initWithFrame:CGRectMake(0, 0, 182, 182)];
    colorPicker.center = CGPointMake(CGRectGetWidth(bottomMenu.frame)/2, CGRectGetHeight(bottomMenu.frame)/2-20);
    [colorPicker addTarget:self action:@selector(chooseColor:) forControlEvents:UIControlEventTouchUpInside];
    [bottomMenu addSubview:colorPicker];
    
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
        if (index == 0) {
            openDate = datePicker.date;
        } else {
            closeDate = datePicker.date;
        }
        
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
    
    UIButton *lightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    lightBtn.tag = indexPath.section;
    [lightBtn addTarget:self action:@selector(showBottomMenu:) forControlEvents:UIControlEventTouchUpInside];
    [lightView addSubview:lightBtn];
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
            timeLabel.text = [openDate stringWithFormat:@"hh:mm"];
            typeLabel.text = @"开灯";
            break;
        case 1:
            timeLabel.text = [closeDate stringWithFormat:@"hh:mm"];
            typeLabel.text = @"关灯";
            break;
        default:
            break;
    }
    
    
    UISwitch *switcher = [[UISwitch alloc] initWithFrame:CGRectMake(FullScreen_width - 60, 35, 60, 30)];
    switcher.onTintColor = [UIColor colorWithHexString:@"5d4965"];
    switcher.tag = indexPath.section;
    [cell.contentView addSubview:switcher];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    index = indexPath.section;
    [timeAlert show];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
