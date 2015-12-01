//
//  JKMusicViewController.m
//  LED Colors
//
//  Created by wzq on 14/6/21.
//  Copyright (c) 2014年 wzq. All rights reserved.
//

#import "JKMusicViewController.h"
#import "SVProgressHUD.h"
#import "JKBLEServicAndCharacter.h"


@interface JKMusicViewController ()
{
    NSMutableArray *urls;
    NSArray *mediaItems;
    UISlider *powerSlider;
    UISlider *peakSlider;
    int musicIndex;
    UIImageView *artImageView;
    UILabel *artName;
    UILabel *timeLabel1;
    UILabel *timeLabel2;
    
    UILabel *ttMsc;
    UIButton *pauseBtn;
    UIButton *playBtn;
    NSTimer *timerArt;//控制唱片封面旋转
    
    UISwitch *swicher;

    //蓝牙设备
    NSMutableArray *bleDevices;
    NSMutableArray *localCharacter;
    NSMutableArray *currentDevice;
    
    UISegmentedControl *musicType;

}
@end

@implementation JKMusicViewController

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
    
//    [self.navigationController.navigationBar setHidden:YES];

//    self.title = NSLocalizedString(@"MUSIC", @"");
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editMode)];
    self.navigationItem.rightBarButtonItem = item;
    
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    img.frame = self.view.bounds;
    [self.view addSubview:img];

    UIButton *musicBtn = [[UIButton alloc]initWithFrame:CGRectMake(230, 260, 60, 30)];
    [musicBtn addTarget:self action:@selector(selectMP) forControlEvents:UIControlEventTouchUpInside];
    [musicBtn setTitle:NSLocalizedString(@"music lib", @"") forState:UIControlStateNormal];
    musicBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:musicBtn];
    musicBtn.backgroundColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:0.5];

    musicBtn.layer.cornerRadius = 3;

    
    urls = [NSMutableArray arrayWithCapacity:0];
    
    //音乐控制按钮
    UIButton *preBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, 335, 40, 40)];
    //    [preBtn setTitle:@"<" forState:UIControlStateNormal];
    [preBtn setBackgroundImage:[UIImage imageNamed:@"pre.png"] forState:UIControlStateNormal];
    [preBtn addTarget:self action:@selector(preMusic) forControlEvents:UIControlEventTouchUpInside];
    preBtn.backgroundColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:0.5];
    
    preBtn.layer.cornerRadius = 20;
    [self.view addSubview:preBtn];
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 335, 40, 40)];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextMusic) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.backgroundColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:0.5];
    
    nextBtn.layer.cornerRadius = 20;
    [self.view addSubview:nextBtn];
    
    playBtn = [[UIButton alloc] initWithFrame:CGRectMake(140, 330, 50, 50)];
    
    [playBtn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    playBtn.backgroundColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:0.5];
    
    playBtn.layer.cornerRadius = 25;
    [playBtn setHidden:YES];
    [self.view addSubview:playBtn];
    
    pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(140, 330, 50, 50)];
    [pauseBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    [pauseBtn addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    pauseBtn.backgroundColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:0.5];
    
    pauseBtn.layer.cornerRadius = 25;
    [self.view addSubview:pauseBtn];
    
    UIButton *stopBtn = [[UIButton alloc] initWithFrame:CGRectMake(160, 330, 30, 30)];
    [stopBtn setTitle:@"Stop" forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    stopBtn.backgroundColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:0.5];
    stopBtn.layer.borderWidth = 0.5;
    stopBtn.layer.cornerRadius = 3;

    
    _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(75, 310, 180, 20)];
    _progress.progress = 0.0f;
    _progress.progressTintColor = [UIColor whiteColor];
    
   [self.view addSubview:_progress];
    timeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(260, 300, 100, 20)];
    timeLabel2.font = [UIFont systemFontOfSize:12];
    timeLabel2.backgroundColor = [UIColor clearColor];
    timeLabel2.textColor = [UIColor whiteColor];
    [self.view addSubview:timeLabel2];
    
    timeLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 300, 100, 20)];
    timeLabel1.font = [UIFont systemFontOfSize:12];
    timeLabel1.backgroundColor = [UIColor clearColor];
    timeLabel1.textColor = [UIColor whiteColor];
    [self.view addSubview:timeLabel1];
    
    artName = [[UILabel alloc]initWithFrame:CGRectMake(40, 50, 260, 40)];
    artName.font = [UIFont systemFontOfSize:15];
    artName.backgroundColor = [UIColor clearColor];
    artName.textAlignment = NSTextAlignmentCenter;
    artName.textColor = [UIColor whiteColor];
    [self.view addSubview:artName];
    
    if (IPAD)
    {
        preBtn.frame        = CGRectMake(SCREEN_WIDTH/4-20, SCREEN_HEIGHT/2, 40, 40);
        nextBtn.frame       = CGRectMake(SCREEN_WIDTH*3/4-20, SCREEN_HEIGHT/2, 40, 40);
        playBtn.frame       = CGRectMake(SCREEN_WIDTH/2-25, SCREEN_HEIGHT/2, 50, 50);
        pauseBtn.frame      = CGRectMake(SCREEN_WIDTH/2-25, SCREEN_HEIGHT/2, 50, 50);
        _progress.frame     = CGRectMake(SCREEN_WIDTH/6,  SCREEN_HEIGHT/2-30, SCREEN_WIDTH*2/3, 20);
        timeLabel1.frame    = CGRectMake(SCREEN_WIDTH/6-50,  SCREEN_HEIGHT/2-30, 50, 20);
        timeLabel2.frame    = CGRectMake(SCREEN_WIDTH *5 /6+20,  SCREEN_HEIGHT/2-30, 50, 20);
        musicBtn.frame      = CGRectMake(SCREEN_WIDTH *5/6-100,  SCREEN_HEIGHT/2-80, 100, 30);
    }

    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(playProgress)userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
    
    timerArt = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(startRound) userInfo:nil repeats:YES];
    


    powerSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 5, 280, 20)];
    powerSlider.minimumValue = -25.0f;
    powerSlider.maximumValue = 0.0f;
    
    peakSlider = [[UISlider alloc] initWithFrame:CGRectMake(20,350, 200, 20)];
    peakSlider.minimumValue = -25.0f;
    peakSlider.maximumValue = 0.0f;
    
    ttMsc = [[UILabel alloc]initWithFrame:CGRectMake(0, 280, SCREEN_WIDTH, 20)];
    ttMsc.font = [UIFont systemFontOfSize:12];
    ttMsc.textColor = [UIColor whiteColor];
    ttMsc.backgroundColor = [UIColor clearColor];
    ttMsc.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:ttMsc];

    
    mediaItems = [NSArray array];
    artImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noMusic.png"]];
    artImageView.frame = CGRectMake(SCREEN_WIDTH/2-75, 90, 150, 150);
    artImageView.layer.cornerRadius = 75;
    artImageView.clipsToBounds = YES;
    artImageView.layer.borderWidth = 2;
    artImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [self.view addSubview:artImageView];
    
    [self initDatas];
    
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    _colorArray = [NSMutableArray arrayWithCapacity:0];

    UISlider *style = [[UISlider alloc]initWithFrame:CGRectMake(80, 30, SCREEN_WIDTH-100, 40)];
    style.minimumValue=0;
    style.maximumValue = 0.25;
    style.value = 0;
    style.minimumTrackTintColor = [UIColor whiteColor];
    [self.view addSubview:style];
    [style addTarget:self action:@selector(changeMusicStype:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *rhythm = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, 50, 40)];
    rhythm.text = NSLocalizedString(@"Rhythm", @"");
    rhythm.textColor = [UIColor whiteColor];
    rhythm.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:rhythm];
    
    musicType = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"Pop", @""),NSLocalizedString(@"Soft", @""),NSLocalizedString(@"Rock", @"")]];
    musicType.frame = CGRectMake(SCREEN_WIDTH/2 - 75, 5, 150, 30);
    musicType.selectedSegmentIndex = 0;

    [musicType addTarget:self action:@selector(defineMusicStyle:) forControlEvents:UIControlEventValueChanged];
    
    [self.navigationController.navigationBar addSubview:musicType];
    
    
    
    
    
    

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [musicType setHidden:NO];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editMode)];
    self.navigationItem.rightBarButtonItem = item;


    [self.tabBarController.navigationController.toolbar setHidden:YES];
    [self.tabBarController.navigationController.navigationBar setHidden:YES];

    [self openLight];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self pause];
