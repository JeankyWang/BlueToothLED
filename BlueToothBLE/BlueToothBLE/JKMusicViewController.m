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
#import "JKModeListViewController.h"
#import "JKSendDataTool.h"
#import "SVProgressHUD.h"

typedef NS_OPTIONS(NSInteger, JKMusicStyle) {
    JKMusicStyleNormal = 0,
    JKMusicStyleSoft = 1,
    JKMusicStyleStrong = 2
};

@interface JKMusicViewController ()<UITableViewDataSource,UITableViewDelegate,MPMediaPickerControllerDelegate,UINavigationControllerDelegate,AVAudioPlayerDelegate,JKUserdefindColorDelegate>
{
    NSMutableArray *styleBtnArray;
    UIImageView *thumbImg;
    UILabel *pastTimeLabel;
    UILabel *haveTimeLabel;
    UIProgressView *timeProgress;
    JKDefineMenuView *songListView;
    UITableView *songListTabelView;
    
    MPMediaItemCollection *songsCollection;
    AVAudioPlayer *player;
    MPMusicPlayerController *musicPlayer;
    CGFloat angle;
    
    int currentPlayIndex;
    NSTimer *timer;
    NSTimer *musicTimer;
    JKMusicStyle musicStyle;
    NSArray *selectedColorsArray;
}
@end

@implementation JKMusicViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [player pause];
    [timer pauseTimer];
    [musicTimer pauseTimer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [player play];
    [timer resumeTimer];
    [musicTimer resumeTimer];
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
        btn.tag = i;
        [btn addTarget:self action:@selector(chooseMusicStyle:) forControlEvents:UIControlEventTouchUpInside];
        [styleView addSubview:btn];
        [styleBtnArray addObject:btn];
    }

    
    //专辑画面
    thumbImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"music_strong"]];
    thumbImg.frame = CGRectMake(FullScreen_width/2-100, FullScreen_height/2-100, 200, 200);
    thumbImg.layer.cornerRadius = 100;
    thumbImg.layer.masksToBounds = YES;
    [self.view addSubview:thumbImg];
    
    //控制按钮
    
    UIButton *preBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(thumbImg.frame)+30*PhoneScale, CGRectGetMaxY(thumbImg.frame) + 10, 30, 30)];
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
    
    pastTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(playBtn.frame)+18*PhoneScale, 50, 10)];
    pastTimeLabel.textColor = [UIColor whiteColor];
    pastTimeLabel.font = Font(10);
    pastTimeLabel.text = @"00:00";
    pastTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:pastTimeLabel];
    
    timeProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pastTimeLabel.frame)+5, CGRectGetMinY(pastTimeLabel.frame)+2, FullScreen_width-110, 20)];
    timeProgress.progressTintColor = [UIColor colorWithHexString:@"c059f0"];
    [self.view addSubview:timeProgress];
    
    haveTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeProgress.frame)+5, CGRectGetMinY(pastTimeLabel.frame), 50, 10)];
    haveTimeLabel.textColor = [UIColor whiteColor];
    haveTimeLabel.font = Font(10);
    haveTimeLabel.text = @"00:00";
    haveTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:haveTimeLabel];
    
    //
    UIButton *musicLibBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(timeProgress.frame), CGRectGetMaxY(timeProgress.frame)+30*PhoneScale, 100, 30)];
    [musicLibBtn setImage:[UIImage imageNamed:@"music_db"] forState:UIControlStateNormal];
    [musicLibBtn setTitle:@" 本地音乐" forState:UIControlStateNormal];
    [musicLibBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    musicLibBtn.titleLabel.font = Font(14);
    [musicLibBtn addTarget:self action:@selector(showLocalSongs) forControlEvents:UIControlEventTouchUpInside];
    musicLibBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:.15];
    musicLibBtn.layer.cornerRadius = 2;
    [self.view addSubview:musicLibBtn];
    
    UIButton *musicListBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeProgress.frame)-100, CGRectGetMinY(musicLibBtn.frame), 100, 30)];
    [musicListBtn setImage:[UIImage imageNamed:@"music_list"] forState:UIControlStateNormal];
    [musicListBtn setTitle:@" 播放列表" forState:UIControlStateNormal];
    [musicListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [musicListBtn addTarget:self action:@selector(showSongList) forControlEvents:UIControlEventTouchUpInside];
    musicListBtn.titleLabel.font = Font(14);
    musicListBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:.15];
    musicListBtn.layer.cornerRadius = 2;
    [self.view addSubview:musicListBtn];
    
    [self refreshSongs];
    
    //播放列表
    songListView = [[JKDefineMenuView alloc] initWithFrame:CGRectMake(0, FullScreen_height-300, FullScreen_width, 300) inView:self.view];
    songListView.style = JKDefineMenuViewBottom;
    songListView.animationDuration = 0.25;
    songListView.allowAutoDisappear = NO;
    songListView.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    
    UIButton *hideBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, FullScreen_width, 40)];
    [hideBtn setImage:[UIImage imageNamed:@"music_down_arrow"] forState:UIControlStateNormal];
    [hideBtn addTarget:self action:@selector(hideSongList) forControlEvents:UIControlEventTouchUpInside];
    [songListView addSubview:hideBtn];
    
    songListTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(songListView.frame), CGRectGetHeight(songListView.frame)-60) style:UITableViewStylePlain];
    songListTabelView.delegate = self;
    songListTabelView.dataSource = self;
    songListTabelView.backgroundColor = [UIColor clearColor];
    songListTabelView.tableFooterView = [UIView new];
    songListTabelView.separatorColor = BLE_Theme_Color;
    [songListView addSubview:songListTabelView];
    
    //播放器
