//
//  JKControlViewController.m
//  BlueToothBLE
//
//  Created by wzq on 15/11/13.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKControlViewController.h"
#import "JKTopLightView.h"

@interface JKControlViewController ()

@end

@implementation JKControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg"]];
}

- (void)setupUI
{
    _mainScrollView.contentSize = CGSizeMake(FullScreen_width*3, FullScreen_height);
    _mainScrollView.backgroundColor = [UIColor clearColor];
    
    JKTopLightView *top = [[JKTopLightView alloc] initWithFrame:CGRectMake(0, 0, FullScreen_width, 100)];
    [_mainScrollView addSubview:top];
    
    
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
