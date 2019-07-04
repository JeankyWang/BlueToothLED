//
//  JKSaveSceneTool.m
//  BlueToothBLE
//
//  Created by jkjk on 15/11/23.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKSaveSceneTool.h"

@implementation JKSaveSceneTool

#pragma mark - 单例模式,线程安全
//单例
static JKSaveSceneTool *singleton;
+ (JKSaveSceneTool *)sharedInstance
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

- (void)archiveScene:(NSArray *)array withKey:(NSString *)key
{
    NSString *path = [self dataFilePathWithName:key];
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:array forKey:key];
    [archiver finishEncoding];
    [data writeToFile:path atomically:YES];
}

- (NSMutableArray *)unarchiveBrandsIconWithKey:(NSString *)key
{
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:[self dataFilePathWithName:key]];
    if (!data) {
        return nil;
    }
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSArray *array = [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    return [NSMutableArray arrayWithArray:array];
}

- (NSString *)dataFilePathWithName:(NSString *)name
{
    NSString *tempPath = [NSString stringWithFormat:@"%@/cache/BLE",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    NSFileManager *fileMng = [NSFileManager defaultManager];
    BOOL isDir = YES;
    BOOL isExsist = [fileMng fileExistsAtPath:tempPath isDirectory:&isDir];
    if (!isExsist) {
        [fileMng createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    return [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name]];
}
@end