//    musicPlayer = [[MPMusicPlayerController alloc] init];
//    [musicPlayer setQueueWithItemCollection:songsCollection];
//    [musicPlayer play];
    [self playSongAtIndex:0];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(thumbImageRotation) userInfo:nil repeats:YES];
    musicTimer = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(playProgress) userInfo:nil repeats:YES];
}

- (void)hideSongList
{
    [songListView dismissMenu];
}

#pragma mark -加载歌曲
-(void)playSongAtIndex:(NSInteger)index
{
    if (songsCollection.items == 0) {
        [SVProgressHUD showInfoWithStatus:@"请先选择本地歌曲"];
        return;
    }
    
    currentPlayIndex = abs((int)index) % songsCollection.items.count;
    MPMediaItem *song = songsCollection.items[currentPlayIndex];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[song valueForProperty:MPMediaItemPropertyAssetURL] error:nil];
    player.delegate = self;
    [player prepareToPlay];
    [player play];
    player.meteringEnabled = YES;//开启仪表计数功能
    [self refreshArtwork];
    
}

- (void)refreshArtwork
{
    MPMediaItemArtwork *album = [songsCollection.items[currentPlayIndex] valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *image = [album imageWithSize:thumbImg.frame.size];
    
    if (image) {
        thumbImg.image = image;
    } else {
        thumbImg.image = [UIImage imageNamed:@"music_strong"];
    }
    
}

- (void)thumbImageRotation
{
    angle ++;
    thumbImg.transform = CGAffineTransformMakeRotation(angle/180);
}

#pragma mark -显示播放列表
- (void)showSongList
{
    if (songsCollection.items == 0) {
        [SVProgressHUD showInfoWithStatus:@"请先选择本地歌曲"];
        return;
    }
    
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
//    [musicPlayer skipToPreviousItem];
    [self playSongAtIndex:--currentPlayIndex];
}

- (void)playPauseSong:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (button.selected) {
        [player pause];
        [timer pauseTimer];
        [musicTimer pauseTimer];
    } else {
        [player play];
        [timer resumeTimer];
        [musicTimer resumeTimer];
    }
}

- (void)playNextSong
{
//    [musicPlayer skipToNextItem];
    [self playSongAtIndex:++currentPlayIndex];
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
    musicStyle = (JKMusicStyle)button.tag;
    button.selected = YES;
}