//    [self closeLight];
//    [_socket disconnect];
    

}

- (void)defineMusicStyle:(UISegmentedControl *)segment
{
    NSInteger index = segment.selectedSegmentIndex;
    
    switch (index) {
        case 0:
            _changeMode = JKChangeModeJB;
            break;
        case 1:
            _changeMode = JKChangeModeJump;
            break;
        case 2:
            _changeMode = JKChangeModeBaoShan;
            break;
        default:
            _changeMode = JKChangeModeJB;
            break;
    }
}

- (void)changeMusicStype:(UISlider*)slider
{
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.3-slider.value target:self selector:@selector(playProgress)userInfo:nil repeats:YES];
    
}



- (void)initDatas
{
    bleDevices = ((JKRGBTabBarViewController *)self.tabBarController).pers;
    localCharacter = [JKBLEManager shareInstance].writeCharacteristic;


    currentDevice = [NSMutableArray new];
    for (NSString *str in bleDevices)
    {
        for (JKBLEServicAndCharacter *obj in [JKBLEManager shareInstance].writeCharacteristic)
        {
            if ([obj.bleDevice.identifier.UUIDString isEqualToString:str] && ![currentDevice containsObject:obj])
            {
                [currentDevice addObject:obj];
            }
        }
    }


}




- (void)sendCMD:(NSData*)data
{
    for (JKBLEServicAndCharacter *obj in currentDevice)
    {
        [obj.bleDevice writeValue:data forCharacteristic:obj.character type:CBCharacteristicWriteWithoutResponse];
    }
}

