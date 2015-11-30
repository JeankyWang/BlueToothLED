//
//  JKMusicViewController.m
//  BlueToothBLE
//
//  Created by wzq on 15/11/18.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKMusicViewController.h"
#import "JKDefineMenuView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "JKSaveSceneTool.h"
#import "NSTimer+Addition.h"

@interface JKMusicViewController ()<UITableViewDataSource,UITableViewDelegate,MPMediaPickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *styleBtnArray;
    UIImageView *thumbImg;
    UIProgressView *timeProgress;
    JKDefineMenuView *songListView;
    UITableView *songListTabelView;
    
    MPMediaItemCollection *songsCollection;
    AVAudioPlayer *player;
    MPMusicPlayerController *musicPlayer;
    CGFloat angle;
    
    NSTimer *timer;
}
@end

@implementation JKMusicViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [musicPlayer pause];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"音乐";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg"]];
    [self setupUI];
}

- (void)setupUI
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close_nav"] style:UIBarButtonItemStyleBordered target:self action:@selector(dismissSelf)];
    self.navigationItem.leftBarButtonItem = item;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editMode)];
    
    
    UIView *styleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, FullScreen_width, 100)];
    styleView.backgroundColor = [UIColor colorWithWhite:0 alpha:.4];
    [self.view addSubview:styleView];
    
    styleBtnArray = [NSMutableArray array];
    
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(FullScreen_width*i/3, 0, FullScreen_width/3, 100)];
        [btn setImage:[UIImage imageNamed:@[@"music_pop",@"music_soft",@"music_rock"][i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@[@"e54748",@"5aaaf1",@"f46ba1"][i]] forState:UIControlStateSelected];
        [btn setTitle:@[@"原始",@"柔和", @"强烈"][i] forState:UIControlStateNormal];
        btn.titleLabel.font = Font(14);
        btn.titleEdgeInsets = UIEdgeInsetsMake(40, -20, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 20, -20);
        if (i == 0) {
            btn.selected = YES;
        }
        [btn addTarget:self action:@selector(chooseMusicStyle:) forControlEvents:UIControlEventTouchUpInside];
        [styleView addSubview:btn];
        [styleBtnArray addObject:btn];
    }

    
    
    thumbImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"music_strong"]];
    thumbImg.frame = CGRectMake(FullScreen_width/2-100, CGRectGetMaxY(styleView.frame)+33, 200, 200);
    thumbImg.layer.cornerRadius = 100;
    thumbImg.layer.masksToBounds = YES;
    [self.view addSubview:thumbImg];
    
    //控制按钮
    
    UIButton *preBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(thumbImg.frame)+30, CGRectGetMaxY(thumbImg.frame) + 10, 30, 30)];
    [preBtn setImage:[UIImage imageNamed:@"music_pre"] forState:UIControlStateNormal];
    [preBtn addTarget:self action:@selector(playPreSong) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:preBtn];
    
    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(FullScreen_width/2 - 15, CGRectGetMinY(preBtn.frame), 30, 30)];
    [playBtn setImage:[UIImage imageNamed:@"music_pause"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"music_play"] forState:UIControlStateSelected];
    [playBtn addTarget:self action:@selector(playPauseSong:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(thumbImg.frame) - 60, CGRectGetMinY(preBtn.frame), 30, 30)];
    [nextBtn setImage:[UIImage imageNamed:@"music_next"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(playNextSong) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    timeProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(FullScreen_width/2-113, CGRectGetMaxY(playBtn.frame)+18, 227, 20)];
    timeProgress.progressTintColor = [UIColor colorWithHexString:@"c059f0"];
    [self.view addSubview:timeProgress];
    timeProgress.progress = .5;
    
    
    
    //
    UIButton *musicLibBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(timeProgress.frame), CGRectGetMaxY(timeProgress.frame)+30, 100, 30)];
    [musicLibBtn setImage:[UIImage imageNamed:@"music_db"] forState:UIControlStateNormal];
    [musicLibBtn setTitle:@"本地音乐" forState:UIControlStateNormal];
    [musicLibBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    musicLibBtn.titleLabel.font = Font(14);
    [musicLibBtn addTarget:self action:@selector(showLocalSongs) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:musicLibBtn];
    
    UIButton *musicListBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(musicLibBtn.frame)+20, CGRectGetMinY(musicLibBtn.frame), 100, 30)];
    [musicListBtn setImage:[UIImage imageNamed:@"music_list"] forState:UIControlStateNormal];
    [musicListBtn setTitle:@"播放列表" forState:UIControlStateNormal];
    [musicListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [musicListBtn addTarget:self action:@selector(showSongList) forControlEvents:UIControlEventTouchUpInside];
    musicListBtn.titleLabel.font = Font(14);
    [self.view addSubview:musicListBtn];
    
    [self refreshSongs];
    
    //播放列表
    songListView = [[JKDefineMenuView alloc] initWithFrame:CGRectMake(0, FullScreen_height-300, FullScreen_width, 300) inView:self.view];
    songListView.style = JKDefineMenuViewBottom;
    songListView.animationDuration = 0.25;
    songListView.allowAutoDisappear = NO;
    songListView.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    
    songListTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(songListView.frame), CGRectGetHeight(songListView.frame)-40) style:UITableViewStylePlain];
    songListTabelView.delegate = self;
    songListTabelView.dataSource = self;
    songListTabelView.backgroundColor = [UIColor clearColor];
    songListTabelView.tableFooterView = [UIView new];
    songListTabelView.separatorColor = BLE_Theme_Color;
    [songListView addSubview:songListTabelView];
    
    //播放器
    
    player = [[AVAudioPlayer alloc] init];
    MPMediaItem *song = songsCollection.items[0];

