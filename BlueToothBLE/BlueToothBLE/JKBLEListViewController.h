//
//  JKBLEListViewController.h
//  fancyColor-BLE
//
//  Created by wzq on 14/8/16.
//  Copyright (c) 2014年 wzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreBluetooth/CoreBluetooth.h"


@protocol JKBLEListSelectDelegate <NSObject>

- (void)selectBLE:(id)pers groupNo:(NSInteger)row;
- (void)unbindByRow:(NSInteger)row;

@end
@interface JKBLEListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>


@property (assign) id<JKBLEListSelectDelegate> delegate;
@property (strong,nonatomic) UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *perArray;
@property NSInteger rowNum;
@property (strong,nonatomic) NSArray *selectedDevices;

@end
