//
//  JKScenesTableViewController.m
//  BlueToothBLE
//
//  Created by wzq on 15/11/5.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKScenesTableViewController.h"
#import "JKNewScenceController.h"

@interface JKScenesTableViewController ()
{
    NSArray *sceneImgArray;
    NSArray *sceneNameArray;
}
@end

@implementation JKScenesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    self.title = @"添加场景";
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_bg"]];
    [self setupData];
}

- (void)setupData
{
    sceneImgArray = @[@"scene_bedroom",@"scene_living",@"scene_wash",@"scene_kitchen",@"scene_dining",@"scene_office",@"scene_book",@"scene_entertenment",@"scene_sport"];
    sceneNameArray =@[@"卧室",@"客厅",@"洗手间",@"厨房",@"餐厅",@"办公",@"书房",@"娱乐",@"运动"];
}

- (void)doneAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 1) {
        return 1;
    }
    return sceneNameArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_id"];
        cell.tintColor = [UIColor colorWithHexString:@"66cc99"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.07];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = sceneNameArray[indexPath.row];
        
        UIGraphicsBeginImageContext(CGSizeMake(50, 50));
        UIImage *img = [UIImage imageNamed:sceneImgArray[indexPath.row]];
        [img drawInRect:CGRectMake(0, 0, 50, 50)];
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        cell.imageView.image = img;
        cell.imageView.layer.masksToBounds = YES;
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uncheck_icon"]];

    } else {
        cell.textLabel.text = @"添加新场景";
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];

    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked_icon"]];
    } else {
    
        JKNewScenceController *vc = [[JKNewScenceController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uncheck_icon"]];    }
    

}


@end
