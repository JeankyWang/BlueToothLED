//
//  JKSceneViewCell.h
//  BlueToothBLE
//
//  Created by wzq on 15/11/5.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKSceneViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *themeImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *lightBtn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@end
