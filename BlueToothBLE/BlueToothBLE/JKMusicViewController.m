//
//  JKMusicViewController.m
//  BlueToothBLE
//
//  Created by wzq on 15/11/18.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKMusicViewController.h"

@interface JKMusicViewController ()
{
    NSMutableArray *styleBtnArray;
}
@end

@implementation JKMusicViewController

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

    
    
    UIImageView *thumbImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searching_img"]];
    thumbImg.frame = CGRectMake(FullScreen_width/2-100, CGRectGetMaxY(styleView.frame)+33, 200, 200);
    [self.view addSubview:thumbImg];
    
    
    UIProgressView *timeProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(FullScreen_width/2-113, CGRectGetMaxY(thumbImg.frame)+38, 227, 20)];
    timeProgress.progressTintColor = [UIColor colorWithHexString:@"c059f0"];
    [self.view addSubview:timeProgress];
    timeProgress.progress = .5;
    
    
    
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

@end
