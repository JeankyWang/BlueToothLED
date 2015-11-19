//
//  JKNewScenceController.m
//  BlueToothBLE
//
//  Created by wzq on 15/11/13.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKNewScenceController.h"

@interface JKNewScenceController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UIImagePickerController *myImagePicker;
    UIActionSheet *takePicSheet;
    UIAlertView *nameAlert;
}
@end

@implementation JKNewScenceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.title = @"添加新的场景";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_bg"]];

    myImagePicker = [[UIImagePickerController alloc] init];
    myImagePicker.delegate = self;
    
    takePicSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    
    nameAlert = [[UIAlertView alloc] initWithTitle:@"输入新场景名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    nameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [nameAlert textFieldAtIndex:0].placeholder = @"新场景名称";
    [nameAlert textFieldAtIndex:0].clearButtonMode = UITextFieldViewModeWhileEditing;
    
}



- (void)doneAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)showImagePicker
{
    [self presentViewController:myImagePicker animated:YES completion:nil];
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

    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_id"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.23];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"场景照片";
    } else {
        cell.textLabel.text = @"名称";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [takePicSheet showInView:self.view];
    } else {
        [nameAlert show];
    }
}

#pragma mark -action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        myImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self showImagePicker];
    } else if (buttonIndex == 1) {
        myImagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self showImagePicker];
    }
}

#pragma  mark -image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
