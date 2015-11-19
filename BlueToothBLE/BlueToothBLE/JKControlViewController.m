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
#import "JKMusicViewController.h"
#import "JKModeListViewController.h"
#import "JKTimerViewController.h"
#import "JKNavigationController.h"

@interface JKControlViewController ()<JKTopLightViewDelegate,UIScrollViewDelegate>
{
    JKDefineMenuView *topMenu;//弹出菜单
    JKDefineMenuView *bottomMenu;
    
    JKTopLightView *topLightView; //灯光指示view
    
    UIButton *colorBtn;
    UIButton *bwBtn;
    UIButton *ctBtn;
    
    NSArray *titleBtnArray;
    JKColorPicker *colorPicker;
    
    UILabel *ctValue;
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
    _mainScrollView.delaysContentTouches = YES;
    
    topLightView = [[JKTopLightView alloc] initWithFrame:CGRectMake(0, 70, FullScreen_width, 100)];
    topLightView.delegate = self;
   
    [self.view addSubview:topLightView];
    
    
    
    
    //自定弹出层显示
    topMenu = [[JKDefineMenuView alloc] initWithFrame:CGRectMake(0, 0, FullScreen_width, 134) inView:self.view];
    topMenu.animationDuration = .25;
    topMenu.style = JKDefineMenuViewTop;
    topMenu.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];

    UIView *v_line = [[UIView alloc] initWithFrame:CGRectMake(FullScreen_width/2, 80, 0.5, 30)];
    v_line.backgroundColor = [UIColor whiteColor];
    [topMenu addSubview:v_line];
    
    UIButton *musicBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, FullScreen_width/2, 70)];
    [musicBtn setImage:[UIImage imageNamed:@"music_music"] forState:UIControlStateNormal];
    [musicBtn addTarget:self action:@selector(showMusicView) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:musicBtn];
    UIButton *timerBtn = [[UIButton alloc] initWithFrame:CGRectMake(FullScreen_width/2, 64, FullScreen_width/2, 70)];
    [timerBtn setImage:[UIImage imageNamed:@"light_timer"] forState:UIControlStateNormal];
    [timerBtn addTarget:self action:@selector(showTimerView) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:timerBtn];

    
    
    //底部弹出
    bottomMenu = [[JKDefineMenuView alloc] initWithFrame:CGRectMake(0, FullScreen_height - 200, FullScreen_width, 200) inView:self.view];
    bottomMenu.animationDuration = .25;
    bottomMenu.style = JKDefineMenuViewBottom;
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"color_rate"]];
    icon.frame = CGRectMake(23, 39, 27, 27);
    [bottomMenu addSubview:icon];
    //频率和亮度view
    UISlider *rateSlider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+10, CGRectGetMinY(icon.frame), FullScreen_width-100, 27)];
    [rateSlider setThumbImage:[UIImage imageNamed:@"slider_btn"] forState:UIControlStateNormal];
    rateSlider.minimumTrackTintColor = [UIColor whiteColor];
    [bottomMenu addSubview:rateSlider];
    
    UIImageView *icon2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"color_brightness"]];
    icon2.frame = CGRectMake(CGRectGetMinX(icon.frame), CGRectGetMaxY(icon.frame)+33, 27, 27);
    [bottomMenu addSubview:icon2];

    UISlider *brightSlider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon2.frame)+10, CGRectGetMinY(icon2.frame), FullScreen_width-100, 27)];
    [brightSlider setThumbImage:[UIImage imageNamed:@"slider_btn"] forState:UIControlStateNormal];
    brightSlider.minimumTrackTintColor = [UIColor whiteColor];
    [brightSlider addTarget:self action:@selector(brightnessCondition:) forControlEvents:UIControlEventValueChanged];
    [bottomMenu addSubview:brightSlider];
    
    
    
    [self setupNavBtns];
    [self setupColorPicker];
    [self setupBrightnessPicker];
    [self setupColorTmpPicker];
}

