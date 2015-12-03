//
//  JKHelpViewController.m
//  BlueToothBLE
//
//  Created by klicen on 15/12/1.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKHelpViewController.h"

@interface JKHelpViewController ()

@end

@implementation JKHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"帮助";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg"]];
    self.webView.frame = self.view.bounds;
    self.webView.backgroundColor = [UIColor clearColor];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Help" ofType:@"html"];
    //以utf8的编码格式加载html内容
    NSString *htmlString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    //self.wbProblems.scalesPageToFit = YES;
    //将文字内容显示到webview控件上
    [self.webView loadHTMLString: htmlString baseURL: [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
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
