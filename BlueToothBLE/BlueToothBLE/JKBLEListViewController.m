//
//  JKBLEListViewController.m
//  fancyColor-BLE
//
//  Created by wzq on 14/8/16.
//  Copyright (c) 2014年 wzq. All rights reserved.
//

#import "JKBLEListViewController.h"
#import "SVProgressHUD.h"


@interface JKBLEListViewController ()
{
    CBPeripheral *selectedPer;
}
@end

@implementation JKBLEListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IOS7) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }


    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController.toolbar setHidden:YES];
    self.title = NSLocalizedString(@"Device List", @"");
    
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];

    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    
    [self.view addSubview:self.tableview];
    CGRect frame = CGRectMake(30, 0, SCREEN_WIDTH-60, 44);
    UIButton *unlock = [[UIButton alloc]initWithFrame:frame];
    [unlock setTitle:NSLocalizedString(@"Unbind", @"") forState:UIControlStateNormal];
    unlock.backgroundColor = [UIColor redColor];
    [unlock setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [unlock addTarget:self action:@selector(unbindDevice) forControlEvents:UIControlEventTouchUpInside];
    unlock.layer.cornerRadius = 5;


    self.tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [self.tableview.tableFooterView addSubview:unlock];

    
    [self.navigationController.toolbar setHidden:YES];


    
}

- (void)unbindDevice
{
    [self.delegate unbindByRow:_rowNum];
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Done", @"")];
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark -tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_perArray.count == 0)
    {
        return  _selectedDevices.count;
    }
    return _perArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

    }
    
    if (_perArray.count == 0)
    {
        cell.textLabel.text = [_selectedDevices objectAtIndex:indexPath.row];
    }
    else
    {
    
        CBPeripheral *per = [_perArray objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = (per.name) == nil ? @"Unamed" : per.name;
        
        cell.textLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:per.identifier.UUIDString];
        cell.textLabel.font = [UIFont systemFontOfSize:20];
    
        if ([_selectedDevices containsObject:per.identifier.UUIDString])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    
        //判断连接状态设置颜色
        if (per.state == CBPeripheralStateConnected)
        {
            cell.textLabel.textColor = [UIColor greenColor];
            cell.imageView.image = [UIImage imageNamed:@"bluetooth_blue.png"];
            NSLog(@"per.rssi%@",per.RSSI);
        }
        else
        {
            cell.textLabel.textColor = [UIColor grayColor];
            cell.imageView.image = [UIImage imageNamed:@"bluetooth_gray.png"];
            NSLog(@"per.rssi%@",per.RSSI);
        }
    }

   return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
     selectedPer = [_perArray objectAtIndex:indexPath.row];
    

    
    [self showAlert:indexPath];
   
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

#pragma mark -sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [_delegate selectBLE:selectedPer groupNo:_rowNum];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
            [self changeName:selectedPer];
            break;
            
        default:
            break;
    }
}

#pragma  mark - alert delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *name = [alertView textFieldAtIndex:0].text;
    NSString *perUUID = selectedPer.identifier.UUIDString;
    
    if (name == nil || [name isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"noName"];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:perUUID];
    [self.tableview reloadData];
    
    
}

-(void)changeName:(CBPeripheral *)per
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"newName", @"")
                                                   message:@""
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                         otherButtonTitles:NSLocalizedString(@"Confirm", @""), nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *groupFiled = [alert textFieldAtIndex:0];
    groupFiled.placeholder = NSLocalizedString(@"newName", @"");
    
    [alert show];

}



- (void)showAlert:(NSIndexPath *)indexPath
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"add2Group", @""),NSLocalizedString(@"changeName", @""), nil];
    [sheet showInView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