//    musicPlayer = [[MPMusicPlayerController alloc] init];
//    [musicPlayer setQueueWithItemCollection:songsCollection];
//    [musicPlayer play];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(thumbImageRotation) userInfo:nil repeats:YES];
}

- (void)refreshArtwork
{
    MPMediaItemArtwork *album = [musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *image = [album imageWithSize:thumbImg.frame.size];
    thumbImg.image = image;
}

- (void)thumbImageRotation
{
    angle ++;
    thumbImg.transform = CGAffineTransformMakeRotation(angle/180);
}

- (void)showSongList
{
    [songListView showMenu];
    [songListTabelView reloadData];
}

- (void)showLocalSongs
{
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    picker.allowsPickingMultipleItems = YES;
    picker.prompt = @"选取音乐";
    picker.delegate = self;

    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)playPreSong
{
    [musicPlayer skipToPreviousItem];
}

- (void)playPauseSong:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (button.selected) {
        [musicPlayer pause];
        [timer pauseTimer];
    } else {
        [musicPlayer play];
        [timer resumeTimer];
    }
}

- (void)playNextSong
{
    [musicPlayer skipToNextItem];
}

- (void)refreshSongs
{
    songsCollection =  [MPMediaItemCollection collectionWithItems:[[JKSaveSceneTool sharedInstance] unarchiveBrandsIconWithKey:@"selected_songs"]];
    DLog(@"获取存储的songs：%@",songsCollection);
    
}

- (void)chooseMusicStyle:(UIButton *)button
{
    for (UIButton *btn in styleBtnArray) {
        btn.selected = NO;
    }
    
    button.selected = YES;
}

- (void)dismissSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editMode
{
    
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return songsCollection.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell_id"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = Font(16);
        
        cell.detailTextLabel.font = Font(12);
    }
    
    MPMediaItem *song = songsCollection.items[indexPath.row];
    DLog(@"song:%@",song);
    
    if (song == musicPlayer.nowPlayingItem) {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    } else {
        cell.textLabel.textColor = BLE_Theme_Color;
        cell.detailTextLabel.textColor = BLE_Theme_Color;
    }
    
    
    cell.textLabel.text = [song valueForProperty: MPMediaItemPropertyTitle];
    cell.detailTextLabel.text = [song valueForProperty:MPMediaItemPropertyArtist];


    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPMediaItem *song = songsCollection.items[indexPath.row];
    [musicPlayer setNowPlayingItem:song];
    [self refreshArtwork];
    [songListView dismissMenu];
    
}

#pragma mark -media picker delegate
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    DLog(@"音乐：%@",mediaItemCollection);
    [[JKSaveSceneTool sharedInstance] archiveScene:mediaItemCollection.items withKey:@"selected_songs"];
    [self refreshSongs];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName,nil]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
