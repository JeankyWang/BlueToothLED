//
//  JKBLEsManager.m
//  BlueToothBLE
//
//  Created by wzq on 15/11/24.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKBLEsManager.h"

@implementation JKBLEsManager
#pragma mark - 单例模式,线程安全
//单例
static JKBLEsManager *singleton;
+ (JKBLEsManager *)sharedInstance
{
    // dispatch_once不仅意味着代码仅会被运行一次，而且还是线程安全的
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        singleton = [[super allocWithZone:NULL] init];
    });
    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}


@end
