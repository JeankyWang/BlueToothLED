//
//  JKScenesTableViewController.m
//  BlueToothBLE
//
//  Created by wzq on 15/11/5.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKScenesTableViewController.h"
#import "JKNewScenceController.h"
#import "JKSaveSceneTool.h"
#import "JKSceneModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface JKScenesTableViewController ()<JKNewScenceDelegate>
{
    NSArray *sceneImgArray;
    NSArray *sceneNameArray;
    NSMutableArray *definedScene;
    NSMutableArray *defaultScene;
    ALAssetsLibrary *assetLib;
    
    
    NSMutableArray *selectedScenes;
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
    
    defaultScene = [NSMutableArray array];
    for (int i = 0; i < sceneImgArray.count; i++) {
        JKSceneModel *scene = [[JKSceneModel alloc] init];
        scene.name = sceneNameArray[i];
        scene.imgName = sceneImgArray[i];
        [defaultScene addObject:scene];
    }
    
    
    NSArray *userDefinedScenes = [[JKSaveSceneTool sharedInstance] unarchiveBrandsIconWithKey:@"definedScene"];
    definedScene = [NSMutableArray arrayWithArray:userDefinedScenes];
    selectedScenes = [NSMutableArray array];
    assetLib = [[ALAssetsLibrary alloc] init];
    
}

- (void)doneAction
{
    if ([_delegate respondsToSelector:@selector(addScenes:)]) {
        [_delegate addScenes:selectedScenes];
    }
    
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
        return definedScene.count + 1;
    }
    return defaultScene.count;
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
        
        JKSceneModel *scene = defaultScene[indexPath.row];
        cell.textLabel.text = scene.name;
        
        UIGraphicsBeginImageContext(CGSizeMake(50, 50));
        UIImage *img = [UIImage imageNamed:sceneImgArray[indexPath.row]];
        [img drawInRect:CGRectMake(0, 0, 50, 50)];
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        cell.imageView.image = img;
        cell.imageView.layer.masksToBounds = YES;
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uncheck_icon"]];

    } else {
        
        if (indexPath.row < definedScene.count) {
            JKSceneModel *scene = definedScene[indexPath.row];
            cell.textLabel.text = scene.name;
            UIGraphicsBeginImageContext(CGSizeMake(50, 50));
            
            [assetLib assetForURL:[NSURL URLWithString:scene.imgName] resultBlock:^(ALAsset *asset) {
                UIImage *img = [UIImage imageWithCGImage:[asset thumbnail]];
                [img drawInRect:CGRectMake(0, 0, 50, 50)];
                img = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                cell.imageView.image = img;
                cell.imageView.layer.masksToBounds = YES;
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uncheck_icon"]];
                
            } failureBlock:^(NSError *error) {
                
            }];
            
        } else {
            cell.textLabel.text = @"添加新场景";
            cell.imageView.image = [UIImage imageNamed:@"scene_add_img"];
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
        }

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
        
        [selectedScenes addObject:defaultScene[indexPath.row]];
        
    } else {
    
        if (indexPath.row < definedScene.count) {
            [tableView cellForRowAtIndexPath:indexPath].accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked_icon"]];
            [selectedScenes addObject:definedScene[indexPath.row]];
            
        } else {
            JKNewScenceController *vc = [[JKNewScenceController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];

        }
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uncheck_icon"]];
        [selectedScenes removeObject:defaultScene[indexPath.row]];
    } else {
        if (indexPath.row < definedScene.count) {
            [selectedScenes removeObject:definedScene[indexPath.row]];
        }
    }
    

}


- (void)addNewScene:(JKSceneModel *)newScene
{
    [definedScene addObject:newScene];
    
    
    [[JKSaveSceneTool sharedInstance] archiveScene:definedScene withKey:@"definedScene"];
    [self.tableView reloadData];
}

@end
