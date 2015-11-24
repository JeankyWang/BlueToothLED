//
//  JKBLEsManager.h
//  BlueToothBLE
//
//  Created by wzq on 15/11/24.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface JKBLEsManager : NSObject
@property (nonatomic,strong) NSMutableArray *allBLEArray;
@property (nonatomic,strong) CBCharacteristic *writeCharacter;
+ (JKBLEsManager *)sharedInstance;
@end
