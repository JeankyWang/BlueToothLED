//
//  JKMusicViewController.h
//  LED Colors
//
//  Created by wzq on 14/6/21.
//  Copyright (c) 2014年 wzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "JKLEDSendDataDelegate.h"
#import "JKModeListViewController.h"
#import "JKRGBTabBarViewController.h"
#import "JKBLEManager.h"



@interface JKMusicViewController : UIViewController<MPMediaPickerControllerDelegate,AVAudioPlayerDelegate,JKLEDSendDataDelegate,JKModeListViewDelegate,UIAlertViewDelegate>
//@property (nonatomic,strong) MPMusicPlayerController *player;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, strong) UISlider *volumeSlider;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic)         BOOL isDefind;                      //NO 默认模式 YES 自定义模式
@property (nonatomic, strong) NSMutableArray *colorArray;
@property (nonatomic) JKChangeMode changeMode;
- (IBAction)goHome:(UIBarButtonItem *)sender;
@end
