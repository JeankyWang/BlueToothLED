//
//  JKNewScenceController.m
//  BlueToothBLE
//
//  Created by wzq on 15/11/13.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKNewScenceController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface JKNewScenceController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    UIImagePickerController *myImagePicker;
    UIActionSheet *takePicSheet;
    UIAlertView *nameAlert;
    JKSceneModel *newScene;
    
    ALAssetsLibrary *assetLib;
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
    myImagePicker.allowsEditing = YES;
    
    
    takePicSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    
    nameAlert = [[UIAlertView alloc] initWithTitle:@"输入新场景名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    nameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [nameAlert textFieldAtIndex:0].placeholder = @"新场景名称";
    [nameAlert textFieldAtIndex:0].clearButtonMode = UITextFieldViewModeWhileEditing;
    
    newScene = [[JKSceneModel alloc] init];
    assetLib = [[ALAssetsLibrary alloc] init];
}



- (void)doneAction
{
    
    if ([_delegate respondsToSelector:@selector(addNewScene:)]) {
        [_delegate addNewScene:newScene];
    }
    
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell_id"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.23];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"场景照片";
        
        [assetLib assetForURL:[NSURL URLWithString:newScene.imgName] resultBlock:^(ALAsset *asset) {
            UIImage *img = [UIImage imageWithCGImage:[asset thumbnail]];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
            imgView.frame = CGRectMake(0, 0, 50, 50);
            cell.accessoryView = imgView;
            
        } failureBlock:^(NSError *error) {
            
        }];
        
        
        cell.detailTextLabel.text = nil;

        
        
    } else {
        cell.textLabel.text = @"名称";
        cell.detailTextLabel.text = newScene.name;
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        newScene.name = textField.text;
        [self.tableView reloadData];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName,nil]];
    viewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg"]];
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
    //存入本地
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];

    if (myImagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [assetLib writeImageToSavedPhotosAlbum:image.CGImage metadata:info[UIImagePickerControllerMediaMetadata] completionBlock:^(NSURL *assetURL, NSError *error) {
            newScene.imgName = assetURL.absoluteString;
        }];
    } else {
        newScene.imgName = ((NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL]).absoluteString;
    }
    
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
