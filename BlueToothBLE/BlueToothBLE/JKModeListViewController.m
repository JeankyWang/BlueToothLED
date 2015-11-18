//
//  JKModeListViewController.m
//  LED Colors
//
//  Created by wzq on 14/6/30.
//  Copyright (c) 2014年 wzq. All rights reserved.
//

#import "JKModeListViewController.h"

@interface JKModeListViewController ()
{
    UISegmentedControl *segmentView;
    double begin;
    
}
@end

@implementation JKModeListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Select colors", @"");
    UIImageView *bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.png"]];
    bgImage.frame = self.view.frame;
    [self.view addSubview:bgImage];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"RUN", @"") style:UIBarButtonItemStyleDone target:self action:@selector(runWithColor)];
    self.navigationItem.rightBarButtonItem = item;
    
    _colorsArray = [NSMutableArray arrayWithCapacity:0];


    [self initView];
    
}

- (void)initView
{
    UILabel *info = [[UILabel alloc]initWithFrame:CGRectMake(30, 24, 280, 80)];
    info.backgroundColor = [UIColor clearColor];
    info.text = NSLocalizedString(@"info", @"");
    info.numberOfLines = 0;
    info.lineBreakMode = NSLineBreakByWordWrapping;
    info.font = [UIFont systemFontOfSize:14];
    info.textColor = [UIColor whiteColor];
    [self.view addSubview:info];
    
    int length = 260;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(FullScreen_width/2-length/2, 90, length, length)];


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
//        [btn addTarget:self action:@selector(clickEnd:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+100;

        [btn setTitle:@"+" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addSubview:btn];
        
    }
 
}

- (void)colorPicker:(UIButton *)btn
{
    
    double end = [[NSDate date] timeIntervalSince1970] - begin;
    if (end > 0.5) {
        [self delColor:btn];
        return;
    }
    NSLog(@"end:%f",end);

}


- (void)getColor:(UIColor *)color tag:(int)tag
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:tag];
    btn.backgroundColor = color;
    [btn setTitle:@"" forState:UIControlStateNormal];
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
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end
