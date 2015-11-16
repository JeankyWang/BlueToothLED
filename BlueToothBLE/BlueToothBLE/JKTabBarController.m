//
//  JKTabBarController.m
//  BlueToothBLE
//
//  Created by klicen on 15/11/16.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKTabBarController.h"

@interface JKTabBarController ()

@end

@implementation JKTabBarController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tabBar.tintColor = [UIColor whiteColor];
    
    //tabbar icon 按照原始颜色显示 good
    for (UITabBarItem *item in self.tabBar.items) {
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

  
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