- (void)closeLight
{
    Byte dataOFF[9] = {0x7e,0x04,0x04,0x00,0x00,0xff,0xff,0x0,0xef};
    NSData *data = [[NSData alloc]initWithBytes:dataOFF length:9];
    [self sendCMD:data];
    
}

- (void)openLight
{
    Byte dataON[9]  = {0x7e,0x04,0x04,0x01,0x00,0xff,0xff,0x0,0xef};
    NSData *data = [[NSData alloc]initWithBytes:dataON length:9];
    [self sendCMD:data];
}

- (void)editMode
{

    JKModeListViewController *vc = [[JKModeListViewController alloc]init];
    vc.delegate = self;
    [musicType setHidden:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - mode list delegate

- (void)runWithColors:(NSMutableArray *)array AndType:(JKChangeMode)type
{
    [self openLight];
    _colorArray = array;
    _isDefind = YES;
    [self play];
}



- (void)sendDataCTWithHot:(Byte)hot cold:(Byte)cold
{
    Byte byte[] = {0x7e,0x06,0x05,0x02,hot,cold,0xff,0x08,0xef};
    NSData *data = [[NSData alloc]initWithBytes:byte length:9];
    
    NSLog(@"-------CT---hot:%d-cold:%d-",hot,cold);
    [self sendCMD:data];
}

- (void)sendDataBright:(Byte)brightness
{
    
    if (_changeMode == JKChangeModeBaoShan) {
        brightness = brightness > 50? 100:0;
        
    }else if(_changeMode == JKChangeModeJump){
        NSLog(@"柔和");
        brightness = brightness < 50? 50:brightness;
    }
    
    Byte byte[] = {0x7e,0x04,0x01,brightness,0xff,0xff,0xff,0x00,0xef};
    NSData *data = [[NSData alloc]initWithBytes:byte length:9];
    [self sendCMD:data];
    [self sendCMD:data];

    [[NSUserDefaults standardUserDefaults] setFloat:brightness/100.0 forKey:BRIGHTNESS_USER_DEFAULT];


}

//随机光色
- (void)sendDataRGBWithRed:(Byte)red green:(Byte)green blue:(Byte)blue
{
    Byte color[] = {0x00,0xff,0xff,0x00,0xff,0x00};
    if (!_isDefind || _colorArray.count == 0) {
        red = color[arc4random()%6];
        green = color[arc4random()%6];
        blue = color[arc4random()%6];
        
        if (red == 0 && green ==0 && blue == 0) {
            red = 0xff;
            green = 0xff;
        }
        
        Byte byte[] = {0x7e,0x07,0x05,0x03,red,green,blue,0x0,0xef};
        NSData *data = [[NSData alloc]initWithBytes:byte length:9];
        NSLog(@"r:%d g:%d b:%d",red,green,blue);
        [self sendCMD:data];
        [self sendCMD:data];
        
    }
    else
    {
        Byte byte[] = {0x7e,0x07,0x05,0x03,red,green,blue,0x0,0xef};
        NSData *data = [[NSData alloc]initWithBytes:byte length:9];
        [self sendCMD:data];
        [self sendCMD:data];
    }

}

- (void)selectMP
{
    MPMediaPickerController *mPk = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    mPk.delegate = self;
    mPk.allowsPickingMultipleItems = YES;

    [SVProgressHUD dismiss];
    [self presentViewController:mPk animated:YES completion:^{}];

}


#pragma mark - media delegate
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
//    [_player setQueueWithItemCollection:mediaItemCollection];
//    collection = mediaItemCollection;
    mediaItems = mediaItemCollection.items;
//    [self processCollection:mediaItemCollection];
    [self dismissViewControllerAnimated:YES completion:^{}];
    ttMsc.text = [NSString stringWithFormat:@"selected %d song(s)",(int)mediaItems.count];
    [self startPlay];
}



- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)processCollection:(MPMediaItemCollection *)collection
{
    for (MPMediaItem *item in collection.items) {
        NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];

        NSLog(@"url :%@",url);
        if (url) {
            [urls addObject:url];
        }
        

    }
    
    [self startPlay];


    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startPlay
{
    [self loadMusic:0];
    musicIndex = 0;
}

