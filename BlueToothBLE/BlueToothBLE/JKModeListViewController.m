//
//  JKModeListViewController.m
//  LED Colors
//
//  Created by wzq on 14/6/30.
//  Copyright (c) 2014年 wzq. All rights reserved.
//

#import "JKModeListViewController.h"
#import "JKDefineMenuView.h"
#import "JKColorPicker.h"
#import "JKSendDataTool.h"

@interface JKModeListViewController ()
{
    UISegmentedControl *segmentView;
    double begin;
    
    JKDefineMenuView *bottomMenu;
    UIButton *currentAddBtn;
    NSMutableArray *colorBtnArray;
    
}
@end

@implementation JKModeListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"自定义";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close_nav"] style:UIBarButtonItemStyleBordered target:self action:@selector(dismissSelf)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    
    
    _colorsArray = [NSMutableArray array];


    [self initView];
    
}

- (void)initView
{
    UILabel *info = [[UILabel alloc]initWithFrame:CGRectMake(0, 100*PhoneScale, FullScreen_width, 20)];
    info.backgroundColor = [UIColor clearColor];
    info.text = @"添加自定义颜色组合";
    info.textAlignment = NSTextAlignmentCenter;
    info.font = [UIFont systemFontOfSize:14];
    info.textColor = [UIColor whiteColor];
    [self.view addSubview:info];
    
    int length = 260;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(FullScreen_width/2-length/2, FullScreen_height/2-length/2, length, length)];


    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    view.layer.cornerRadius = 5;
    [self.view addSubview:view];
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(delColor:)];
    gesture.minimumPressDuration = 1;
    
    for (int i =0; i < 16; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15 + (i%4) * 60, i/4 * 60 +15, 50, 50)];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.cornerRadius = 4;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(colorPicker:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(clickBegin:) forControlEvents:UIControlEventTouchDown];
        btn.tag = i+100;

        [btn setTitle:@"+" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addSubview:btn];
        
    }
    
    //底部弹出色盘
    bottomMenu = [[JKDefineMenuView alloc] initWithFrame:CGRectMake(0, FullScreen_height-300, FullScreen_width, 300) inView:self.view];
    bottomMenu.style = JKDefineMenuViewBottom;
    bottomMenu.backgroundColor = [UIColor colorWithWhite:0 alpha:.1];

    JKColorPicker *colorPicker = [[JKColorPicker alloc] initWithFrame:CGRectMake(0, 0, 182, 182)];
    colorPicker.center = CGPointMake(CGRectGetWidth(bottomMenu.frame)/2, CGRectGetHeight(bottomMenu.frame)/2-20);
    [colorPicker addTarget:self action:@selector(chooseColor:) forControlEvents:UIControlEventTouchUpInside];
    [bottomMenu addSubview:colorPicker];
    
 
}

- (void)doneAction
{
    [self runWithColor];
    

}

- (void)showBottomMenu
{
    [bottomMenu showMenu];
}

- (void)hideBottomMenu
{
    [bottomMenu dismissMenu];
}



- (void)chooseColor:(JKColorPicker *)picker
{
    currentAddBtn.backgroundColor = picker.selectColor;
}

- (void)colorPicker:(UIButton *)btn
{
    currentAddBtn = btn;
    double end = [[NSDate date] timeIntervalSince1970] - begin;
    if (end > 0.5) {
        [self delColor:btn];
        return;
    } else {
        [self showBottomMenu];
    }

}


- (void)getColor:(UIColor *)color tag:(int)tag
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:tag];
    btn.backgroundColor = color;
    [btn setTitle:@"" forState:UIControlStateNormal];
}

- (void)dismissSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickBegin:(UIButton *)btn
{
    begin = [[NSDate date] timeIntervalSince1970];
}



- (void)delColor:(UIButton *)btn
{
    [btn setTitle:@"+" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
}

- (void)runWithColor
{
    for (int i = 0; i<16; i++) {
        UIView *view = [self.view viewWithTag:100+i];
        if (view.backgroundColor != [UIColor clearColor]) {
            [_colorsArray addObject:view.backgroundColor];
        }
    }
    
    
    if ([_delegate respondsToSelector:@selector(selectdColorArray:)]) {
        
        [_delegate selectdColorArray:_colorsArray];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        [[JKSendDataTool shareInstance] sendDataLightType:JKLightChangeModeFlash speed:20 colorCount:_colorsArray.count devices:_devices];
        
        __block NSMutableArray *tmpArray = _colorsArray;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            Byte colors[48];
            for (int i = 0; i < tmpArray.count; i++) {
                UIColor *color = tmpArray[i];
                const CGFloat *colorZone =  CGColorGetComponents(color.CGColor);
                colors[i*3] = (Byte)(colorZone[0]*255);
                colors[i*3+1] = (Byte)(colorZone[1]*255);
                colors[i*3+2] = (Byte)(colorZone[2]*255);
            }
            
            NSData *data = [[NSData alloc] initWithBytes:&colors length:_colorsArray.count * 3];
            [[JKSendDataTool shareInstance] sendCMD:data devices:_devices];
        });
        
        [self dismissSelf];

    }
}

@end
