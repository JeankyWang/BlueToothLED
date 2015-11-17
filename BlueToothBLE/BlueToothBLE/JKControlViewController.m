//
//  JKControlViewController.m
//  BlueToothBLE
//
//  Created by wzq on 15/11/13.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKControlViewController.h"
#import "JKTopLightView.h"
#import "JKDefineMenuView.h"
#import "JKColorPicker.h"

@interface JKControlViewController ()<JKTopLightViewDelegate>
{
    JKDefineMenuView *topMenu;
    JKTopLightView *topLightView;
    
    UIButton *colorBtn;
    UIButton *bwBtn;
    UIButton *ctBtn;
    
    NSArray *titleBtnArray;
    JKColorPicker *colorPicker;
}
@end

@implementation JKControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    
}

- (void)setupUI
{
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg"]];
    _mainScrollView.frame = self.view.bounds;
    _mainScrollView.contentSize = CGSizeMake(FullScreen_width*3, CGRectGetHeight(self.view.frame)-64);
    _mainScrollView.backgroundColor = [UIColor clearColor];
    
    topLightView = [[JKTopLightView alloc] initWithFrame:CGRectMake(0, 70, FullScreen_width, 100)];
    topLightView.delegate = self;
    [self.view addSubview:topLightView];
    
    topMenu = [[JKDefineMenuView alloc] initWithFrame:CGRectMake(0, 0, FullScreen_width, 200) inView:[UIApplication sharedApplication].keyWindow];
    topMenu.animationDuration = .25;
    topMenu.backgroundColor = [UIColor colorWithWhite:0 alpha:.3];
    topMenu.style = JKDefineMenuViewTop;
    
    [self setupNavBtns];
    [self setupColorPicker];
    [self setupBrightnessPicker];
    [self setupColorTmpPicker];
}

- (void)setupColorPicker
{
    UIView *pickBackView = [[UIView alloc] initWithFrame:CGRectMake(40, FullScreen_height/2 - 150, FullScreen_width - 80, FullScreen_width - 80)];
    pickBackView.backgroundColor = [UIColor colorWithWhite:1 alpha:.27];
    pickBackView.layer.cornerRadius = 20;
    
    
    colorPicker = [[JKColorPicker alloc] initWithFrame:CGRectMake(0, 0, 182, 182)];
    colorPicker.layer.cornerRadius = 91;
    [colorPicker addTarget:self action:@selector(pickColor:) forControlEvents:UIControlEventAllEvents];
    colorPicker.backgroundColor = [UIColor whiteColor];
    colorPicker.center = CGPointMake(CGRectGetWidth(pickBackView.frame)/2, CGRectGetWidth(pickBackView.frame)/2);
    [pickBackView addSubview:colorPicker];
    
    [_mainScrollView addSubview:pickBackView];
}

- (void)setupBrightnessPicker
{
    UIView *pickBackView = [[UIView alloc] initWithFrame:CGRectMake(40+FullScreen_width, FullScreen_height/2 - 150, FullScreen_width - 80, FullScreen_width - 80)];
    pickBackView.backgroundColor = [UIColor colorWithWhite:1 alpha:.27];
    pickBackView.layer.cornerRadius = 20;
    [_mainScrollView addSubview:pickBackView];
    
    for (int i = 0; i < 12; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(36 * (i%6) + 10, i/6 * 60 + 50, 36, 50)];
        [button addTarget:self action:@selector(brightnessClick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor colorWithWhite:(1.0 - i / 12.0) alpha:1];
        [pickBackView addSubview:button];
    }

}

- (void)setupColorTmpPicker
{
    UIView *pickBackView = [[UIView alloc] initWithFrame:CGRectMake(40 + FullScreen_width*2, FullScreen_height/2 - 150, FullScreen_width - 80, FullScreen_width - 80)];
    pickBackView.backgroundColor = [UIColor colorWithWhite:1 alpha:.27];
    pickBackView.layer.cornerRadius = 20;
    pickBackView.userInteractionEnabled = YES;
    [_mainScrollView addSubview:pickBackView];
    
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(pickBackView.frame)/2 - 10, CGRectGetWidth(pickBackView.frame)-30, 40)];
    [pickBackView addSubview:slider];
    

}

- (void)setupNavBtns
{
    colorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    [colorBtn setTitle:@"彩色" forState:UIControlStateNormal];
    [colorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [colorBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    colorBtn.selected = YES;
    [colorBtn addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    bwBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 0, 60, 20)];
    [bwBtn setTitle:@"单色" forState:UIControlStateNormal];
    [bwBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [bwBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [bwBtn addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    ctBtn = [[UIButton alloc] initWithFrame:CGRectMake(120, 0, 60, 20)];
    [ctBtn setTitle:@"色温" forState:UIControlStateNormal];
    [ctBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [ctBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [ctBtn addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];

    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 180, 20)];
    [titleView addSubview:colorBtn];
    [titleView addSubview:bwBtn];
    [titleView addSubview:ctBtn];
    titleBtnArray = @[colorBtn, bwBtn, ctBtn];
    
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showTopMenu)];
}

- (void)clickTitleBtn:(UIButton *)button
{
    for (UIButton *btn in titleBtnArray) {
        btn.selected = NO;
    }
    
    button.selected = YES;
    
    if (button == colorBtn) {
        [self scrollToPage:0];
    } else if (button == bwBtn){
        [self scrollToPage:1];
    } else {
        [self scrollToPage:2];
    }
    
}

- (void)scrollToPage:(NSInteger)page
{
    [UIView animateWithDuration:.25 animations:^{
        _mainScrollView.contentOffset = CGPointMake(FullScreen_width * page, _mainScrollView.contentOffset.y);
    }];
    
    
}

- (void)pickColor:(JKColorPicker *)picker
{
    [topLightView setLightColor:picker.selectColor];
}

- (void)brightnessClick:(UIButton *)button
{
    [topLightView setLightColor:button.backgroundColor];
}

- (void)showColorControl
{

}

- (void)showTopMenu
{

    [topMenu showMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -top light delegate
- (void)offOnBtnClick:(UIButton *)offOnButton
{
    if (offOnButton.selected) {
        
    } else {
        [topLightView setLightColor:[UIColor lightGrayColor]];
    }
}

- (void)conditionBtnClick:(UIButton *)conditionBtn
{

}

@end