- (void)dismissSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editMode
{
    JKModeListViewController *vc = [[JKModeListViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendDataBright:(Byte)brightness
{
    DLog(@"亮度：%d",brightness);
    if (musicStyle == JKMusicStyleStrong) {
        brightness = brightness > 50? 100:0;
        
    }else if(musicStyle == JKMusicStyleSoft){
        NSLog(@"柔和");
        brightness = brightness < 50? 50:brightness;
    }
    
    Byte byte[] = {0x7e,0x04,0x01,brightness,0xff,0xff,0xff,0x00,0xef};
    NSData *data = [[NSData alloc]initWithBytes:byte length:9];
    [self sendCMD:data];
}


#pragma mark -音乐主函数
//播放进度条
int m = 0;
int lastVm = 0;//纪录上次的明暗度
- (void)playProgress
{
    
    
    //通过音频播放时长的百分比,给progressview进行赋值;
    if (player.duration == 0) {
        return;
    }
    timeProgress.progress = player.currentTime/player.duration;
    pastTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)player.currentTime/60,(int)player.currentTime%60];
    haveTimeLabel.text = [NSString stringWithFormat:@"-%02d:%02d",((int)player.duration-(int)player.currentTime)/60, ((int)player.duration-(int)player.currentTime)%60];
    
    [player updateMeters];//更新仪表读数
    //读取每个声道的平均电平和峰值电平，代表每个声道的分贝数,范围在-100～0之间。
    float averagePower = pow(10, (0.05 * [player averagePowerForChannel:0]));
    Byte value = sqrtf(averagePower)*100;
    int vm = value;
    if ((vm - lastVm) > 5) {
        vm += 15;
    }
    else if((vm-lastVm)<0)
    {
        vm -= 20;
    }
    
    lastVm = value;
    
    //自定义颜色组
    if(selectedColorsArray.count > 0){

        if (vm > 0 && m%3 == 0) {
            
            [self defindedModePlay];
            
        }
        
        [self sendDataBright:vm];
    } else{
        if (vm > 0 && m%3 == 0) {
            
            [self sendDataRGBWithRed:0 green:0 blue:0];
        }
        
        [self sendDataBright:vm];
    }
    
    m++;
    
}


int cIndex = 0;
- (void)defindedModePlay
{
    UIColor *color = [selectedColorsArray objectAtIndex:cIndex % selectedColorsArray.count];
    cIndex ++;
    const CGFloat *colors =  CGColorGetComponents(color.CGColor);
    
    Byte red = (Byte)(colors[0]*255);
    Byte green = (Byte)(colors[1]*255);
    Byte blue = (Byte)(colors[2]*255);
    [[JKSendDataTool shareInstance] sendDataRGBWithRed:red green:green blue:blue devices:_deviceArray];
    
}

//随机光色
- (void)sendDataRGBWithRed:(Byte)red green:(Byte)green blue:(Byte)blue
{
    Byte color[] = {0x00,0xff,0xff,0x00,0xff,0x00};
    if (selectedColorsArray.count == 0) {
        red = color[arc4random()%6];
        green = color[arc4random()%6];
        blue = color[arc4random()%6];
        
        if (red == 0 && green ==0 && blue == 0) {
            red = 0xff;
            green = 0xff;
        }
        
        [[JKSendDataTool shareInstance] sendDataRGBWithRed:red green:green blue:blue devices:_deviceArray];
        
    }
    else
    {
        [[JKSendDataTool shareInstance] sendDataRGBWithRed:red green:green blue:blue devices:_deviceArray];
    }

}

- (void)sendCMD:(NSData*)data
{
    for (CBPeripheral *per in _deviceArray)
    {
        [per writeValue:data forCharacteristic:_writeCharacter type:CBCharacteristicWriteWithoutResponse];
    }
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell_id"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = Font(16);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.font = Font(12);
    }
    
    MPMediaItem *song = songsCollection.items[indexPath.row];
    DLog(@"song:%@",song);
    
    if (indexPath.row == currentPlayIndex) {
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
//    MPMediaItem *song = songsCollection.items[indexPath.row];
//    [musicPlayer setNowPlayingItem:song];
    
    [self playSongAtIndex:indexPath.row];
    
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

//播放完成时调用的方法  (代理里的方法),需要设置代理才可以调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    [self playNextSong];
    
}

#pragma mark -自选颜色
- (void)selectdColorArray:(NSArray *)colors
{
    selectedColorsArray = colors;
}
@end
