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

@interface JKScenesViewController ()<UICollectionViewDelegateFlowLayout,JKScenesSelectDelegate>
{
    NSMutableArray *sceneArray;
    ALAssetsLibrary *assetLib;
    
    BOOL isEditing;
}
@end

@implementation JKScenesViewController

static NSString * const reuseIdentifier = @"scene_cell_id";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.title = @"场景";
//    self.collectionView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_bg"]];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg"]];
    [self setupLayout];
    
    UIImage *newImage = [[UIImage imageNamed:@"tab_scene_un"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *newSelectedImage = [[UIImage imageNamed:@"tab_scene"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor yellowColor]} forState:UIControlStateNormal];
    self.tabBarItem.image = newImage;
    self.tabBarItem.selectedImage = newSelectedImage;

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
    layout.itemSize = CGSizeMake(FullScreen_width/2-2, 190);
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 5;
    self.collectionView.collectionViewLayout = layout;
    
}

- (void)deleteScene:(UIButton *)button
{
    [sceneArray removeObjectAtIndex:button.tag];
    [self saveScene];
    [self.collectionView reloadData];
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
    [cell.delBtn addTarget:self action:@selector(deleteScene:) forControlEvents:UIControlEventTouchUpInside];
    
    
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

- (IBAction)editScene:(UIBarButtonItem *)sender {
    
    isEditing = !isEditing;
    [self.collectionView reloadData];
}
@end