//唱片封面不断旋转
int a = 0;
- (void)startRound
{
    
    a++;
    artImageView.transform = CGAffineTransformMakeRotation(a * M_PI / 180.0);
    

}

- (void)play
{
    if (mediaItems.count == 0)
    {
        
    
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Alert", @"") message:NSLocalizedString(@"select_music_alert", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"") otherButtonTitles:NSLocalizedString(@"OK",@""), nil];
        [alert show];
        return;
    }

    [playBtn setHidden:YES];
    [pauseBtn setHidden:NO];
    [_player play];
    _player.meteringEnabled = YES;//开启仪表计数功能
    [_timer setFireDate:[NSDate date]];
    [timerArt setFireDate:[NSDate date]];
   
    [self openLight];
    
}
     //暂停
 - (void)pause
{
    [playBtn setHidden:NO];
    [pauseBtn setHidden:YES];
    [_player pause];
    [_timer setFireDate:[NSDate distantFuture]];
    [timerArt setFireDate:[NSDate distantFuture]];
}
     //停止
- (void)stop
{
    _player.currentTime = 0;  //当前播放时间设置为0
    [_player stop];
    [_timer setFireDate:[NSDate distantFuture]];
    [timerArt setFireDate:[NSDate distantFuture]];

}

- (void)preMusic
{
    [self loadMusic:--musicIndex];
}

- (void)nextMusic
{
    [self loadMusic:++musicIndex];
}


#pragma mark -音乐主函数
 //播放进度条
int m = 0;
int lastVm = 0;//纪录上次的明暗度
- (void)playProgress
 {
     
     
     //通过音频播放时长的百分比,给progressview进行赋值;
     if (_player.duration == 0) {
         return;
     }
     _progress.progress = _player.currentTime/_player.duration;
     timeLabel1.text = [NSString stringWithFormat:@"%02d:%02d",(int)_player.currentTime/60,(int)_player.currentTime%60];
     timeLabel2.text = [NSString stringWithFormat:@"-%02d:%02d",((int)_player.duration-(int)_player.currentTime)/60, ((int)_player.duration-(int)_player.currentTime)%60];
     
     [ _player updateMeters];//更新仪表读数
     //读取每个声道的平均电平和峰值电平，代表每个声道的分贝数,范围在-100～0之间。
     float averagePower = pow(10, (0.05 * [_player averagePowerForChannel:0]));
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
     
    
     if(_isDefind && _colorArray.count > 0){
         
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

 //声音开关(是否静音)
 - (void)onOrOff:(UISwitch *)sender
{
     _player.volume = sender.on;
}

 //播放音量控制
- (void)volumeChange
{
       _player.volume = _volumeSlider.value;
}

 //播放完成时调用的方法  (代理里的方法),需要设置代理才可以调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{

    [self nextMusic];
    
}

int cIndex = 0;
- (void)defindedModePlay
{
    UIColor *color = [_colorArray objectAtIndex:cIndex % _colorArray.count];
    cIndex ++;
    const CGFloat *colors =  CGColorGetComponents(color.CGColor);
    
    Byte r = (Byte)(colors[0]*255);
    Byte g = (Byte)(colors[1]*255);
    Byte b = (Byte)(colors[2]*255);
    [self sendDataRGBWithRed:r green:g blue:b];
    
    
}


- (void)loadMusic:(int) index
{
    if (mediaItems == nil || mediaItems.count == 0) {
        return;
    }
    musicIndex = abs(index) % mediaItems.count;
    MPMediaItem *item = [mediaItems objectAtIndex:musicIndex];
    NSURL *url=[item valueForKey:MPMediaItemPropertyAssetURL];
   
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _player.delegate = self;
    [_player prepareToPlay];
    
    MPMediaItemArtwork *art = [item valueForProperty:MPMediaItemPropertyArtwork];
    NSString *zj = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
    NSString *title = [item valueForProperty:MPMediaItemPropertyTitle];
    NSString *artist = [item valueForProperty:MPMediaItemPropertyArtist];
    
    artName.text = [NSString stringWithFormat:@"%@-%@-%@",zj,title,artist];
    UIImage *artImg = [art imageWithSize:CGSizeMake(100, 100)];
    if (!artImg)
    {
        artImageView.image = [UIImage imageNamed:@"noMusic.png"];
    }
    else
    {
        artImageView.image = artImg;
    }
    
    [self play];
}

#pragma mark - alert delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            [self selectMP];
            break;
        default:
            break;
    }
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

- (IBAction)goHome:(UIBarButtonItem *)sender
{
//    [self.tabBarController.navigationController popViewControllerAnimated:YES];
      [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
