//
//  JKSendDataTool.h
//  BlueToothBLE
//
//  Created by jkjk on 15/12/2.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, JKLightChangeMode) {
    ///渐变
    JKLightChangeModeShade = 1,
    
    ///跳变
    JKLightChangeModeJump = 2,
    
    ///爆闪
    JKLightChangeModeFlash = 3
};

@interface JKSendDataTool : NSObject

+ (JKSendDataTool *)shareInstance;
- (void)openLight:(NSArray *)deviceArray;
- (void)closeLight:(NSArray *)deviceArray;
- (void)sendDataBright:(Byte)brightness devices:(NSArray *)deviceArray;
- (void)sendDataRGBWithRed:(Byte)red green:(Byte)green blue:(Byte)blue devices:(NSArray *)deviceArray;
- (void)sendDataCTWithHot:(Byte)hot cold:(Byte)cold devices:(NSArray *)deviceArray;
- (void)sendDataDMBright:(Byte)brightness devices:(NSArray *)deviceArray;
- (void)sendDataSpeedWithValue:(Byte)speed devices:(NSArray *)deviceArray;
- (void)sendDataModelWithValue:(Byte)value devices:(NSArray *)deviceArray;//彩色内置模式

///自定义模式
- (void)sendDataLightType:(JKLightChangeMode)mode speed:(NSInteger)speed colorCount:(NSInteger)count devices:(NSArray *)deviceArray;

- (void)sendCMD:(NSData*)data devices:(NSArray *)deviceArray;
@end
