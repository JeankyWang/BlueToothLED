//
//  JKBLEManager.m
//  fancyColor-BLE
//
//  Created by wzq on 14/8/19.
//  Copyright (c) 2014年 wzq. All rights reserved.
//

#import "JKBLEManager.h"

@implementation JKBLEManager
static JKBLEManager *shareInstance = nil;

+ (JKBLEManager *)shareInstance
{
    @synchronized(self)
    {
        if (shareInstance == nil)
        {
            shareInstance =  [[super allocWithZone:NULL] init];
        }
    }
    return shareInstance;
}


+ (id)allocWithZone:(NSZone *)zone {
    return [self shareInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)init {
    self = [super init];
    _writeCharacteristic = [NSMutableArray new];
    return self;
}

@end
