//
//  JKSceneModel.m
//  BlueToothBLE
//
//  Created by klicen on 15/11/23.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKSceneModel.h"

@implementation JKSceneModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.imgName = [aDecoder decodeObjectForKey:@"imgName"];
        self.devices = [aDecoder decodeObjectForKey:@"devices"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.imgName forKey:@"imgName"];
    [aCoder encodeObject:self.devices forKey:@"devices"];
}
@end
