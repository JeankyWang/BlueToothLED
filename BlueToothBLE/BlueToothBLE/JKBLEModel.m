//
//  JKBLEModel.m
//  BlueToothBLE
//
//  Created by jkjk on 15/11/23.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import "JKBLEModel.h"

@implementation JKBLEModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.rename = [aDecoder decodeObjectForKey:@"rename"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.rename forKey:@"rename"];
}
@end
