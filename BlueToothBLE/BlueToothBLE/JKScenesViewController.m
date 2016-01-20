//
//  JKScenesViewController.m
//  BlueToothBLE
//
//  Created by wzq on 15/11/5.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKScenesViewController.h"
#import "JKSceneViewCell.h"
#import "JKSceneModel.h"
#import "JKSaveSceneTool.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "JKScenesTableViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "JKBLEsManager.h"
#import "JKBLEsTableViewController.h"
#import "JKControlViewController.h"



@interface JKScenesViewController ()<UICollectionViewDelegateFlowLayout,JKScenesSelectDelegate,UIActionSheetDelegate>
{
    NSMutableArray *sceneArray;
    ALAssetsLibrary *assetLib;
    
    UIActionSheet *chooseSheet;
    BOOL isEditing;
    
    JKSceneModel *currentScene;
}
@end

@implementation JKScenesViewController

static NSString * const reuseIdentifier = @"scene_cell_id";

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.title = @"场景";
//    self.collectionView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_bg"]];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg"]];
    [self setupLayout];
    
//    UIImage *newImage = [[UIImage imageNamed:@"tab_scene_un"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIImage *newSelectedImage = [[UIImage imageNamed:@"tab_scene"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
//    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor yellowColor]} forState:UIControlStateNormal];
//    self.tabBarItem.image = newImage;
//    self.tabBarItem.selectedImage = newSelectedImage;
    
    chooseSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"控制",@"添加设备", nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveScene) name:JKSaveScenesNotification object:nil];
    

    [self setupData];
}

- (void)setupData
{
    sceneArray = [[JKSaveSceneTool sharedInstance] unarchiveBrandsIconWithKey:@"myScenes"];
    assetLib = [[ALAssetsLibrary alloc] init];
}

- (void)saveScene
{
    [[JKSaveSceneTool sharedInstance] archiveScene:sceneArray withKey:@"myScenes"];
}

- (void)setupLayout
{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((FullScreen_width/2)-2 , 190*PhoneScale);
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 5;
    self.collectionView.collectionViewLayout = layout;
    
}

- (void)deleteScene:(UIButton *)button
{
    [sceneArray removeObjectAtIndex:button.tag];
//    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:button.tag inSection:0]]];
    [self saveScene];
    [self.collectionView reloadData];
}

- (void)onOffLight:(UIButton *)button
{
    button.selected = !button.selected;
    BOOL isOn = button.selected;
    Byte dataOFF[9] = {0x7e,0x04,0x04,isOn,0x00,0xff,0xff,0x0,0xef};
    NSData *data = [[NSData alloc]initWithBytes:dataOFF length:9];

    
    
    JKSceneModel *scene = sceneArray[button.tag];
    
    if (!scene.devices) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"本场景暂无添加蓝牙设备" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    for (CBPeripheral *per in [JKBLEsManager sharedInstance].allBLEArray) {
        if ([scene.devices containsObject:per.name]) {
            [per writeValue:data forCharacteristic:[JKBLEsManager sharedInstance].writeCharacter type:CBCharacteristicWriteWithoutResponse];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return sceneArray.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 0, 0);
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 5;
//}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JKSceneViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    JKSceneModel *scene = sceneArray[indexPath.item];
    UIImage *img = [UIImage imageNamed:scene.imgName];
    
    cell.delBtn.hidden = !isEditing;
    cell.delBtn.tag = indexPath.item;
    cell.lightBtn.tag = indexPath.item;
    cell.backgroundColor = [UIColor grayColor];
    [cell.delBtn addTarget:self action:@selector(deleteScene:) forControlEvents:UIControlEventTouchUpInside];
    [cell.lightBtn addTarget:self action:@selector(onOffLight:) forControlEvents:UIControlEventTouchUpInside];
    
    if (img) {
        cell.themeImg.image = img;
    } else {
        [assetLib assetForURL:[NSURL URLWithString:scene.imgName] resultBlock:^(ALAsset *asset) {
            
            cell.themeImg.image = [UIImage imageWithCGImage:[asset thumbnail]];//[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
        } failureBlock:^(NSError *error) {
            
        }];

    }
    
    
    cell.nameLabel.text = scene.name;
    
    cell.themeImg.layer.masksToBounds = YES;

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    currentScene = sceneArray[indexPath.item];
    [chooseSheet showInView:self.view];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JKSceneModel *scene = sceneArray[indexPath.item];
    DLog(@"取消选中%@",scene);
    
}

#pragma mark -action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DLog(@"index : %d",(int)buttonIndex);
    if (buttonIndex == 0) {
        [self enterControlView];
    } else if(buttonIndex == 1) {//添加蓝牙设备
        JKBLEsTableViewController *vc = [[JKBLEsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.scene = currentScene;
        [self.navigationController pushViewController:vc animated:YES];

    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"JKScenesTableViewController"]) {
        JKScenesTableViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}

- (void)addScenes:(NSArray *)scenes
{
    if (!sceneArray) {
        sceneArray = [NSMutableArray array];
    }
    
    [sceneArray addObjectsFromArray:scenes];
    [self saveScene];
    [self.collectionView reloadData];
}

#pragma -mark 切换编辑标题
- (IBAction)editScene:(UIBarButtonItem *)sender {
    
    isEditing = !isEditing;
    if(isEditing) sender.title = @"取消";
    else sender.title = @"编辑";
    [self.collectionView reloadData];
}

#pragma mark - 进入控制界面
- (void)enterControlView
{
    
    
    JKControlViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"JKControlViewController"];
    vc.deviceArray = [self getPerArrayFromScene:currentScene];
    vc.writeCharacter = [JKBLEsManager sharedInstance].writeCharacter;
    vc.currentScene = currentScene;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (NSArray *)getPerArrayFromScene:(JKSceneModel *)scene
{
    NSMutableArray *tmp = [NSMutableArray array];
    for (CBPeripheral *per in [JKBLEsManager sharedInstance].allBLEArray) {
        if ([scene.devices containsObject:per.name]) {
            [tmp addObject:per];
        }
    }
    return tmp;
}

@end