- (void)setupColorPicker
{
    UIView *pickBackView = [[UIView alloc] initWithFrame:CGRectMake(45, FullScreen_height/2 - 170*FullScreen_height/568, FullScreen_width - 80, FullScreen_width - 80)];
    pickBackView.backgroundColor = [UIColor colorWithWhite:1 alpha:.27];
    pickBackView.layer.cornerRadius = 4;
    
    
    colorPicker = [[JKColorPicker alloc] initWithFrame:CGRectMake(0, 0, 182, 182)];
    colorPicker.layer.cornerRadius = 91;
    [colorPicker addTarget:self action:@selector(pickColor:) forControlEvents:UIControlEventAllEvents];
//    colorPicker.backgroundColor = [UIColor whiteColor];
    colorPicker.center = CGPointMake(CGRectGetWidth(pickBackView.frame)/2, CGRectGetWidth(pickBackView.frame)/2);
    [pickBackView addSubview:colorPicker];
    
    [_mainScrollView addSubview:pickBackView];
    
    UIButton *defineBtn = [[UIButton alloc] initWithFrame:CGRectMake(FullScreen_width/2-30, CGRectGetMaxY(pickBackView.frame)+10, 60, 30)];
    defineBtn.layer.cornerRadius = 15;
    defineBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    defineBtn.layer.borderWidth = .5;
    [defineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [defineBtn setTitle:@"自定义" forState:UIControlStateNormal];
    defineBtn.titleLabel.font = Font(14);
    [defineBtn addTarget:self action:@selector(showDefineColorView) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:defineBtn];
    
    
    UIScrollView *defaultColorView = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMinX(pickBackView.frame), CGRectGetMaxY(defineBtn.frame) + 20, CGRectGetWidth(pickBackView.frame), 50)];
    defaultColorView.backgroundColor = [UIColor whiteColor];
    defaultColorView.contentSize = CGSizeMake(320, 50);
    [_mainScrollView addSubview:defaultColorView];
    
    
    for (int i = 0; i < 8; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(40*i, 0, 40, 50)];
        btn.backgroundColor = @[[UIColor colorWithHexString:@"77baef"],[UIColor colorWithHexString:@"807cd1"],
                                [UIColor colorWithHexString:@"fe6ac8"],[UIColor colorWithHexString:@"7330d5"],
                                [UIColor colorWithHexString:@"0db4eb"],[UIColor colorWithHexString:@"3fc765"],
                                [UIColor colorWithHexString:@"f88264"],[UIColor colorWithHexString:@"f1a663"]][i];
        [btn addTarget:self action:@selector(selectDefaultColor:) forControlEvents:UIControlEventTouchUpInside];
        [defaultColorView addSubview:btn];
    }
    
    
    
}

- (void)setupBrightnessPicker
{
    UIView *pickBackView = [[UIView alloc] initWithFrame:CGRectMake(45+FullScreen_width, FullScreen_height/2 - 170*FullScreen_height/568, FullScreen_width - 80, FullScreen_width - 80)];
    pickBackView.backgroundColor = [UIColor colorWithWhite:1 alpha:.27];
    pickBackView.layer.cornerRadius = 4;
    [_mainScrollView addSubview:pickBackView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36*6, 110)];
    view.center = CGPointMake(CGRectGetWidth(pickBackView.frame)/2, CGRectGetHeight(pickBackView.frame)/2);
    
    for (int i = 0; i < 12; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(36 * (i%6), i/6 * 60 , 36, 50)];
        [button addTarget:self action:@selector(brightnessClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i+1;
        button.backgroundColor = [UIColor colorWithWhite:(1.0 - i / 12.0) alpha:1];
        [view addSubview:button];
    }
    
    [pickBackView addSubview:view];

}

- (void)setupColorTmpPicker
{
    UIView *pickBackView = [[UIView alloc] initWithFrame:CGRectMake(45 + FullScreen_width*2, FullScreen_height/2 - 170*FullScreen_height/568, FullScreen_width - 80, FullScreen_width - 80)];
    pickBackView.backgroundColor = [UIColor colorWithWhite:1 alpha:.27];
    pickBackView.layer.cornerRadius = 4;
    pickBackView.userInteractionEnabled = YES;
    [_mainScrollView addSubview:pickBackView];
    
    
    
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(25, CGRectGetHeight(pickBackView.frame)/2 - 20, CGRectGetWidth(pickBackView.frame)-60, 40)];
    [slider setThumbImage:[UIImage imageNamed:@"slider_btn"] forState:UIControlStateNormal];
    slider.minimumTrackTintColor = [UIColor yellowColor];
    [slider addTarget:self action:@selector(ctChange:) forControlEvents:UIControlEventValueChanged];
    [pickBackView addSubview:slider];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ct_icon"]];
    icon.frame = CGRectMake(5, CGRectGetMinY(slider.frame), 9, 28);
    [pickBackView addSubview:icon];
    
    ctValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(slider.frame)+5, CGRectGetMinY(slider.frame), 30, 40)];
    ctValue.font = Font(12);
    ctValue.textColor = [UIColor whiteColor];
    [pickBackView addSubview:ctValue];

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more_menu"] style:UIBarButtonItemStyleDone target:self action:@selector(showTopMenu)];
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
    
    [topMenu dismissMenu];
    [bottomMenu dismissMenu];
    if (page == 0) {
        topLightView.conditionBtn.enabled = YES;
    } else {
        topLightView.conditionBtn.enabled = NO;
    }
    
    [UIView animateWithDuration:.25 animations:^{
        _mainScrollView.contentOffset = CGPointMake(FullScreen_width * page, _mainScrollView.contentOffset.y);
    }];
    
    
}

#pragma mark -选择颜色
- (void)pickColor:(JKColorPicker *)picker
{
    [self sendColorToDevice:picker.selectColor];
    [topLightView setLightColor:picker.selectColor];
    
}

- (void)brightnessCondition:(UISlider *)slider
{
    [self sendDataBright:(Byte)(slider.value * 100)];
}

