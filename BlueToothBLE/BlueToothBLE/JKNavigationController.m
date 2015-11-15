//
//  JKNavigationController.m
//  BlueToothBLE
//
//  Created by wzq on 15/11/13.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKNavigationController.h"

@interface JKNavigationController ()

@end

@implementation JKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.selectedImageTintColor = [UIColor whiteColor];
    self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"back_nav"];
    self.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back_nav"];
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
