//
//  JKSendDataTool.h
//  BlueToothBLE
//
//  Created by klicen on 15/12/2.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKSendDataTool : NSObject
+ (JKSendDataTool *)shareInstance;
- (void)openLight:(NSArray *)deviceArray;
- (void)closeLight:(NSArray *)deviceArray;
- (void)sendDataBright:(Byte)brightness devices:(NSArray *)deviceArray;
- (void)sendDataRGBWithRed:(Byte)red green:(Byte)green blue:(Byte)blue devices:(NSArray *)deviceArray;
- (void)sendDataCTWithHot:(Byte)hot cold:(Byte)cold devices:(NSArray *)deviceArray;
- (void)sendDataDMBright:(Byte)brightness devices:(NSArray *)deviceArray;









@end