#pragma mark -选择内置颜色
- (void)selectDefaultColor:(UIButton *)button
{
    [self sendColorToDevice:button.backgroundColor];
    [topLightView setLightColor:button.backgroundColor];
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    tmpView.center = CGPointMake(colorPicker.superview.superview.center.x, colorPicker.superview.superview.center.y);
    tmpView.backgroundColor = button.backgroundColor;
    tmpView.layer.cornerRadius = 25;
    [self.view addSubview:tmpView];
    
    [UIView animateWithDuration:.25 animations:^{
        tmpView.frame = CGRectMake(topLightView.center.x, topLightView.center.y, 1, 1);
        tmpView.alpha = 0;
    } completion:^(BOOL finished) {
        [tmpView removeFromSuperview];
    }];
    
    
    

}

#pragma mark -单色调节
- (void)brightnessClick:(UIButton *)button
{
    [self sendDataDMBright:100 - 100.0/12.0 * button.tag];
    [topLightView setLightColor:button.backgroundColor];
}

- (void)showTopMenu
{
    [topMenu showMenu];
}

- (void)showBottomMenu
{
    [bottomMenu showMenu];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x + 10;
    DLog(@"x:%f",x);
    NSInteger page = x/FullScreen_width;
    UIButton *btn = titleBtnArray[page];
    [self clickTitleBtn:btn];
}

#pragma mark -top light delegate
- (void)offOnBtnClick:(UIButton *)offOnButton
{
    if (offOnButton.selected) {
        [self openLight];
        [topLightView setLightColor:[UIColor whiteColor]];

    } else {
        [self closeLight];
        [topLightView setLightColor:[UIColor lightGrayColor]];
    }
}

- (void)conditionBtnClick:(UIButton *)conditionBtn
{
    [self showBottomMenu];
}

#pragma mark -色温调节
- (void)ctChange:(UISlider *)slider
{
    [self sendDataCTWithHot:(Byte)(slider.value * 100) cold:(100-(Byte)(slider.value * 100))];
    ctValue.text = [NSString stringWithFormat:@"%d",(int)(slider.value * 100)];
}

- (void)showMusicView
{
    [topMenu dismissMenu];
    JKMusicViewController *vc = [[JKMusicViewController alloc] init];
    JKNavigationController *nav = [[JKNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)showTimerView
{
    [topMenu dismissMenu];
    JKTimerViewController *vc = [[JKTimerViewController alloc] init];
    JKNavigationController *nav = [[JKNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)showDefineColorView
{
    JKModeListViewController *vc = [[JKModeListViewController alloc] init];
    JKNavigationController *nav = [[JKNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
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

- (void)sendCMD:(NSData*)data
{
    for (CBPeripheral *per in _deviceArray)
    {
        [per writeValue:data forCharacteristic:_writeCharacter type:CBCharacteristicWriteWithoutResponse];
    }
}

- (void)sendDataBright:(Byte)brightness
{
    
    Byte byte[] = {0x7e,0x04,0x01,brightness==100?99:brightness,0xff,0xff,0xff,0x00,0xef};
    NSData *data = [[NSData alloc]initWithBytes:byte length:9];
    [self sendCMD:data];

    
    NSLog(@"-------RGB---bright:%d-",brightness);
//    const CGFloat *color =  CGColorGetComponents(_picker.selectedColor.CGColor);
//    
//    if (color != nil)
//    {
//        
//        NSLog(@"rgb:%f %f %f",color[0]*255,color[1]*255,color[2]*255);
//        
//    }
}

- (void)sendDataRGBWithRed:(Byte)red green:(Byte)green blue:(Byte)blue
{
    
    Byte byte[] = {0x7e,0x07,0x05,0x03,red,green,blue,0x0,0xef};
    
    NSData *data = [[NSData alloc]initWithBytes:byte length:sizeof(byte)];
    [self sendCMD:data];
    
    NSLog(@"-------RGB---red:%d- green:%d- blue:%d-",red,green,blue);
    
}

- (void)sendDataCTWithHot:(Byte)hot cold:(Byte)cold
{
    
    Byte byte[] = {0x7e,0x06,0x05,0x02,hot,cold,0xff,0x08,0xef};
    NSData *data = [[NSData alloc]initWithBytes:byte length:9];
    
    NSLog(@"-------CT---hot:%d-cold:%d-",hot,cold);
    [self sendCMD:data];
    
    
}

//单色模式
- (void)sendDataDMBright:(Byte)brightness
{

    Byte byte[] = {0x7e,0x05,0x05,0x01,brightness,0xff,0xff,0x08,0xef};
    NSData *data = [[NSData alloc]initWithBytes:byte length:9];
    [self sendCMD:data];
    
    NSLog(@"-------RGB---bright:%d-",brightness);
}



- (void)sendColorToDevice:(UIColor *)color
{
    const CGFloat *colorZone =  CGColorGetComponents(color.CGColor);
    
    if (color != nil)
    {
        [self sendDataRGBWithRed:colorZone[0]*255 green:colorZone[1]*255 blue:colorZone[2]*255];
    }
    

}

@end
