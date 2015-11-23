//
//  JKSaveSceneTool.h
//  BlueToothBLE
//
//  Created by klicen on 15/11/23.
//  Copyright © 2015年 beimu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKSaveSceneTool : NSObject
- (void)archiveScene:(NSArray *)array withKey:(NSString *)key;
- (NSMutableArray *)unarchiveBrandsIconWithKey:(NSString *)key;

+ (JKSaveSceneTool *)sharedInstance;
@end
