//
//  JKSceneModel.m
//  BlueToothBLE
//
//  Created by jkjk on 15/11/23.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKSceneModel.h"

@implementation JKSceneModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.devices = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.imgName = [aDecoder decodeObjectForKey:@"imgName"];
        self.devices = [aDecoder decodeObjectForKey:@"devices"];
        self.openTime = [aDecoder decodeObjectForKey:@"openTime"];
        self.closeTime = [aDecoder decodeObjectForKey:@"closeTime"];
        self.isOpenSet = [aDecoder decodeBoolForKey:@"isOpenSet"];
        self.isCloseSet = [aDecoder decodeBoolForKey:@"isCloseSet"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.imgName forKey:@"imgName"];
    [aCoder encodeObject:self.devices forKey:@"devices"];
    [aCoder encodeObject:self.openTime forKey:@"openTime"];
    [aCoder encodeObject:self.closeTime forKey:@"closeTime"];
    [aCoder encodeBool:self.isOpenSet forKey:@"isOpenSet"];
    [aCoder encodeBool:self.isCloseSet forKey:@"isCloseSet"];
}
@end
