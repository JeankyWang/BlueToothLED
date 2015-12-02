//
//  JKTimerViewController.h
//  fancyColor-BLE
//
//  Created by wzq on 14/8/19.
//  Copyright (c) 2014年 wzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKTimePickerViewController.h"

@interface JKTimerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,JKTimerPickerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


- (IBAction)dismissVC:(id)sender;

@end
