//
//  JKLEDSendDataDelegate.h
//  LED Colors
//
//  Created by wzq on 14/6/19.
//  Copyright (c) 2014年 wzq. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JKLEDSendDataDelegate <NSObject>

@optional
- (void)sendDataRGBWithRed:(Byte)red green:(Byte)green blue:(Byte)blue;
@optional
- (void)sendDataCTWithHot:(Byte)hot cold:(Byte)cold;
@optional
- (void)sendDataBright:(Byte)brightness;
@optional
- (void)sendDataModelWithValue:(Byte)value modeName:(JKLightType)lightType;
@optional
- (void)sendDataSpeedWithValue:(Byte)speed;

//TODO spi 数据发送
@end
