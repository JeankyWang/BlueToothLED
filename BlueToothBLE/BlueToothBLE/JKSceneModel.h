//
//  JKSceneModel.h
//  BlueToothBLE
//
//  Created by klicen on 15/11/23.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKSceneModel : NSObject<NSCoding>
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *imgName;
@property (nonatomic,strong) NSMutableArray *devices;
@end
